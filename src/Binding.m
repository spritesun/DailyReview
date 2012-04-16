//  Created by Oliver Jones on 27/02/12.
//  Copyright (c) 2012 REA Group. All rights reserved.

#import "Binding.h"
#import <libkern/OSAtomic.h>

@implementation Binding {
  int32_t isSettingValue;
}

@synthesize source = source_, target = target_, sourceKeyPath = sourceKeyPath_, targetKeyPath = targetKeyPath_, action = action_;

+ (id)bindingWithSource:(id)source
          sourceKeyPath:(NSString *)sourceKeyPath
                 target:(id)target
          targetKeyPath:(NSString *)targetKeyPath
       initializeTarget:(BOOL)initializeTarget
                 action:(BindingActionBlock)blockOrNil {
  return [[self alloc] initWithSource:source
                        sourceKeyPath:sourceKeyPath
                               target:target
                        targetKeyPath:targetKeyPath
                     initializeTarget:initializeTarget
                               action:blockOrNil];
}

- (Binding *)initWithSource:(id)source
              sourceKeyPath:(NSString *)sourceKeyPath
                     target:(id)target
              targetKeyPath:(NSString *)targetKeyPath
           initializeTarget:(BOOL)initializeTarget
                     action:(BindingActionBlock)blockOrNil {
  AssertNotNil(source);
  AssertNotEmpty(sourceKeyPath);

  self = [super init];
  if (self) {
    source_ = source;
    target_ = target;
    sourceKeyPath_ = sourceKeyPath;
    targetKeyPath_ = targetKeyPath;
    action_ = [blockOrNil copy];

    [source addObserver:self
             forKeyPath:sourceKeyPath
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | (initializeTarget ? NSKeyValueObservingOptionInitial : 0)
                context:NULL];
  }

  return self;
}

- (void)dealloc {
  [self.source removeObserver:self forKeyPath:self.sourceKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (object == self.source) {
    // Don't re-enter binding code while setting original.
    if (OSAtomicCompareAndSwap32(0, 1, &isSettingValue)) {
      AssertWithMessage([[change objectForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeSetting,
          @"Binding collections is not supported yet.");

      id newValue = [change objectForKey:NSKeyValueChangeNewKey];
      id oldValue = [change objectForKey:NSKeyValueChangeOldKey];

      newValue = [newValue isKindOfClass:[NSNull class]] ? nil : newValue;
      oldValue = [oldValue isKindOfClass:[NSNull class]] ? nil : oldValue;

//      NSLog(@"Observed change in keyPath '%@' from '%@' to '%@' for binding %@.", keyPath, oldValue, newValue, self);

      if (self.action) {
        self.action(self, oldValue, newValue);
      }
      else {
        [self.target setValue:newValue forKey:self.targetKeyPath];
      }

      // remove re-entrance guard.
      OSAtomicCompareAndSwap32(1, 0, &isSettingValue);
    }
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: source:%@, sourceKeyPath:%@, target:%@, targetKeyPath:%@>",
                                    [self class],
                                    self.source,
                                    self.sourceKeyPath,
                                    self.target,
                                    self.targetKeyPath];
}

@end