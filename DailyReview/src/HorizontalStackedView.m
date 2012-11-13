// Created by Long Sun on 13/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "HorizontalStackedView.h"
#import "NSArray+Additions.h"
#import "UIView+Additions.h"

@implementation HorizontalStackedView

- (void)layoutSubviews {
    [super layoutSubviews];
    __block CGFloat width = 0;
    [self.subviews each:^(UIView *subview) {
        if (!subview.hidden) {
            subview.left = width;
            width += subview.width;
        }
    }];
}


@end