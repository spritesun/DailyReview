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
  static NSArray *merits = nil;
  
  dispatch_once(&shared_initialized, ^ {
    NSMutableArray *merits_1 = [NSMutableArray array];
    [merits_1 addObject:[Behavior behaviorWithName:@"赞一人善" rank:1]]; 
    [merits_1 addObject:[Behavior behaviorWithName:@"掩一人恶" rank:1]]; 
    
    NSMutableArray *merits_3 = [NSMutableArray array];
    [merits_3 addObject:[Behavior behaviorWithName:@"受一横不嗔" rank:3]]; 
    [merits_3 addObject:[Behavior behaviorWithName:@"任一谤不辩" rank:3]]; 
    
    merits = [NSArray arrayWithObjects:merits_1, merits_3, nil];    
  });
  
  return merits;
}

@end
