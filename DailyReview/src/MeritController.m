#import "MeritController.h"


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

@end
