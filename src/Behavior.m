//
//  Behavior.m
//  DailyReview
//
//  Created by Long Sun on 18/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "Behavior.h"
#import "Event.h"
#import "NSSet+Additions.h"

@implementation Behavior

@dynamic name;
@dynamic rank;
@dynamic timestamp;
@dynamic events;

- (Event *)eventForDate:(NSDate *)date {
  return [self.events first:^BOOL(Event *event) {  
    return [[event date] isEqualToDate:date];
  }];
}

@end
