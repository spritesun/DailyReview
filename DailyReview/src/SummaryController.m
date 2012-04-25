#import "BehaviorResultsController.h"
#import "SummaryController.h"
#import "NSArray+Additions.h"

@interface SummaryController ()

@end

@implementation SummaryController

@synthesize meritRankLabel = meritRankLabel_;
@synthesize demeritRankLabel = demeritRankLabel_;
@synthesize totalRankLabel = totalRankLabel_;

- (void)viewDidLoad {
  [super viewDidLoad];
  NSArray *labels = Array(meritRankLabel_, demeritRankLabel_, totalRankLabel_);

  const CGFloat labelX = 35;
  const CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - labelX;
  const CGFloat labelHeight = 28;
  const CGFloat labelSpacing = 20;

  __block CGFloat labelY = 125;

  [labels each:^(UILabel *label) {
    label.textColor = [UIColor colorWithRed:1 green:126.0 / 255 blue:0 alpha:1];
    // TODO: need better font, maybe use image instead
    label.font = [UIFont fontWithName:@"STHeitiK-Medium" size:26];
    label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    labelY += (labelHeight + labelSpacing);
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSNumber *totalMeritRank = [[BehaviorResultsController sharedMeritResultsController] totalRank];
  NSNumber *totalDemeritRank = [[BehaviorResultsController sharedDemeritResultsController] totalRank];

  meritRankLabel_.text = [NSString stringWithFormat:@"累计功德:  %@", totalMeritRank];
  demeritRankLabel_.text = [NSString stringWithFormat:@"累计过失:  %@", totalDemeritRank];
  totalRankLabel_.text = [NSString stringWithFormat:@"功过合计:  %d",
                                                    [totalMeritRank intValue] + [totalDemeritRank intValue]];
}
@end
