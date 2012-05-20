//
//  UIImageView+Additions.m
//  DailyReview
//
//  Created by Lei Zhang on 5/20/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

+ (UIImageView *)initTransparentImage:(NSString *)imageName with:(CGFloat)opaque {
  UIImage *image = [UIImage imageNamed:imageName];
  UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
  [image drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:opaque];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return [[UIImageView alloc] initWithImage:newImage];
}

@end
