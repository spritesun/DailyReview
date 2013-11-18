// Created by Long Sun on 13/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "ThanksViewController.h"
#import "FullPageTextView.h"

static NSString *const thanks = @"敬礼上师三宝。🙏\n\n感谢张磊，索勤，葛琳，以及诸位朋友。没有你们的支持与建议，这个应用永远无法完成。\n\n南无本师释迦牟尼佛。🙏";

@implementation ThanksViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[FullPageTextView alloc] initWithFrame:self.view.frame content:thanks];
}

@end