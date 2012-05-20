//
//  UIImageView+Additions.h
//  DailyReview
//
//  Created by Lei Zhang on 5/20/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Additions)

+ (UIImageView *)initTransparentImage:(NSString *)imageName with:(CGFloat)opaque;

@end
