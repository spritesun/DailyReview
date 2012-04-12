#import "BehaviorTableViewController.h"
#import "Behavior.h"
#import "BehaviorFactory.h"
#import "UIGestureRecognizer+Blocks.h"

NSString * const kBehaviorTableViewCell = @"BehaviorTableViewCell";

@interface BehaviorTableViewController () {
  NSMutableArray *sectionsExpandStatus_;
}

@end

@implementation BehaviorTableViewController

- (id)init
{
  self = [super init];
  if (self) {
    sectionsExpandStatus_ = [NSMutableArray array];
    for (int i = 0; i < [[BehaviorFactory sharedMerits] count]; i++) {
      [sectionsExpandStatus_ addObject:[NSNumber numberWithBool:YES]];
    }
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  return [self init];
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
  if ([[sectionsExpandStatus_ objectAtIndex:section] boolValue]) {
    return [[[BehaviorFactory sharedMerits] objectAtIndex:section] count];
  }
  else {
    return 0;
  }  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
  header.text = [[BehaviorFactory sharedMeritCategories] objectAtIndex:section];
  header.textColor = [UIColor whiteColor];
  header.backgroundColor = [UIColor lightGrayColor];
  header.userInteractionEnabled = YES;
  
  UIGestureRecognizer *recognizer = [UITapGestureRecognizer instanceWithActionBlock:^(id gesture) {
    BOOL expanded = [[sectionsExpandStatus_ objectAtIndex:section] boolValue];
    [sectionsExpandStatus_ replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!expanded]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewRowAnimationTop];
  }];
  [header addGestureRecognizer:recognizer];
  
  return header;
}

@end
