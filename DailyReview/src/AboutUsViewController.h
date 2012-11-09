#import "AboutViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutUsViewController : AboutViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *mailLabel;

- (IBAction)mailTo:(id)sender;

- (IBAction)weiboTo:(id)sender;

@end
