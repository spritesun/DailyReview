#import "BehaviorTableViewController.h"
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

@interface BehaviorTableViewController () <UITableViewAdditionDelegate>

@end

@implementation BehaviorTableViewController {
  /* TODO: we could use array of boolean to store expanded status in controller,
   create sectionHeaderView time to reduce sectionHeader refresh logic
   when repository change
  */
  NSMutableArray *sectionHeaderViews_;
  BindingManager *bindingManager_;
  NSDate *currentDate_;
}

#pragma mark - LifeCycles

- (void)viewDidLoad {
  [super viewDidLoad];
  bindingManager_ = [BindingManager new];
  sectionHeaderViews_ = [NSMutableArray new];
  [[resultsController_ sections] each:^(id <NSFetchedResultsSectionInfo> section) {
    [sectionHeaderViews_ addObject:[self buildHeaderForSection:section]];
  }];
}

- (void)viewDidUnLoad {
  [super viewDidUnload];
  bindingManager_ = nil;
  sectionHeaderViews_ = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // TODO: when repository changed become complex, this refreshViewIfNeeded logic needs to be extract, using NSNotificationCenter connect repository and tableView then.
  if (![currentDate_ isEqualToDate:[[NSDate date] dateWithoutTime]]) {
    [[self tableView] reloadData];
    currentDate_ = [[NSDate date] dateWithoutTime];
  }
  [self updateScore]; 
}

- (void)updateScore {
  //TODO: (Qin) how to find a way to check which section is the first visible one?
  [sectionHeaderViews_ each:^(BehaviorSectionHeaderView *section){
//      [section clearScore];
    [section setTodayScore:[self getScore]];
  }];
//  [[sectionHeaderViews_ first:^BOOL(BehaviorSectionHeaderView *section) {
//    return ![section isHidden];
//  }] setTodayScore:[self getScore]];

}

- (NSNumber*)getScore {
  //TODO: (Qin) how to declare a abstract method
  return [NSNumber numberWithInt:0];
}

- (BehaviorSectionHeaderView *)buildHeaderForSection:(id <NSFetchedResultsSectionInfo>)section {
  BehaviorSectionHeaderView *headerView = [BehaviorSectionHeaderView viewWithTitle:[section name] andScoreName:scoreName_];

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

  Event *event = [self buildEventForBehavior:behavior];

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

//TODO: move to domain?
- (Event *)buildEventForBehavior:(Behavior *)behavior {
  if (nil == [behavior eventForDate:currentDate_]) {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"behavior = %@ AND date = %@", behavior, currentDate_]];
    __block NSArray *results;
    [context performBlockAndWait:^{
      results = [context executeFetchRequest:request error:nil];
    }];
    if ([results isEmpty]) {
      [behavior addEventsObject:[Event eventForBehavior:behavior onDate:currentDate_]];
    } else {
      [behavior addEventsObject:[results first]];
    }
  }

  return [behavior eventForDate:currentDate_];
}

- (void)addGesturesForCell:(BehaviorTableViewCell *)cell event:(Event *)event {
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
  UIGestureRecognizer *increaseRecognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
    event.countValue++;
    [context save];
    [self updateScore]; 
  }];
  [cell addGestureRecognizer:increaseRecognizer];

  UISwipeGestureRecognizer *decreaseRecognizer = [UISwipeGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
    if (0 != event.countValue) {
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

  [cell.contentView flashWithDuration:0.4 color:([newValue intValue] > [oldValue intValue]) ? [UIColor yellowColor] : [UIColor orangeColor]];
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
