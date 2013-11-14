#import "BehaviorTableViewCell.h"
#import "UIColor+Additions.h"

@implementation BehaviorTableViewCell

+ (BehaviorTableViewCell *)cell; {
  return [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.textLabel.textColor = [UIColor colorWithRed:.102 green:.169 blue:.2];
    self.detailTextLabel.textColor = [UIColor colorWithRed:.243 green:0 blue:0];
    self.detailTextLabel.font = [UIFont systemFontOfSize:26];
  }
  return self;
}

- (void)displayEventCount:(NSNumber *)count {
  if (count.intValue == 0) {
    self.detailTextLabel.text = @" ";
  } else {
    self.detailTextLabel.text = count.stringValue;
  }
}
@end
