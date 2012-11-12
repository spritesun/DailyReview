#import "BehaviorViewController.h"
#import "BehaviorTableViewCell.h"
#import "UIGestureRecognizer+Blocks.h"
#import "UIView+Additions.h"
#import "BindingManager.h"
#import "UITableView+Additions.h"
#import "NSDate+Additions.h"
#import "UIImage+Additions.h"
#import "ScoreView.h"
#import "Event.h"
#import "AddOrEditBehaviorController.h"
#import "NSManagedObjectContext+Additions.h"
#import "FullPageTextView.h"
#import "NSString+Additions.h"

@interface BehaviorViewController () <UITableViewAdditionDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    NSInteger _editingRow;
}
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) UIView *actionPanel;
@property(nonatomic, strong) UIButton *annotationBtn;
@property(nonatomic, strong) UIButton *minusBtn;
@property(nonatomic, strong) UIButton *editBtn;
@property(nonatomic, strong) UIButton *removeBtn;

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

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.right = self.view.right - 5;
    [addButton addTarget:self action:@selector(addBehavior) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
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
    [self dismissActionPanel:NO];
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
    if (_editingRow != -1) {
        [self dismissActionPanel:YES];
    } else {
        hintView_.origin = touchPoint;
        hintView_.alpha = 1.0;
        [UIView animateWithDuration:1.0 animations:^{
            hintView_.alpha = 0.0;
            hintView_.left = touchPoint.x + 50;
        }];
    }

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
    if (_editingRow != -1) {
        [self dismissActionPanel:YES];
    } else {
        CGFloat imageHeight = increaseView_.image.size.height;
        CGRect beginRect = CGRectMake(point.x, point.y - imageHeight / 2., 0, imageHeight);
        CGRect endRect = CGRectMake(point.x, point.y - imageHeight / 2., increaseView_.image.size.width, imageHeight);
        increaseView_.contentMode = UIViewContentModeLeft;
        [self transformAnimationOn:increaseView_ From:beginRect to:endRect];
    }
}

- (void)showDecreaseAnimation {
    CGPoint cellOrigin = [self.tableView rectForRowAtIndexPath:[self editingIndexPath]].origin;
    CGFloat imageHeight = decreaseView_.image.size.height;
    CGFloat imageWidth = decreaseView_.image.size.width;
    CGRect beginRect = CGRectMake(130 + imageWidth, cellOrigin.y + 5, 0, imageHeight);
    CGRect endRect = CGRectMake(130, cellOrigin.y + 5, imageWidth, imageHeight);
    decreaseView_.contentMode = UIViewContentModeRight;
    [self.tableView bringSubviewToFront:decreaseView_];
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
    CGPoint touchPoint = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    BehaviorTableViewCell *cell = (BehaviorTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    Behavior *behavior = [self.resultsController objectAtIndexPath:indexPath];

    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showIncreaseAnimation:touchPoint];
        [behavior increaseEventForDate:self.currentDate];
        [cell displayEventCount:[behavior eventForDate:self.currentDate].count];
        [self updateScore];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showActionPanel:indexPath];
    }
}

- (void)dismissActionPanel:(BOOL)animated {
    _editingRow = -1;
    [UIView animateWithDuration:(animated ? .2 : 0) animations:^{
        self.actionPanel.left = self.tableView.right;
    }];
}

- (void)showActionPanel:(NSIndexPath *)indexPath {
    if (_editingRow == indexPath.row) {
        return;
    }
    _editingRow = indexPath.row;

    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    self.actionPanel.left = self.tableView.right;
    self.actionPanel.top = cellRect.origin.y - 1;
    [self refreshActionPanel];
    [self.tableView bringSubviewToFront:self.actionPanel];
    [UIView animateWithDuration:.2 animations:^{
        self.actionPanel.right = self.tableView.right;
    }];
}

- (void)refreshActionPanel {
    Behavior *behavior = [self editingBehavior];
    self.annotationBtn.hidden = ![behavior.annotation isNotBlank];
    self.minusBtn.hidden = ([behavior eventForDate:self.currentDate].countValue == 0);
    self.editBtn.hidden = self.removeBtn.hidden = ![behavior.isCustomised boolValue];
}

- (UIView *)actionPanel {
    if (nil == _actionPanel) {
        _actionPanel = [[UIView alloc] initWithFrame:CGRectZero];
        _actionPanel.left = self.tableView.right;
        _actionPanel.backgroundColor = [UIColor redColor];
        [self.tableView addSubview:_actionPanel];

        self.annotationBtn = [self buildButtonForActionPanelWithTitle:@"白话" action:@selector(displayAnnotation) left:0];
        self.minusBtn = [self buildButtonForActionPanelWithTitle:@"减一" action:@selector(decreaseEventCount) left:45 * 1];
        self.editBtn = [self buildButtonForActionPanelWithTitle:@"修改" action:@selector(editBehavior) left:45 * 2];
        self.removeBtn = [self buildButtonForActionPanelWithTitle:@"删除" action:@selector(removeBehavior) left:45 * 3];

        _actionPanel.width = 45 * 4;
        _actionPanel.height = 44;
    }
    return _actionPanel;
}

- (void)removeBehavior {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除项目"
                                                    message:@"永久删除此项目将同时删除相关的历史记录。"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSManagedObjectContext *ctx = [NSManagedObjectContext defaultContext];
        [[self editingBehavior].events enumerateObjectsUsingBlock:^(id event, BOOL *stop) {
            [ctx deleteObject:event];
        }];
        [ctx deleteObject:[self editingBehavior]];
        [ctx save];
        [self.resultsController performFetch];
        [self.tableView deleteRowsAtIndexPaths:@[[self editingIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
        [self updateScore];
        [self dismissActionPanel:NO];
    }
}

- (void)editBehavior {
    AddOrEditBehaviorController *controller = [AddOrEditBehaviorController editBehaviorController:[self editingBehavior]];
    [self presentViewController:controller animated:YES completion:^{
        [controller startInputName];
    }];
}

- (void)displayAnnotation {
    UIViewController *controller = [[UIViewController alloc] init];
    Behavior *behavior = [self editingBehavior];
    controller.view = [[FullPageTextView alloc] initWithFrame:controller.view.frame
                                                      content:[NSString stringWithFormat:@"\n\n\n\n%@： %@\n\n%@", behavior.category, behavior.name, behavior.annotation]];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:controller animated:YES completion:NULL];
    [self dismissActionPanel:NO];
}

- (UIButton *)buildButtonForActionPanelWithTitle:(NSString *)title action:(SEL)action left:(CGFloat)left {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(left, 0, 45, 44);
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_actionPanel addSubview:button];
    return button;
}

- (void)decreaseEventCount {
    [self showDecreaseAnimation];

    Behavior *behavior = [self editingBehavior];
    [behavior decreaseEventForDate:self.currentDate];

    [[self editingCell] displayEventCount:[behavior eventForDate:self.currentDate].count];

    [self updateScore];

    [self dismissActionPanel:NO];
}

- (BehaviorTableViewCell *)editingCell {
    return (BehaviorTableViewCell *) [self.tableView cellForRowAtIndexPath:[self editingIndexPath]];
}

- (NSIndexPath *)editingIndexPath {
    return [NSIndexPath indexPathForRow:_editingRow inSection:0];
}

- (Behavior *)editingBehavior {
    return [[self.resultsController fetchedObjects] objectAtIndex:(NSUInteger) _editingRow];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.resultsController fetchedObjects] count];
}

- (void)addBehavior {
    AddOrEditBehaviorController *controller = [[AddOrEditBehaviorController alloc] init];
    [self presentViewController:controller animated:YES completion:^{
        [controller startInputName];
    }];
}
@end
