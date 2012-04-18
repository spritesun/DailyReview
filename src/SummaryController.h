//
//  SummaryController.h
//  DailyReview
//
//  Created by Shengtao Lei on 4/18/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *meritRankView;
@property (nonatomic, strong) IBOutlet UILabel *demeritRankView;
@property (nonatomic, strong) IBOutlet UILabel *totalRankView;
@end
