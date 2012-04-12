#import "BehaviorTableViewController.h"
#import "Behavior.h"
#import "BehaviorFactory.h"
#import "BehaviorSectionHeaderView.h"
#import "UIGestureRecognizer+Blocks.h"
#import "UIView+Utils.h"

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
    sectionHeaderViews_ = [NSMutableArray array];
    for (NSInteger section = 0; section < [[BehaviorFactory sharedMerits] count]; section ++) {
      [sectionHeaderViews_ addObject:[self buildHeaderForSection:section]];
    }
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  return [self init];
}

- (BehaviorSectionHeaderView *)buildHeaderForSection:(NSInteger)section
{
  NSString *title = [[BehaviorFactory sharedMeritCategories] objectAtIndex:section];  
  BehaviorSectionHeaderView *header = [BehaviorSectionHeaderView viewWithTitle:title section:section];  
  
  UIGestureRecognizer *recognizer = [UITapGestureRecognizer instanceWithActionBlock:^(id gesture) {
    header.expanded ^= YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewRowAnimationAutomatic];
  }];
  [header addGestureRecognizer:recognizer];
  
  return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBehaviorTableViewCell];
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBehaviorTableViewCell];
  }
  Behavior *behavior = [[[BehaviorFactory sharedMerits] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  cell.textLabel.text = behavior.name;
  
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
