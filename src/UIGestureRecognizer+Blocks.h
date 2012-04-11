//
//  UIGestureRecognizer+Blocks.h
//  MeritDemeritCell
//
//  Created by Long Sun on 11/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

typedef void (^GestureActionBlock) (id);

@interface UIGestureRecognizer (Blocks)

+ (id)instanceWithActionBlock:(GestureActionBlock)action;

@end
