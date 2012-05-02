//
//  MoreNavigationBar.m
//  DailyReview
//
//  Created by Lei Zhang on 5/2/12.
//  Copyright 2012 ThoughtWorks. All rights reserved.
//

#import "MoreNavigationBar.h"

@implementation MoreNavigationBar

#pragma mark - Properties

// synthesize your properties here


- (id)init;
{
  if ((self = [super init]))
  {
  }

  return self;
}

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:@"bottom-bar-bg"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
