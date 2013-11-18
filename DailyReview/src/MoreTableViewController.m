//
//  MoreTableViewController.m
//  DailyReview
//
//  Created by Long Sun on 18/11/2013.
//  Copyright (c) 2013 Sunlong. All rights reserved.
//

#import "MoreTableViewController.h"
#import <MessageUI/MessageUI.h>

@interface MoreTableViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation MoreTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 3)
  {
    [self mailTo:nil];
  }
  else if (indexPath.row == 4)
  {
    [self weiboTo:nil];
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
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2808620024"]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
