#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

@synthesize mailLabel = mailLabel_;

- (IBAction)mailTo:(id)sender {
  MFMailComposeViewController *controller=[[MFMailComposeViewController alloc]init];
  controller.mailComposeDelegate = self;
  
  [controller setSubject:@"功过格应用的反馈"];
  
  [controller setToRecipients:[NSArray arrayWithObject:@"gongguoge@gmail.com"]];
  
  [controller setMessageBody:@"" isHTML:NO];
  [self presentModalViewController:controller animated:YES];
}

- (IBAction)weiboTo:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2808620024"]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
  [self dismissModalViewControllerAnimated:YES];
}

@end
