#import "BehaviorTableViewCell.h"
#import "UIGestureRecognizer+Blocks.h"

@implementation BehaviorTableViewCell

@synthesize behavior = behavior_;

+ (BehaviorTableViewCell *)cell;
{
  return [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    UIGestureRecognizer *increaseRecognizer = [UITapGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
      behavior_.count ++;
      // TODO:need refactor to KVO
      self.detailTextLabel.text = [NSString stringWithFormat:@"%d", behavior_.count];
      UIColor *originalColor = self.contentView.backgroundColor;
      [UIView animateWithDuration:0.2 animations:^{
        self.contentView.backgroundColor = [UIColor yellowColor];
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
          self.contentView.backgroundColor = originalColor;
        }];
      }];
    }];
    [self addGestureRecognizer:increaseRecognizer];    
    
    UISwipeGestureRecognizer *decreaseRecognizer = [UISwipeGestureRecognizer recognizerWithActionBlock:^(UISwipeGestureRecognizer *theRecognizer) {
      if (0 != behavior_.count) {
        behavior_.count --;
        // TODO:need refactor to KVO
        self.detailTextLabel.text = [NSString stringWithFormat:@"%d", behavior_.count];
        UIColor *originalColor = self.contentView.backgroundColor;
        [UIView animateWithDuration:0.2 animations:^{
          self.contentView.backgroundColor = [UIColor orangeColor];
        } completion:^(BOOL finished) {
          [UIView animateWithDuration:0.2 animations:^{
            self.contentView.backgroundColor = originalColor;
          }];
        }];
      }
    }];
    decreaseRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:decreaseRecognizer];    
  }
  return self;
}

- (void)setBehavior:(Behavior *)behavior
{
  behavior_ = behavior;
  self.textLabel.text = behavior_.name;
  // TODO:need refactor to KVO
  self.detailTextLabel.text = [NSString stringWithFormat:@"%d", behavior_.count];
}

@end
