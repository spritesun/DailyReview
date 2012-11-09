// Created by Long Sun on 9/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "DRBackButton.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"

@implementation DRBackButton

+ (DRBackButton *)button {
    DRBackButton *object = [DRBackButton buttonWithType:UIButtonTypeCustom];

    UIImage *backButtonBgImage = [UIImage imageNamed:@"back-button"];
    [object setBackgroundImage:backButtonBgImage forState:UIControlStateNormal];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, backButtonBgImage.size.width, backButtonBgImage.size.height)];
    label.text = @"返回";
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor colorWithRed:.82 green:.714 blue:.2];
    label.backgroundColor = [UIColor clearColor];
    [object addSubview:label];
    object.frame = CGRectMake(0, 0, backButtonBgImage.size.width, backButtonBgImage.size.height);
    [object addTarget:object action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    return object;
}

- (void)back {
    [(UINavigationController *)[self viewController] popViewControllerAnimated:YES];
}

@end