//
//  BehaviorFactory.m
//  MeritDemeritCell
//
//  Created by Long Sun on 10/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "BehaviorFactory.h"
#import "Behavior.h"

@implementation BehaviorFactory

+ (NSArray *)sharedMerits
{
  static dispatch_once_t shared_initialized;
  static NSMutableArray *merits = nil;
  
  dispatch_once(&shared_initialized, ^ {
    merits = [NSMutableArray array];
    [merits addObject:[Behavior behaviorWithName:@"赞一人善" rank:1]]; 
    [merits addObject:[Behavior behaviorWithName:@"掩一人恶" rank:1]]; 
  });
  
  return merits;
}

@end
