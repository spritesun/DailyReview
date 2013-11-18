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

@interface MoreTableViewController () <MFMailComposeViewControllerDelegate>

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
}
- (IBAction)mailTo:(id)sender
{
  MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
  controller.mailComposeDelegate = self;
  
  [controller setSubject:@"功过格应用的反馈"];
  
  [controller setToRecipients:[NSArray arrayWithObject:@"gongguoge@gmail.com"]];
  
  [controller setMessageBody:@"" isHTML:NO];
  [self presentViewController:controller animated:YES completion:nil];
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
    NSString *message = @"请先设置好您的新浪微博账号。";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
  }
//  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2808620024"]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
