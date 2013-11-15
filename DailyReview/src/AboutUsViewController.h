#import "AboutKarmaCounterViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutUsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *mailLabel;

- (IBAction)mailTo:(id)sender;

- (IBAction)weiboTo:(id)sender;

@end
