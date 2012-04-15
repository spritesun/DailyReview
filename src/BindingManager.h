//  Created by Oliver Jones on 27/02/12.
//  Copyright (c) 2012 REA Group. All rights reserved.

#import "Binding.h"

typedef enum {
  BindingManagerOptionsNone = 0,
  BindingManagerOptionsIntializeTarget,
  BingingManagerOptionsBidirectional
} BindingManagerOptions;

@interface BindingManager : NSObject

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
            action:(BindingActionBlock)blockOrNil;

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target;

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
 withTargetKeyPath:(NSString *)targetKeyPath;

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(BindingManagerOptions)options;

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
           options:(BindingManagerOptions)options;

- (void)bindSource:(id)source
      withKeyPaths:(NSArray *)sourceKeyPaths
          toTarget:(id)target
           options:(BindingManagerOptions)options;

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(BindingManagerOptions)options
            action:(BindingActionBlock)blockOrNil;

- (void)unbindSource:(id)source;


@end