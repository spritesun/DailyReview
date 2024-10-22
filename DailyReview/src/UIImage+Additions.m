#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)transparentImage {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), YES, 0.0);
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)grayish {
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
  CGContextRef con = UIGraphicsGetCurrentContext();
  CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
  CGContextAddRect(con, imageRect);
  CGContextSetFillColorWithColor(con, [UIColor colorWithWhite:1 alpha:0].CGColor);
  CGContextFillPath(con);
  [self drawInRect:imageRect blendMode:kCGBlendModeLighten alpha:0.5];
  UIImage* filteredImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return filteredImage;
}

@end
