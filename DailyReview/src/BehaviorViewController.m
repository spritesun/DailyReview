#import "BehaviorViewController.h"
#import "BehaviorTableViewCell.h"
#import "UIGestureRecognizer+Blocks.h"
#import "UIView+Additions.h"
#import "BindingManager.h"
#import "NSManagedObjectContext+Additions.h"
#import "UITableView+Additions.h"
#import "NSDate+Additions.h"
#import "UIImage+Additions.h"
#import "ScoreView.h"
#import "Event.h"

@interface BehaviorViewController () <UITableViewAdditionDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSDate *currentDate;
@end

@implementation BehaviorViewController {
    BindingManager *bindingManager_;
    UIImageView *hintView_;
    UIImageView *increaseView_;
    UIImageView *decreaseView_;
}

@synthesize scoreView = scoreView_, tableView = tableView_;

#pragma mark - LifeCycles

- (UIImageView *)createTransparentView:(NSString *)imageName {
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    view.alpha = 0;
    return view;
}

- (void)createHintView {
    hintView_ = [self createTransparentView:@"swipe-hint"];
    [self.tableView addSubview:hintView_];
    increaseView_ = [self createTransparentView:@"increase-hint"];
    [self.tableView addSubview:increaseView_];
    decreaseView_ = [self createTransparentView:@"decrease-hint"];
    [self.tableView addSubview:decreaseView_];
}

- (void)setBarItem:(UITabBarItem *)barItem withImage:(UIImage *)image {
    UIImage *disabledImage = [image grayish];
    [barItem setFinishedSelectedImage:image withFinishedUnselectedImage:disabledImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"behavior-view-bg"]];
    self.view.backgroundView.frame = tableView_.frame;
    tableView_.delegate = self;
    tableView_.dataSource = self;
    bindingManager_ = [BindingManager new];
    [self createHintView];
    [self addGestures];
}


//TODO: could remove as iOS 6 deprecated this
- (void)viewDidUnload {
    tableView_.delegate = nil;
    tableView_.dataSource = nil;
    bindingManager_ = nil;
    hintView_ = nil;
    increaseView_ = nil;
    decreaseView_ = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshView];
}

- (void)refreshView {
    if (![self.currentDate isEqualToDate:[[NSDate date] dateWithoutTime]]) {
        self.currentDate = [[NSDate date] dateWithoutTime];
    }
    [self.resultsController performFetch];
    [[self tableView] reloadData];
    [[self tableView] setContentOffset:CGPointZero animated:YES];
    [[self tableView] layoutIfNeeded];//MAYBE unnecessary but I am lazy to verify again
    [self updateScore];
}

- (void)updateScore {
    [scoreView_ setMeritCount:[[BehaviorResultsController sharedMeritResultsController] todayRank]
                 demeritCount:[[BehaviorResultsController sharedDemeritResultsController] todayRank]];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: avoid create empty event for every behavior everyday.
    BehaviorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BehaviorTableViewCell class])];
    if (nil == cell) {
        cell = [BehaviorTableViewCell cell];
    }

    Behavior *behavior = [self.resultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = behavior.name;
    [cell displayEventCount:[behavior eventForDate:self.currentDate].count];
    return cell;
}

- (void)tableView:(UITableView *)tableView willRemoveCell:(UITableViewCell *)cell {
    [cell removeAllGestureRecognizers];
    Behavior *behavior = [self.resultsController objectAtIndexPath:[tableView indexPathForCell:cell]];
    [bindingManager_ unbindSource:[behavior eventForDate:self.currentDate]];
}

- (void)showHintAnimation:(CGPoint)touchPoint {
    hintView_.origin = touchPoint;
    hintView_.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        hintView_.alpha = 0.0;
        hintView_.left = touchPoint.x + 50;
    }];
}

- (void)transformAnimationOn:(UIImageView *)view From:(CGRect)fromRect to:(CGRect)toRect {
    view.frame = fromRect;
    view.alpha = 1.0;
    view.clipsToBounds = YES;
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = toRect;
    }                completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            view.alpha = 0;
        }];
    }];
}

- (void)showIncreaseAnimation:(CGPoint)point {
    CGFloat imageHeight = increaseView_.image.size.height;
    CGRect beginRect = CGRectMake(point.x, point.y - imageHeight / 2., 0, imageHeight);
    CGRect endRect = CGRectMake(point.x, point.y - imageHeight / 2., increaseView_.image.size.width, imageHeight);
    increaseView_.contentMode = UIViewContentModeLeft;
    [self transformAnimationOn:increaseView_ From:beginRect to:endRect];
}

- (void)showDecreaseAnimation:(CGPoint)point {
    CGFloat imageHeight = decreaseView_.image.size.height;
    CGFloat imageWidth = decreaseView_.image.size.width;
    CGRect beginRect = CGRectMake(point.x, point.y - imageHeight / 2., 0, imageHeight);
    CGRect endRect = CGRectMake(point.x - imageWidth, point.y - imageHeight / 2., imageWidth, imageHeight);
    decreaseView_.contentMode = UIViewContentModeRight;
    [self transformAnimationOn:decreaseView_ From:beginRect to:endRect];
}

- (void)addGestures {
    __weak typeof (self) weakSelf = self;

    UIGestureRecognizer *hintRecognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
        [weakSelf showHintAnimation:[theRecognizer locationInView:weakSelf.tableView]];
    }];
    [self.tableView addGestureRecognizer:hintRecognizer];


    UISwipeGestureRecognizer *increaseRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    increaseRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:increaseRecognizer];

    UISwipeGestureRecognizer *decreaseRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    decreaseRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:decreaseRecognizer];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    CGPoint touchPoint = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    BehaviorTableViewCell *cell = (BehaviorTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    Behavior *behavior = [self.resultsController objectAtIndexPath:indexPath];

    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showIncreaseAnimation:touchPoint];
        [behavior increaseEventForDate:self.currentDate];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showDecreaseAnimation:touchPoint];
        [behavior decreaseEventForDate:self.currentDate];
    }
    [context save];
    [cell displayEventCount:[behavior eventForDate:self.currentDate].count];
    [self updateScore];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.resultsController fetchedObjects] count];
}


@end
