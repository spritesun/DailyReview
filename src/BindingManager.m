//  Created by Oliver Jones on 27/02/12.
//  Copyright (c) 2012 REA Group. All rights reserved.

#import "BindingManager.h"

@implementation BindingManager {
  NSMutableSet *bindings_;
}

- (id)init {
  self = [super init];
  if (self) {
    bindings_ = [NSMutableSet new];
  }
  return self;
}

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
            action:(BindingActionBlock)blockOrNil {
  [self bindSource:source withKeyPath:sourceKeyPath toTarget:nil withTargetKeyPath:nil options:BindingManagerOptionsIntializeTarget action:blockOrNil];
}

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target {
  [self bindSource:source
       withKeyPath:sourceKeyPath
          toTarget:target
 withTargetKeyPath:sourceKeyPath
           options:BindingManagerOptionsIntializeTarget];
}

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
 withTargetKeyPath:(NSString *)targetKeyPath {
  [self bindSource:source
       withKeyPath:sourceKeyPath
          toTarget:target
 withTargetKeyPath:targetKeyPath
           options:BindingManagerOptionsIntializeTarget];
}

- (void)bindSource:(id)source
      withKeyPaths:(NSArray *)sourceKeyPaths
          toTarget:(id)target
           options:(BindingManagerOptions)options {
  for (NSString *keyPath in sourceKeyPaths) {
    [self bindSource:source
         withKeyPath:keyPath
            toTarget:target
             options:options];
  }
}

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
           options:(BindingManagerOptions)options {
  [self bindSource:source
       withKeyPath:sourceKeyPath
          toTarget:target
 withTargetKeyPath:sourceKeyPath
           options:options];
}

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(BindingManagerOptions)options {
  [self bindSource:source
       withKeyPath:sourceKeyPath
          toTarget:target
 withTargetKeyPath:targetKeyPath
           options:options
            action:nil];
}

- (void)bindSource:(id)source
       withKeyPath:(NSString *)sourceKeyPath
          toTarget:(id)target
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(BindingManagerOptions)options
            action:(BindingActionBlock)blockOrNil {
  Binding *binding = [Binding bindingWithSource:source
                                  sourceKeyPath:sourceKeyPath
                                         target:target
                                  targetKeyPath:targetKeyPath
                               initializeTarget:HAS_FLAG(options, BindingManagerOptionsIntializeTarget)
                                         action:blockOrNil];
  [bindings_ addObject:binding];

  if (HAS_FLAG(options, BingingManagerOptionsBidirectional)) {
    Binding *targetBinding = [Binding bindingWithSource:target
                                          sourceKeyPath:targetKeyPath
                                                 target:source
                                          targetKeyPath:sourceKeyPath
                                       initializeTarget:NO action:blockOrNil];
    [bindings_ addObject:targetBinding];
  }
}

- (void)unbindSource:(id)source {
  //TODO: Seems does not unbind target during bidirectional.
  if (source)
  {
    NSMutableSet *bindingsToRemove = [NSMutableSet new];
    for (Binding *binding in bindings_)
    {
      if (binding.source == source)
      {
        [bindingsToRemove addObject:binding];
      }
    }
    
    for (id o in bindingsToRemove)
    {
      [bindings_ removeObject:o];
    }    
  }
}

@end
