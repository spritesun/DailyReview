#import "ScoreView.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@implementation ScoreView {
  UILabel *scoreLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    const CGFloat height = 27;
    self.size = CGSizeMake(SCREEN_WIDTH, height);
    self.backgroundView.width = SCREEN_WIDTH;
    scoreLabel = [self createScoreLabel];
    [self addSubview:scoreLabel];
  }
  return self;
}

- (UILabel *)createScoreLabel {
  UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
  label.left = 10;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor colorWithRed:1 green:.851 blue:.2];
  label.font = [UIFont boldSystemFontOfSize:14];
  return label;
}

- (void)setMeritCount:(NSNumber *)merits demeritCount:(NSNumber *)demerits {
  scoreLabel.text = [NSString stringWithFormat:@"今日累功： %@  过: %@", merits, demerits];
}
@end
