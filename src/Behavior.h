//
//  Behavior.h
//  MeritDemeritCell
//
//  Created by Long Sun on 10/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Behavior : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger rank;

+ (Behavior *)behaviorWithName:(NSString *)name rank:(NSInteger)rank;

@end
