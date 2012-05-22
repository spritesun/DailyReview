#import "BehaviorResultsController.h"
#import "DailyScoreFetcher.h"

@interface BehaviorTableViewController : UITableViewController <DailyScoreFetcher> {
@protected
  BehaviorResultsController *resultsController_;
  NSString *scoreName_;

}

- (NSNumber*)getScore;

@end
