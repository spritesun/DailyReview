@class Behavior;

@interface AddOrEditBehaviorController : UITableViewController

- (void)startInputName;

+ (AddOrEditBehaviorController *)editBehaviorController:(Behavior *)behavior;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *rankTextField;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end