#import "MainViewController.h"
#import "UIImage+Additions.h"
#import "Behavior.h"
#import "BehaviorResultsController.h"
#import "BehaviorViewController.h"

@implementation MainViewController

@synthesize tabBar = tabBar_;

#pragma mark - AddBehaviorController
- (void)behaviorDidSave:(Behavior *)behavior {
    if (behavior.rank.intValue > 0) {
        self.selectedIndex = 0;
        self.selectedViewController = [self.viewControllers objectAtIndex:0];
    } else {
        self.selectedIndex = 1;
        self.selectedViewController = [self.viewControllers objectAtIndex:1];

    }
    BehaviorViewController *behaviorViewController = (BehaviorViewController *) self.selectedViewController;
    BehaviorResultsController *resultsController = behaviorViewController.resultsController;
    [resultsController performFetch];
    NSIndexPath *behaviorIndex = [resultsController indexPathForObject:behavior];
    [behaviorViewController.tableView scrollToRowAtIndexPath:behaviorIndex atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [behaviorViewController.tableView reloadRowsAtIndexPaths:@[behaviorIndex] withRowAnimation:UITableViewRowAnimationFade];
}

@end
