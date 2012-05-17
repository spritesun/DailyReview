#import "ScoreView.h"
#import "UIView+Additions.h"

@implementation ScoreView {
  UILabel *scoreLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    const CGFloat height = 27;
    self.size = CGSizeMake(SCREEN_WIDTH, height);
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-bar-bg.png"]];
    self.backgroundView.width = SCREEN_WIDTH;
    scoreLabel = [self createScoreLabel];
    [self addSubview:scoreLabel];
  }
  return self;
}

- (UILabel *)createScoreLabel {
  UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor whiteColor];
  label.font = [UIFont systemFontOfSize:15];
  return label;
}

- (void)setMeritCount:(NSNumber *)merits demeritCount:(NSNumber *)demerits {
  scoreLabel.text = [NSString stringWithFormat:@"今日累功： %@ 过: %@", merits, demerits];
}
@end
