#import "BehaviorSectionHeaderView.h"
#import "UIView+Additions.h"

@implementation BehaviorSectionHeaderView

@synthesize expanded = expanded_;

+ (BehaviorSectionHeaderView *)viewWithTitle:(NSString *)title
{
  return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title;
{
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
