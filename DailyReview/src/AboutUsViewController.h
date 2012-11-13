#import "AboutKarmaCounterViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutUsViewController : BackableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *mailLabel;

- (IBAction)mailTo:(id)sender;

- (IBAction)weiboTo:(id)sender;

@end
