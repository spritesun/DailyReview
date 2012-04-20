#import "BehaviorResultsController.h"

@interface BehaviorTableViewController : UITableViewController {
@protected
  BehaviorResultsController *resultsController_;
  NSString *scoreName_;

}

- (NSNumber*)getScore;

@end
