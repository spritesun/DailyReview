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
- (void)onSave:(Behavior *)behavior {
  [resultsController_ performFetch:nil];
  [[self tableView] reloadData];
  [[self tableView] layoutIfNeeded];
}

@end
