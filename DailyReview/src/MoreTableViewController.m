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
  if (indexPath.row == 3)
  {
    [self weiboTo:nil];
  }
  else if (indexPath.row == 4)
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
    // Initialize Compose View Controller
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    // Configure Compose View Controller
    [vc setInitialText:@"@功过格 "];
    // Present Compose View Controller
    [self presentViewController:vc animated:YES completion:nil];
  } else {
    NSString *message = @"It seems that we cannot talk to Weibo at the moment or you have not yet added your Weibo account. Go to the Settings application to add your Weibo account.";
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
