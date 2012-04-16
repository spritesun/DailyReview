//  Created by Oliver Jones on 27/02/12.
//  Copyright (c) 2012 REA Group. All rights reserved.

@class Binding;

typedef void (^BindingActionBlock)(Binding *binding, id oldValue, id newValue);

@interface Binding : NSObject

@property(nonatomic, retain, readonly) id source;
@property(nonatomic, retain, readonly) id target;
@property(nonatomic, retain, readonly) NSString *sourceKeyPath;
@property(nonatomic, retain, readonly) NSString *targetKeyPath;
@property(nonatomic, copy, readonly) BindingActionBlock action;

+ (id)bindingWithSource:(id)source
          sourceKeyPath:(NSString *)sourceKeyPath
                 target:(id)target
          targetKeyPath:(NSString *)targetKeyPath
       initializeTarget:(BOOL)initializeTarget
                 action:(BindingActionBlock)blockOrNil;

@end