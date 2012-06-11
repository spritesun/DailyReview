@class Behavior;

@protocol AddBehaviorControllerDelegate

- (void)onSave:(Behavior *)behavior;

@end

@interface AddBehaviorController : UITableViewController

- (void)startInputName;

@property(nonatomic, assign) id <AddBehaviorControllerDelegate> delegate;

@end