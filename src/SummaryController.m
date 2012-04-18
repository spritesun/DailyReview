//
//  SummaryController.m
//  DailyReview
//
//  Created by Shengtao Lei on 4/18/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "BehaviorRepository.h"
#import "SummaryController.h"

@interface SummaryController ()

@end

@implementation SummaryController

@synthesize meritRankView = meritRankView_;
@synthesize demeritRankView = demeritRankView_;
@synthesize totalRankView = totalRankView_;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSNumber *totalMeritRank = [[BehaviorRepository merits] totalRank];
  NSNumber *totalDemritRank = [[BehaviorRepository demerits] totalRank];
  
  [meritRankView_ setText:[totalMeritRank stringValue]];
  [demeritRankView_ setText:[totalDemritRank stringValue]];
  [totalRankView_ setText:[NSString stringWithFormat:@"%d", [totalMeritRank intValue] + [totalDemritRank intValue]]];
}
@end
