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

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    sectionsExpandStatus_ = [NSMutableArray array];
    for (int i = 0; i < [[BehaviorFactory sharedMerits] count]; i++) {
      [sectionsExpandStatus_ addObject:[NSNumber numberWithBool:YES]];
    }
  }
  return self;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBehaviorTableViewCell];
  
  cell = cell ? cell : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBehaviorTableViewCell];
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
  if ([[sectionsExpandStatus_ objectAtIndex:section] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
    return [[[BehaviorFactory sharedMerits] objectAtIndex:section] count];
  }
  else {
    return 0;
  }
  
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//  return [[BehaviorFactory sharedMeritCategories] objectAtIndex:section];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
  header.text = [[BehaviorFactory sharedMeritCategories] objectAtIndex:section];
  header.backgroundColor = [UIColor lightGrayColor];
  header.userInteractionEnabled = YES;
  
  UIGestureRecognizer *recognizer = [UITapGestureRecognizer instanceWithActionBlock:^(id gesture) {
    [sectionsExpandStatus_ replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:NO]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewRowAnimationTop];
  }];
  [header addGestureRecognizer:recognizer];
  
  return header;
}



@end
