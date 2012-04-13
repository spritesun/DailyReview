#import "BehaviorTableViewController.h"
#import "Behavior.h"
#import "BehaviorFactory.h"
#import "BehaviorSectionHeaderView.h"
#import "BehaviorTableViewCell.h"
#import "UIGestureRecognizer+Blocks.h"
#import "UIView+Additions.h"

NSString * const kBehaviorTableViewCell = @"BehaviorTableViewCell";

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
  BehaviorSectionHeaderView *header = [BehaviorSectionHeaderView viewWithTitle:title section:section];  
  
  UIGestureRecognizer *recognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(id theRecognizer) {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = 0; i < [[[BehaviorFactory sharedMerits] objectAtIndex:section] count]; i++) {
      [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    header.expanded ^= YES;
    UITableViewRowAnimation animation = UITableViewRowAnimationTop;
    
    if (header.expanded) {
      [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    } else {
      [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
  }];
  [header addGestureRecognizer:recognizer];
  
  return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  BehaviorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BehaviorTableViewCell class])];
  if (nil == cell) {    
    cell = [BehaviorTableViewCell cell];
  }
  
  Behavior *behavior = [[[BehaviorFactory sharedMerits] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  cell.behavior = behavior;  
  
  return cell;
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
