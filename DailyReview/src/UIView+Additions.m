#import "UIView+Additions.h"

@implementation UIView (Additions)

- (CGFloat)left {
  return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)top {
  return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}

- (CGFloat)centerX {
  return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
  return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (CGPoint)origin {
  return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}

- (CGSize)size {
  return self.frame.size;
}

- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}

static const NSInteger kBackgroundViewTag = 1000;

- (UIView *)backgroundView {  
  return [self viewWithTag:kBackgroundViewTag];
}

- (void)setBackgroundView:(UIView *)backgroundView {
  UIView *oldBackgroundView = self.backgroundView;
  if (oldBackgroundView == backgroundView) {
    return;
  }
  if (oldBackgroundView) {
    [oldBackgroundView removeFromSuperview];
  }
  if (backgroundView) {
    backgroundView.tag = kBackgroundViewTag;
    [self addSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
  }
}

- (void)removeAllSubviews {
  while (self.subviews.count) {
    UIView *child = self.subviews.lastObject;
    [child removeFromSuperview];
  }
}

- (void)removeAllGestureRecognizers {
  for (id recognizer in self.gestureRecognizers) {
    [self removeGestureRecognizer:recognizer];
  }
}

- (void)flashWithDuration:(float)duration color:(UIColor *)color {
  UIColor *originalColor = self.backgroundColor;
  [UIView animateWithDuration:duration / 2 animations:^{
    self.backgroundColor = color;
  }                completion:^(BOOL finished) {
    [UIView animateWithDuration:duration / 2 animations:^{
      self.backgroundColor = originalColor;
    }];
  }];
}

@end
