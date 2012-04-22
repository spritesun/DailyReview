//
//  ScoreView.m
//  DailyReview
//
//  Created by twer on 4/22/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "ScoreView.h"
#import "UIView+Additions.h"

@implementation ScoreView{
    UILabel *todayMerit;
      UILabel *todayDemerit;
}

@dynamic todayMerit;
@dynamic todayDemerit;

- (id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setSize:CGSizeMake(320, 27)];
    [self setBackgroundColor:[UIColor blackColor]];
    todayMerit = [self createScoreLabelWithX:0];
        [self addSubview:todayMerit];
    
    [self setSize:CGSizeMake(320, 27)];
    [self setBackgroundColor:[UIColor blackColor]];
    todayDemerit = [self createScoreLabelWithX:200];
    [self addSubview:todayDemerit];
  }
  return self;
}

- (UILabel *)createScoreLabelWithX:(NSInteger)x {
  
  UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 120, 27)];  
  scoreLabel.backgroundColor = [UIColor clearColor];
  scoreLabel.textColor = [UIColor whiteColor];
  scoreLabel.font = [UIFont systemFontOfSize:15];
  return scoreLabel;
}


- (void)setTodayMerit:(NSNumber *)todayScore {
  todayMerit.text = [NSString stringWithFormat:@"今日累功： %@", todayScore];
}

- (void)setTodayDemerit:(NSNumber *)todayScore {
  todayDemerit.text = [NSString stringWithFormat:@"今日累过： %@", todayScore];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
