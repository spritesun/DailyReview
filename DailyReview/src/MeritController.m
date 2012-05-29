#import "MeritController.h"
#import "AddBehaviorController.h"


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
  [self presentModalViewController:addBehaviorController animated:YES];
}
@end
