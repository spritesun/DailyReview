#import "DemeritController.h"

@implementation DemeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  scoreName_ = @"过";
  resultsController_ = [BehaviorResultsController sharedDemeritResultsController];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  resultsController_ = nil;
  [super viewDidUnload];
}

- (NSNumber*)getScore {
  return [[BehaviorResultsController sharedDemeritResultsController] todayRank];
}

@end
