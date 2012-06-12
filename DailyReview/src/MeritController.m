#import "MeritController.h"
#import "AddBehaviorController.h"

@interface MeritController () <AddBehaviorControllerDelegate>
@end

@implementation MeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  resultsController_ = [BehaviorResultsController sharedMeritResultsController];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  resultsController_ = nil;
  [super viewDidUnload];  
}

- (IBAction)addBehavior:(id)sender {
  AddBehaviorController *addBehaviorController = [[AddBehaviorController alloc] init];
  addBehaviorController.delegate = self;
  [self presentViewController:addBehaviorController animated:YES completion:^{
    [addBehaviorController startInputName];
  }];

}

#pragma mark - AddBehaviorControllerDelegate
//TODO: move the logic to BehaviorViewController
- (void)behaviorDidSave:(Behavior *)behavior {
  [resultsController_ performFetch:nil];
  
  NSIndexPath *behaviorIndex = [resultsController_ indexPathForObject:behavior];
  NSIndexPath *upperIndex = [NSIndexPath indexPathForRow:(behaviorIndex.row - 1) inSection:behaviorIndex.section];

  [self.tableView scrollToRowAtIndexPath:upperIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:behaviorIndex.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
