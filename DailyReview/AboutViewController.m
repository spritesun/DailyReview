//
//  AboutViewController.m
//  DailyReview
//
//  Created by Lei Zhang on 5/2/12.
//  Copyright 2012 ThoughtWorks. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

#pragma mark - AboutViewController

// your classes methods here


#pragma mark - View lifecycle

- (void)viewDidLoad;
{
  [super viewDidLoad];
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  UIImage *backButtonBgImage = [UIImage imageNamed:@"back-button-bg"];
  [backButton setBackgroundImage:backButtonBgImage forState:UIControlStateNormal];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, backButtonBgImage.size.width / 8, backButtonBgImage.size.height / 8)];
  label.text = @"更多";
  label.font = [UIFont fontWithName:@"Helvetica" size:14];
  label.backgroundColor = [UIColor clearColor];
  [backButton addSubview:label];
  backButton.frame = CGRectMake(0, 0, backButtonBgImage.size.width / 6, backButtonBgImage.size.height / 6);
  [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

  self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)back {
 [[self navigationController] popViewControllerAnimated:YES];
}


- (void)viewDidUnload;
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
