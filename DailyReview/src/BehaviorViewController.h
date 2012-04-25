#import "BehaviorResultsController.h"

@class ScoreView;

@interface BehaviorViewController : UIViewController {
@protected
  BehaviorResultsController *resultsController_;
}

@property(nonatomic, strong) IBOutlet ScoreView *scoreView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end
