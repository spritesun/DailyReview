//
//  UIImage+Additions.m
//  DailyReview
//
//  Created by twer on 5/18/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage *)grayish {
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
  CGContextRef con = UIGraphicsGetCurrentContext();
  CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
  CGContextAddRect(con, imageRect);
  CGContextSetFillColorWithColor(con, [UIColor colorWithWhite:1 alpha:0].CGColor);
  CGContextFillPath(con);
  [self drawAtPoint:imageRect.origin blendMode:kCGBlendModeLighten alpha:0.5];
  UIImage* filteredImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return filteredImage;
}

@end
