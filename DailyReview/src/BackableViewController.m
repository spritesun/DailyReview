// Created by Long Sun on 13/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "BackableViewController.h"
#import "DRBackButton.h"

@implementation BackableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[DRBackButton button]];
}

@end