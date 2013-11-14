#import "ScoreView.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@implementation ScoreView {
  UILabel *scoreLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    scoreLabel = [self createScoreLabel];
    [self addSubview:scoreLabel];
  }
  return self;
}

- (UILabel *)createScoreLabel {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 200.f, self.height)];
  label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  label.font = [UIFont boldSystemFontOfSize:14];
  label.textColor = [UIColor darkGrayColor];
  return label;
}

- (void)setMeritCount:(NSNumber *)merits demeritCount:(NSNumber *)demerits {
  scoreLabel.text = [NSString stringWithFormat:@"今日累功： %@  过: %@", merits, demerits];
}
@end
