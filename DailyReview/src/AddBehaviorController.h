@class Behavior;

@protocol AddBehaviorControllerDelegate

- (void)behaviorDidSave:(Behavior *)behavior;

@end

@interface AddBehaviorController : UITableViewController

- (void)startInputName;

@property(nonatomic, assign) id <AddBehaviorControllerDelegate> delegate;

@end