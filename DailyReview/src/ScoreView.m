#import "ScoreView.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@implementation ScoreView {
  UILabel *scoreLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self addSubview:[self createScoreLabel]];
  }
  return self;
}

- (UILabel *)createScoreLabel {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, self.width - 10.f, self.height)];
  label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor colorWithRed:1 green:.851 blue:.2];
  label.font = [UIFont boldSystemFontOfSize:14];
  return label;
}

- (void)setMeritCount:(NSNumber *)merits demeritCount:(NSNumber *)demerits {
  scoreLabel.text = [NSString stringWithFormat:@"今日累功： %@  过: %@", merits, demerits];
}
@end
