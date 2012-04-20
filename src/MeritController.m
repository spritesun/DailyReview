#import "MeritController.h"

@implementation MeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  scoreName_ = @"功";
  resultsController_ = [BehaviorResultsController sharedMeritResultsController];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  resultsController_ = nil;
  [super viewDidUnload];  
}

- (NSNumber*)getScore {
  return [[BehaviorResultsController sharedMeritResultsController] todayRank];
}

@end
