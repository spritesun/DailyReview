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

- (void)createHintView {
  hintView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"swipe-hint.png"]];
  hintView_.alpha = 0;
  [self.tableView addSubview:hintView_];
}

- (void)createEventModificationView {
  increaseView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"increase-hint.png"]];
  increaseView_.alpha = 0;
  [self.tableView addSubview:increaseView_];
  decreaseView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"decrease-hint.png"]];
  decreaseView_.alpha = 0;
  [self.tableView addSubview:decreaseView_];
}

- (void)addPinchGestureRecognizerForSections {
  __block BOOL isPinched = NO;
  UIPinchGestureRecognizer *pinchRecognizer = [UIPinchGestureRecognizer recognizerWithActionBlock:^(UIPinchGestureRecognizer* recognizer) {
    if (recognizer.state != UIGestureRecognizerStateChanged) {
      isPinched = NO;
    }
    
    if (!isPinched && recognizer.scale < 0.6 && recognizer.numberOfTouches == 2) {
      NSIndexPath *path1 = [tableView_ indexPathForRowAtPoint:[recognizer locationOfTouch:0 inView:tableView_]];
      NSIndexPath *path2 = [tableView_ indexPathForRowAtPoint:[recognizer locationOfTouch:1 inView:tableView_]];
      
      if (path1.section == path2.section) {
        NSInteger sectionIndex = path1.section;
        [self toggleSection:[[resultsController_ sections] objectAtIndex:sectionIndex] headerView:[sectionHeaderViews_  objectAtIndex:sectionIndex]];
        isPinched = YES;
      }
    }
  }];
  
  [tableView_ addGestureRecognizer:pinchRecognizer];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"behavior-view-bg.png"]]; 
  self.view.backgroundView.frame = tableView_.frame;
  tableView_.delegate = self;
  tableView_.dataSource = self;
  bindingManager_ = [BindingManager new];
  sectionHeaderViews_ = [NSMutableArray new];
  [[resultsController_ sections] each:^(id <NSFetchedResultsSectionInfo> section) {
    [sectionHeaderViews_ addObject:[self buildHeaderForSection:section]];
  }];
  
  [self addPinchGestureRecognizerForSections];
  
  [self createHintView];
  [self createEventModificationView];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  self.view.backgroundView = nil;
  tableView_.delegate = nil;
  tableView_.dataSource = nil;
  bindingManager_ = nil;
  sectionHeaderViews_ = nil;
  hintView_ = nil;
  increaseView_ = nil;
  decreaseView_ = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // TODO: when repository changed become complex, this refreshViewIfNeeded logic needs to be extract, using NSNotificationCenter connect repository and tableView then.
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
  BehaviorSectionHeaderView *headerView = [BehaviorSectionHeaderView viewWithTitle:[section name]];
  
  UIGestureRecognizer *recognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(id theRecognizer) {
    [self toggleSection:section headerView:headerView];
  }];
  [headerView addGestureRecognizer:recognizer];
  
  return headerView;
}

- (void)toggleSection:(id <NSFetchedResultsSectionInfo>)section headerView:(BehaviorSectionHeaderView *)headerView {
  headerView.expanded ^= YES;
  UITableViewRowAnimation animation = UITableViewRowAnimationTop;
  NSArray *indexPaths = [resultsController_ indexPathsForSection:section];
  if (headerView.expanded) {
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
  } else {
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
  }
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

- (void)showIncreaseAnimation:(BehaviorTableViewCell *)cell {
  CGPoint cellOrigin = cell.frame.origin;
  CGRect rect = CGRectMake(cellOrigin.x + 130, cellOrigin.y + 4 , 0, increaseView_.image.size.height);
  increaseView_.frame = rect;
  increaseView_.alpha = 1.0;
  increaseView_.clipsToBounds = YES;
  increaseView_.contentMode = UIViewContentModeLeft;
  [UIView animateWithDuration:0.2 animations:^{
    increaseView_.frame = CGRectMake(cellOrigin.x + 130, cellOrigin.y + 4 , increaseView_.image.size.width, increaseView_.image.size.height);
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:1 animations:^{
      increaseView_.alpha = 0;
    }];
  }];
}

- (void)showDecreaseAnimation:(BehaviorTableViewCell *)cell {
  CGPoint cellOrigin = cell.frame.origin;
  CGRect rect = CGRectMake(cellOrigin.x + 270, cellOrigin.y + 4 , 0, decreaseView_.image.size.height);
  decreaseView_.frame = rect;
  decreaseView_.alpha = 1.0;
  decreaseView_.clipsToBounds = YES;
  decreaseView_.contentMode = UIViewContentModeRight;
  [UIView animateWithDuration:0.2 animations:^{
    decreaseView_.frame = CGRectMake(cellOrigin.x + 130, cellOrigin.y + 4 , decreaseView_.image.size.width, decreaseView_.image.size.height);
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:1 animations:^{
      decreaseView_.alpha = 0;
    }];
  }];
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
  
  if (oldValue == nil) {
    return;
  }
  
//  [cell.contentView flashWithDuration:0.4 color:([newValue intValue] > [oldValue intValue]) ? [UIColor yellowColor] : [UIColor orangeColor]];
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
