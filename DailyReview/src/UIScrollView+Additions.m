#import "UIScrollView+Additions.h"

@implementation UIScrollView (Additions)

- (CGFloat)bottomOffsetY {
  return self.contentSize.height - self.bounds.size.height;
}

@end
