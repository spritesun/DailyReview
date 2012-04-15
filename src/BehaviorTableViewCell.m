#import "BehaviorTableViewCell.h"

@implementation BehaviorTableViewCell

@synthesize behavior = behavior_;

+ (BehaviorTableViewCell *)cell; {
  return [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)setBehavior:(Behavior *)behavior {
  behavior_ = behavior;
  self.textLabel.text = behavior_.name;
  self.detailTextLabel.text = [NSString stringWithFormat:@"%d", behavior_.count];
}

@end
