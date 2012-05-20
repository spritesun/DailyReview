#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
  return [self colorWithRed:red green:green blue:blue alpha:1];
}
@end
