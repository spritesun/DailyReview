#import "BehaviorViewController.h"
#import "BehaviorSectionHeaderView.h"
#import "BehaviorTableViewCell.h"
#import "UIGestureRecognizer+Blocks.h"
#import "UIView+Additions.h"
#import "BindingManager.h"
#import "Event.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSArray+Additions.h"
#import "UITableView+Additions.h"
#import "NSDate+Additions.h"
#import "NSFetchedResultsController+Additions.h"
#import "UIImage+Additions.h"
#import "BehaviorResultsController.h"
#import "ScoreView.h"

@interface BehaviorViewController () <UITableViewAdditionDelegate, UITableViewDelegate, UITableViewDataSource>
@end

@implementation BehaviorViewController {
  /* TODO: we could use array of boolean to store expanded status in controller,
   create sectionHeaderView time to reduce sectionHeader refresh logic
   when repository change
   */
  NSMutableArray *sectionHeaderViews_;
  BindingManager *bindingManager_;
  NSDate *currentDate_;
  UIImageView *hintView_;
  UIImageView *increaseView_;
  UIImageView *decreaseView_;
}

@synthesize scoreView = scoreView_, tableView = tableView_;

#pragma mark - LifeCycles

- (UIImageView *)createTransparentView:(NSString *)imageName {
  UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
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
  UIImage *diabledImage = [image grayish];
  [barItem setFinishedSelectedImage:image withFinishedUnselectedImage:diabledImage];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"behavior-view-bg"]]; 
  self.view.backgroundView.frame = tableView_.frame;
  tableView_.delegate = self;
  tableView_.dataSource = self;
  bindingManager_ = [BindingManager new];
  sectionHeaderViews_ = [NSMutableArray new];
  [[resultsController_ sections] each:^(id <NSFetchedResultsSectionInfo> section) {
    [sectionHeaderViews_ addObject:[self buildHeaderForSection:section]];
  }];
  
  [self createHintView];
}

- (void)viewDidUnload {
  tableView_.delegate = nil;
  tableView_.dataSource = nil;
  bindingManager_ = nil;
  sectionHeaderViews_ = nil;
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
  if (![currentDate_ isEqualToDate:[[NSDate date] dateWithoutTime]]) {
    currentDate_ = [[NSDate date] dateWithoutTime];
    [[self tableView] reloadData];
    [[self tableView] layoutIfNeeded];
  }
  [self updateScore];
}

- (void)updateScore {
  [scoreView_ setMeritCount:[[BehaviorResultsController sharedMeritResultsController] todayRank]
               demeritCount:[[BehaviorResultsController sharedDemeritResultsController] todayRank]];
}

- (BehaviorSectionHeaderView *)buildHeaderForSection:(id <NSFetchedResultsSectionInfo>)section {
  return [BehaviorSectionHeaderView viewWithTitle:[section name]];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //TODO: avoid create empty event for every behavior everyday.
  BehaviorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BehaviorTableViewCell class])];
  if (nil == cell) {
    cell = [BehaviorTableViewCell cell];
  }
  
  Behavior *behavior = [resultsController_ objectAtIndexPath:indexPath];
  cell.textLabel.text = behavior.name;
  
  Event *event = [behavior createEventForDate:currentDate_];
  
  [self addGesturesForCell:cell event:event];
  [bindingManager_ bindSource:event
                  withKeyPath:@"count"
                       action:^(Binding *binding, NSNumber *oldValue, NSNumber *newValue) {
                         [self changeBehaviorCountFrom:oldValue to:newValue inCell:cell];
                       }];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView willRemoveCell:(UITableViewCell *)cell {
  [cell removeAllGestureRecognizers];
  Behavior *behavior = [resultsController_ objectAtIndexPath:[tableView indexPathForCell:cell]];
  [bindingManager_ unbindSource:[behavior eventForDate:currentDate_]];
}

- (void)showHintAnimation:(BehaviorTableViewCell *)cell {
  CGPoint cellOrigin = cell.frame.origin;
  UIImage *hint = hintView_.image;
  hintView_.frame = CGRectMake(cellOrigin.x + 130, cellOrigin.y + 12 , hint.size.width, hint.size.height);
  hintView_.alpha = 1.0;
  [UIView animateWithDuration:1.0 animations:^{
    hintView_.alpha = 0.0;
    hintView_.frame = CGRectMake(cellOrigin.x + 180, cellOrigin.y + 12 , hint.size.width, hint.size.height);
  }];
}

- (void)transformAnimationOn:(UIImageView *)view From:(CGRect)fromRect to:(CGRect)toRect {
  view.frame = fromRect;
  view.alpha = 1.0;
  view.clipsToBounds = YES;
  [UIView animateWithDuration:0.2 animations:^{
    view.frame = toRect;
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:1 animations:^{
      view.alpha = 0;
    }];
  }];
}

- (void)showIncreaseAnimation:(BehaviorTableViewCell *)cell {
  CGPoint cellOrigin = cell.frame.origin;
  CGRect beginRect = CGRectMake(cellOrigin.x + 130, cellOrigin.y + 4 , 0, increaseView_.image.size.height);
  CGRect endRect = CGRectMake(cellOrigin.x + 130, cellOrigin.y + 4 , increaseView_.image.size.width, increaseView_.image.size.height);
  increaseView_.contentMode = UIViewContentModeLeft;
  [self transformAnimationOn:increaseView_ From:beginRect to:endRect];
}

- (void)showDecreaseAnimation:(BehaviorTableViewCell *)cell {
  CGPoint cellOrigin = cell.frame.origin;
  CGRect beginRect = CGRectMake(cellOrigin.x + 270, cellOrigin.y + 4 , 0, decreaseView_.image.size.height);
  CGRect endRect = CGRectMake(cellOrigin.x + 130, cellOrigin.y + 4 , decreaseView_.image.size.width, decreaseView_.image.size.height);
  decreaseView_.contentMode = UIViewContentModeRight;
  [self transformAnimationOn:decreaseView_ From:beginRect to:endRect];
}

- (void)addGesturesForCell:(BehaviorTableViewCell *)cell event:(Event *)event {
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
  UIGestureRecognizer *hintRecognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
    [self showHintAnimation:cell];
  }];
  [cell addGestureRecognizer:hintRecognizer];
  
  UISwipeGestureRecognizer *increaseRecognizer = [UISwipeGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
    [self showIncreaseAnimation:cell];
    event.countValue++;
    [context save];
    [self updateScore];

  }];
  increaseRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [cell addGestureRecognizer:increaseRecognizer];
  
  UISwipeGestureRecognizer *decreaseRecognizer = [UISwipeGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
    if (0 != event.countValue) {
      [self showDecreaseAnimation:cell];
      event.countValue--;
      [context save];
      [self updateScore];
    }
  }];
  decreaseRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  
  [cell addGestureRecognizer:decreaseRecognizer];
}

- (void)changeBehaviorCountFrom:(NSNumber *)oldValue to:(NSNumber *)newValue inCell:(UITableViewCell *)cell {
  if ([newValue intValue] == 0) {
    cell.detailTextLabel.text = @" ";
  } else {
    cell.detailTextLabel.text = [newValue stringValue];
  }
  
  cell.detailTextLabel.accessibilityLabel = [NSString stringWithFormat:@"%@:%@", cell.textLabel.text, newValue.stringValue];
  if (oldValue == nil) {
    return;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[resultsController_ sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([[sectionHeaderViews_ objectAtIndex:section] expanded]) {
    return [resultsController_ numberOfObjectsInSection:section];
  } else {
    return 0;
  }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return [sectionHeaderViews_ objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return [[sectionHeaderViews_ objectAtIndex:section] height];
}

@end
