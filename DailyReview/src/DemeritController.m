#import "DemeritController.h"

@implementation DemeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  self.resultsController = [BehaviorResultsController sharedDemeritResultsController];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  self.resultsController = nil;
  [super viewDidUnload];
}

@end
