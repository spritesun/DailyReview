#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [self colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)creamColor {
    return [self colorWithRed:0.961 green:0.937 blue:0.863];
}
@end
