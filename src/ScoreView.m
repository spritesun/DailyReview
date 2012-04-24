//
//  ScoreView.m
//  DailyReview
//
//  Created by twer on 4/22/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "ScoreView.h"
#import "UIView+Additions.h"

@implementation ScoreView {
  UILabel *scoreLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setSize:CGSizeMake(320, 27)];
    [self setBackgroundColor:[UIColor blackColor]];
    scoreLabel = [self createScoreLabel];
    [self addSubview:scoreLabel];
  }
  return self;
}

- (UILabel *)createScoreLabel {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 27)];
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor whiteColor];
  label.font = [UIFont systemFontOfSize:15];
  return label;
}

- (void)setMeritCount:(NSNumber *)merits demeritCount:(NSNumber *)demerits {
  scoreLabel.text = [NSString stringWithFormat:@"今日累功： %@ 过: %@", merits, demerits];
}
@end
