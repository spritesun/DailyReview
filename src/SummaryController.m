#import "BehaviorResultsController.h"
#import "SummaryController.h"

@interface SummaryController ()

@end

@implementation SummaryController

@synthesize meritRankView = meritRankView_;
@synthesize demeritRankView = demeritRankView_;
@synthesize totalRankView = totalRankView_;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSNumber *totalMeritRank = [[BehaviorResultsController sharedMeritResultsController] totalRank];
  NSNumber *totalDemeritRank = [[BehaviorResultsController sharedDemeritResultsController] totalRank];

  [meritRankView_ setText:[totalMeritRank stringValue]];
  [demeritRankView_ setText:[totalDemeritRank stringValue]];
  [totalRankView_ setText:[NSString stringWithFormat:@"%d", [totalMeritRank intValue] + [totalDemeritRank intValue]]];
}
@end
