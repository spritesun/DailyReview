//
//  Behavior.m
//  MeritDemeritCell
//
//  Created by Long Sun on 10/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "Behavior.h"

@interface Behavior ()

- (id)initWithName:(NSString *)name rank:(NSInteger)rank;

@end

@implementation Behavior

@synthesize name = name_, rank = rank_;

+ (Behavior *)behaviorWithName:(NSString *)name rank:(NSInteger)rank
{
  return [[self alloc] initWithName:name rank:rank];
}

- (id)initWithName:(NSString *)name rank:(NSInteger)rank
{
  self = [super init];
  if (self) {
    name_ = [name copy];
    rank_ = rank;    
  }
  return self;
}

@end
