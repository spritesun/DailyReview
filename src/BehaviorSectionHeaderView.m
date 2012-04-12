#import "BehaviorSectionHeaderView.h"

@implementation BehaviorSectionHeaderView

@synthesize expanded = expanded_;

+ (BehaviorSectionHeaderView *)viewWithTitle:(NSString *)title section:(NSInteger)section
{
  return [[self alloc] initWithTitle:title section:section];
}

- (id)initWithTitle:(NSString *)title section:(NSInteger)section;
{
  self = [self initWithFrame:CGRectMake(0, 0, 320, 20)];
  if (self) {
    expanded_ = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor lightGrayColor];
    label.userInteractionEnabled = YES;        
    [self addSubview:label];
  }
  return self;          
}

@end
