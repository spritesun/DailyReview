// Created by Long Sun on 13/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "ThanksViewController.h"
#import "FullPageTextView.h"

static NSString *const thanks = @"感谢张磊，索勤，葛琳，次第花开，婆婆陈，以及诸位网友。没有你们的支持与建议，这个应用永远无法完成。\n\n南无本师释迦牟尼佛\n南无楞严会上佛菩萨\n\n南无阿弥陀佛\n南无观世音菩萨\n南无大势至菩萨\n";

@implementation ThanksViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[FullPageTextView alloc] initWithFrame:self.view.frame content:thanks];
}

@end