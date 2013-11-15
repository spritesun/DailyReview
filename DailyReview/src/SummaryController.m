#import "BehaviorResultsController.h"
#import "SummaryController.h"

@implementation SummaryController


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSNumber *totalMeritRank = [[BehaviorResultsController sharedMeritResultsController] totalRank];
  NSNumber *totalDemeritRank = [[BehaviorResultsController sharedDemeritResultsController] totalRank];
  
  self.meritRankLabel.text = totalMeritRank.stringValue;
  self.demeritRankLabel.text = totalDemeritRank.stringValue;
  self.totalRankLabel.text = [NSString stringWithFormat:@"%d", [totalMeritRank intValue] + [totalDemeritRank intValue]];
}

@end
