// Created by Long Sun on 12/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "NotificationSettingController.h"
#import "UserDefaultsManager.h"

@interface NotificationSettingController ()
@property(weak, nonatomic) IBOutlet UISwitch *switcher;
@property(weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation NotificationSettingController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.switcher.on = [UserDefaultsManager sharedManager].isNotificationOn;
    self.datePicker.date = [UserDefaultsManager sharedManager].notifyTime;
}

- (IBAction)switchValueChanged:(id)sender {

    [UserDefaultsManager sharedManager].isNotificationOn = self.switcher.on;
}

- (IBAction)notifyTimeValueChanged:(id)sender {
    [UserDefaultsManager sharedManager].notifyTime = self.datePicker.date;
}

@end