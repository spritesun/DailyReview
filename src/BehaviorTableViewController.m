#import "BehaviorTableViewController.h"
#import "Behavior.h"
#import "BehaviorFactory.h"
#import "BehaviorSectionHeaderView.h"
#import "BehaviorTableViewCell.h"
#import "UIGestureRecognizer+Blocks.h"
#import "UIView+Additions.h"

static NSString * const kBehaviorTableViewCell = @"BehaviorTableViewCell";
static NSString * const kBehaviorCountKeyPath = @"count";

@interface BehaviorTableViewController ()

@property (nonatomic, strong) NSMutableArray *sectionHeaderViews;

@end

@implementation BehaviorTableViewController

@synthesize sectionHeaderViews = sectionHeaderViews_;

- (id)init
{
  self = [super init];
  if (self) {
    // placeholder
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  return [self init];
}

- (void)viewDidLoad
{
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  sectionHeaderViews_ = [NSMutableArray array];
  for (NSInteger section = 0; section < [[BehaviorFactory sharedMerits] count]; section ++) {
    [sectionHeaderViews_ addObject:[self buildHeaderForSection:section]];
  }
}

- (BehaviorSectionHeaderView *)buildHeaderForSection:(NSInteger)section
{
  NSString *title = [[BehaviorFactory sharedMeritCategories] objectAtIndex:section];  
  BehaviorSectionHeaderView *headerView = [BehaviorSectionHeaderView viewWithTitle:title];  
  
  UIGestureRecognizer *recognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(id theRecognizer) {
      [self toggleSection:section headerView:headerView];
  }];
  [headerView addGestureRecognizer:recognizer];
  
  return headerView;
}

- (void)toggleSection:(NSInteger)section headerView:(BehaviorSectionHeaderView *)headerView
{
  NSMutableArray *indexPaths = [NSMutableArray array];
  for (NSInteger i = 0; i < [[[BehaviorFactory sharedMerits] objectAtIndex:section] count]; i++) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  BehaviorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BehaviorTableViewCell class])];
  if (nil == cell) {    
    cell = [BehaviorTableViewCell cell];

    UIGestureRecognizer *increaseRecognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
      Behavior *behavior = cell.behavior;      
      behavior.count ++;
    }];
    [cell addGestureRecognizer:increaseRecognizer];    
    
    UISwipeGestureRecognizer *decreaseRecognizer = [UISwipeGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
      Behavior *behavior = cell.behavior;
      if (0 != behavior.count) {
        behavior.count --;
      }
    }];
    decreaseRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:decreaseRecognizer];    
  }
  
  Behavior *behavior = [[[BehaviorFactory sharedMerits] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  cell.behavior = behavior;
  [behavior addObserver:self forKeyPath:kBehaviorCountKeyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:(void *)cell];
  
  return cell;
}

// TODO: will refactor to Binding & BindingManager
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (keyPath == kBehaviorCountKeyPath) {
    NSNumber *old = [change objectForKey:NSKeyValueChangeOldKey];
    NSNumber *new = [change objectForKey:NSKeyValueChangeNewKey];
    
    BehaviorTableViewCell *cell = (__bridge BehaviorTableViewCell *)context;
    cell.detailTextLabel.text = [new stringValue];
    
    UIColor *originalColor = cell.contentView.backgroundColor;
    [UIView animateWithDuration:0.2 animations:^{
      cell.contentView.backgroundColor = ([new intValue] > [old intValue]) ? [UIColor yellowColor] : [UIColor orangeColor];
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.2 animations:^{
        cell.contentView.backgroundColor = originalColor;
      }];
    }];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[BehaviorFactory sharedMerits] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([[sectionHeaderViews_ objectAtIndex:section] expanded]) {
    return [[[BehaviorFactory sharedMerits] objectAtIndex:section] count];
  } else {
    return 0;
  }  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return [sectionHeaderViews_ objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return [[sectionHeaderViews_ objectAtIndex:section] height];
}
@end
