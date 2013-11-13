#import "BehaviorResultsController.h"

@class ScoreView;

@interface BehaviorViewController : UIViewController

@property(nonatomic, strong) IBOutlet ScoreView *scoreView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) BehaviorResultsController *resultsController;

- (void)refreshView;
- (IBAction)addBehavior:(id)sender;
@end
