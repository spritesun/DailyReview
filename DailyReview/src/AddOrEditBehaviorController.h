@class Behavior;

@interface AddOrEditBehaviorController : UITableViewController

- (void)startInputName;

+ (AddOrEditBehaviorController *)editBehaviorController:(Behavior *)behavior;

@end