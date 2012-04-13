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
  BehaviorSectionHeaderView *header = [BehaviorSectionHeaderView viewWithTitle:title];  
  
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

    UIGestureRecognizer *increaseRecognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
      Behavior *behavior = cell.behavior;
      behavior.count ++;
      // TODO:need refactor to KVO
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", behavior.count];
      UIColor *originalColor = cell.contentView.backgroundColor;
      [UIView animateWithDuration:0.2 animations:^{
        cell.contentView.backgroundColor = [UIColor yellowColor];
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
          cell.contentView.backgroundColor = originalColor;
        }];
      }];
    }];
    [cell addGestureRecognizer:increaseRecognizer];    
    
    UISwipeGestureRecognizer *decreaseRecognizer = [UISwipeGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
      Behavior *behavior = cell.behavior;
      if (0 != behavior.count) {
        behavior.count --;
        // TODO:need refactor to KVO
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", behavior.count];
        UIColor *originalColor = cell.contentView.backgroundColor;
        [UIView animateWithDuration:0.2 animations:^{
          cell.contentView.backgroundColor = [UIColor orangeColor];
        } completion:^(BOOL finished) {
          [UIView animateWithDuration:0.2 animations:^{
            cell.contentView.backgroundColor = originalColor;
          }];
        }];
      }
    }];
    decreaseRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:decreaseRecognizer];    

  }
  
  Behavior *behavior = [[[BehaviorFactory sharedMerits] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  cell.behavior = behavior;  
  
//  [cell.detailTextLable addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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
