#import "BehaviorSectionHeaderView.h"
#import "BehaviorResultsController.h"
#import "UIView+Additions.h"

@implementation BehaviorSectionHeaderView

@synthesize expanded = expanded_;

+ (BehaviorSectionHeaderView *)viewWithTitle:(NSString *)title {
  return [[self alloc] initWithTitle:title];
}

- (UILabel *)createScoreLabel {
  UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 30)];  
  scoreLabel.backgroundColor = [UIColor clearColor];
  scoreLabel.textColor = [UIColor whiteColor];
  scoreLabel.font = [UIFont systemFontOfSize:15];
  return scoreLabel;
}

- (void)drawBackground {
  UIImage *image = [UIImage imageNamed:@"section-bg.png"];
  UIImageView *bgView = [[UIImageView alloc] initWithImage:image];
  bgView.frame = CGRectMake(0, 0, 320, 30);
  [self addSubview:bgView];
}

- (id)initWithTitle:(NSString *)title {
  self = [self initWithFrame:CGRectMake(0, 0, 320, 30)];
  if (self) {
    expanded_ = YES;
    [self drawBackground];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.left = 10;
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    label.userInteractionEnabled = YES;
    [self addSubview:label];
  }
  return self;
}
@end
