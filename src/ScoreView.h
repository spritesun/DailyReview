//
//  ScoreView.h
//  DailyReview
//
//  Created by twer on 4/22/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreView : UIView

@property(nonatomic, retain, readwrite) NSNumber* todayMerit;
@property(nonatomic, retain, readwrite) NSNumber* todayDemerit;

@end
