#import "BehaviorTableViewController.h"
#import "Behavior.h"
#import "BehaviorDataSource.h"
#import "BehaviorSectionHeaderView.h"
#import "BehaviorTableViewCell.h"
#import "UIGestureRecognizer+Blocks.h"
#import "UIView+Additions.h"
#import "BindingManager.h"

@implementation BehaviorTableViewController {
  NSMutableArray *sectionHeaderViews_;
  BindingManager *bindingManager_;
  BehaviorDataSource *dataSource_;
}

#pragma mark - Initialization

- (id)init {
  self = [super init];
  if (self) {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  return [self init];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
  //TODO: should we put this in viewDidLoad or init?
  bindingManager_ = [BindingManager new];
  dataSource_ = [BehaviorDataSource merits];  
  sectionHeaderViews_ = [NSMutableArray new];
  for (NSUInteger section = 0; section < [dataSource_ categoryCount]; section++) {
    [sectionHeaderViews_ addObject:[self buildHeaderForSection:section]];
  }
}

- (void)viewDidUnLoad {
  bindingManager_ = nil;
  dataSource_ = nil;
  sectionHeaderViews_ = nil;
}

- (BehaviorSectionHeaderView *)buildHeaderForSection:(NSUInteger)section {
  NSString *title = [dataSource_ categoryForSection:section];
  BehaviorSectionHeaderView *headerView = [BehaviorSectionHeaderView viewWithTitle:title];
  
  UIGestureRecognizer *recognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(id theRecognizer) {
    [self toggleSection:section headerView:headerView];
  }];
  [headerView addGestureRecognizer:recognizer];
  
  return headerView;
}

- (void)toggleSection:(NSUInteger)section headerView:(BehaviorSectionHeaderView *)headerView {
  NSMutableArray *indexPaths = [NSMutableArray array];
  for (NSInteger i = 0; i < [dataSource_ behaviorCountForSection:section]; i++) {
    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
  }
  headerView.expanded ^= YES;
  UITableViewRowAnimation animation = UITableViewRowAnimationTop;
  
  if (headerView.expanded) {
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
  } else {
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BehaviorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BehaviorTableViewCell class])];
  if (nil == cell) {
    cell = [BehaviorTableViewCell cell];    
  }
  
  Behavior *behavior = [dataSource_ behaviorForIndexPath:indexPath];
  
  cell.textLabel.text = behavior.name;
  
  //add gestures
  [cell removeAllGestureRecognizers];
  UIGestureRecognizer *increaseRecognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
//    behavior.count++;
  }];
  [cell addGestureRecognizer:increaseRecognizer];
  
  UISwipeGestureRecognizer *decreaseRecognizer = [UISwipeGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
//    if (0 != behavior.count) {
//      behavior.count--;
//    }
  }];
  decreaseRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [cell addGestureRecognizer:decreaseRecognizer];

  //add binding
//  [bindingManager_ unbindSource:behavior];
//  [bindingManager_ bindSource:behavior
//                  withKeyPath:@"count"
//                       action:^(Binding *binding, NSNumber *oldValue, NSNumber *newValue) {
//                         [self changeBehaviorCountFrom:oldValue to:newValue inCell:cell];
//                       }];
  
  return cell;
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
  return [dataSource_ categoryCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([[sectionHeaderViews_ objectAtIndex:section] expanded]) {
    return [dataSource_ behaviorCountForSection:section];
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
