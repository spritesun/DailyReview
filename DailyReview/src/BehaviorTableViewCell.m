#import "BehaviorTableViewCell.h"

@implementation BehaviorTableViewCell

+ (BehaviorTableViewCell *)cell; {
  return [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (void)drawCellBorder {
  UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, 320, 0.5)];
  border.backgroundColor = [UIColor colorWithRed:.541 green:.706 blue:.376 alpha:1];
  [self addSubview:border];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    [self drawCellBorder];
  }
  return self;
}

@end
