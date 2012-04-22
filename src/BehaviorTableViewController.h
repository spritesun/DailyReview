#import "BehaviorResultsController.h"

@class ScoreView;
@interface BehaviorTableViewController : UITableViewController {
  
@protected
  BehaviorResultsController *resultsController_;
}

@property (nonatomic, strong) IBOutlet ScoreView* scoreView;

@end
