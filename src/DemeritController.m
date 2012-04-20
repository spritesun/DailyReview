#import "DemeritController.h"

@implementation DemeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  resultsController_ = [BehaviorResultsController sharedDemeritResultsController];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  resultsController_ = nil;
  [super viewDidUnload];
}

@end
