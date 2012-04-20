#import "BehaviorSectionHeaderView.h"
#import "BehaviorResultsController.h"
#import "UIView+Additions.h"

@implementation BehaviorSectionHeaderView {
  UILabel *todaySummary_;
  NSString *scoreName_;
}

@synthesize expanded = expanded_;
@dynamic todayScore;

+ (BehaviorSectionHeaderView *)viewWithTitle:(NSString *)title andScoreName:(NSString *)name {
  return [[self alloc] initWithTitle:title andScoreName:name];
}

- (id)initWithTitle:(NSString *)title andScoreName:(NSString *)name {
  self = [self initWithFrame:CGRectMake(0, 0, 320, 30)];
  if (self) {
    expanded_ = YES;
    self.backgroundColor = [UIColor lightGrayColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.left = 10;
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    [self addSubview:label];
    
    scoreName_ = name;
    
    todaySummary_ = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 30)];  
    todaySummary_.backgroundColor = [UIColor clearColor];
    todaySummary_.textColor = [UIColor whiteColor];
    todaySummary_.font = [UIFont systemFontOfSize:15];
    [self addSubview:todaySummary_];
  }
  return self;
}

- (void)setTodayScore:(NSNumber *)todayScore {
    todaySummary_.text = [NSString stringWithFormat:@"今日累%@： %@", scoreName_, todayScore];
}

- (void)clearScore {
      todaySummary_.text = @"";
}

@end
