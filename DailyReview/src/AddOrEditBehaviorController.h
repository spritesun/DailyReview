@class Behavior;
@interface AddOrEditBehaviorController : UITableViewController
@property(nonatomic, retain) Behavior *editingBehavior;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *rankTextField;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end