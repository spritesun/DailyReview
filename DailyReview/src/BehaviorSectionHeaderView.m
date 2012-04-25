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

- (id)initWithTitle:(NSString *)title {
  self = [self initWithFrame:CGRectMake(0, 0, 320, 30)];
  if (self) {
    expanded_ = YES;
    self.backgroundColor = [UIColor lightGrayColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.left = 10;
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    [self addSubview:label];
  }
  return self;
}
@end
