//
//  DailyScoreFetcher.h
//  DailyReview
//
//  Created by Lei Zhang on 4/22/12.
//  Copyright 2012 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DailyScoreFetcher <NSObject>

-(NSNumber *) getSocre;
@end
