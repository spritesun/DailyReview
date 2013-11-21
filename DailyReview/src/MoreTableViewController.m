//
//  MoreTableViewController.m
//  DailyReview
//
//  Created by Long Sun on 18/11/2013.
//  Copyright (c) 2013 Sunlong. All rights reserved.
//

#import "MoreTableViewController.h"
@import MessageUI;
@import Social;

@interface MoreTableViewController () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@end

@implementation MoreTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 0)
  {
    [self weiboTo:nil];
  }
  else if (indexPath.section == 1 && indexPath.row == 1)
  {
    [self mailTo:nil];
  }
  else if (indexPath.section == 2 && indexPath.row == 0)
  {
    [self openLink];
  }
}

- (IBAction)mailTo:(id)sender
{
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [controller setSubject:@"功过格应用的反馈"];
    
    [controller setToRecipients:[NSArray arrayWithObject:@"gongguoge@gmail.com"]];
    
    [controller setMessageBody:@"" isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
  }
  else
  {
    NSString *message = @"请设置好您的电子邮箱。";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
  }
}

- (IBAction)weiboTo:(id)sender
{
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
  {
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    [vc setInitialText:@"@功过格 "];
    // Present Compose View Controller
    [self presentViewController:vc animated:YES completion:nil];
  } else {
    NSString *message = @"请设置好您的新浪微博账号。";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
  }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openLink
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您确认要离开功过格应用，打开这个链接吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
  alertView.delegate = self;
  [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://icons8.com/"]];
  }
}
@end
