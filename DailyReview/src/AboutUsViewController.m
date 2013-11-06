#import "AboutUsViewController.h"
#import "DRBackButton.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

@synthesize mailLabel = mailLabel_;

- (void)viewDidLoad; {
    [super viewDidLoad];
}

- (IBAction)mailTo:(id)sender {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;

    [controller setSubject:@"功过格应用的反馈"];

    [controller setToRecipients:[NSArray arrayWithObject:@"gongguoge@gmail.com"]];

    [controller setMessageBody:@"" isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)weiboTo:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2808620024"]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
