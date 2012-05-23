#import "BehaviorResultsController.h"

@class ScoreView;

@interface BehaviorViewController : UIViewController {
@protected
  BehaviorResultsController *resultsController_;
}

@property(nonatomic, strong) IBOutlet ScoreView *scoreView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

- (void)setBarItem:(UITabBarItem *)barItem withImage:(UIImage *)image;
- (void)refreshView;
@end
