#import "BehaviorTableViewCell.h"

@implementation BehaviorTableViewCell

+ (BehaviorTableViewCell *)cell; {
  return [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (void)drawCellKeyline {
  UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
  border.backgroundColor = [UIColor colorWithRed:.561 green:.698 blue:.349 alpha:1];
  [self addSubview:border];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor colorWithRed:.102 green:.169 blue:.2 alpha:1];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.textColor = [UIColor colorWithRed:.243 green:0 blue:0 alpha:1];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [self drawCellKeyline];
  }
  return self;
}

@end
