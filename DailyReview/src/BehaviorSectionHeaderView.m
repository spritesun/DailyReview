#import "BehaviorSectionHeaderView.h"
#import "BehaviorResultsController.h"
#import "UIView+Additions.h"

@implementation BehaviorSectionHeaderView

@synthesize expanded = expanded_;

+ (BehaviorSectionHeaderView *)viewWithTitle:(NSString *)title {
  return [[self alloc] initWithTitle:title];
}

- (void)drawBackground {
  UIImage *image = [UIImage imageNamed:@"section-bg.png"];
  UIImageView *bgView = [[UIImageView alloc] initWithImage:image];
  bgView.width = SCREEN_WIDTH;
  [self addSubview:bgView];
}

- (id)initWithTitle:(NSString *)title {
  self = [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 29)];
  if (self) {
    expanded_ = YES;
    [self drawBackground];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.left = 10;
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    [self addSubview:label];
  }
  return self;
}
@end
