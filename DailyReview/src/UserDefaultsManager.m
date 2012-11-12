// Created by Long Sun on 12/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "UserDefaultsManager.h"

static NSString *const kNotifyTime = @"NotifyTime";
static NSString *const kIsNotificationOn = @"IsNotificationOn";

@implementation UserDefaultsManager
@dynamic notifyTime, isNotificationOn;


+ (UserDefaultsManager *)sharedManager {
    static dispatch_once_t onceToken;
    static UserDefaultsManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSDate *)notifyTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *time = [defaults objectForKey:kNotifyTime];
    if (nil == time) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
        [dateComps setHour:21];
        [dateComps setMinute:0];
        [dateComps setSecond:0];
        //for first time
        time = [calendar dateFromComponents:dateComps];
        [defaults setObject:time forKey:kNotifyTime];
        [defaults setBool:YES forKey:kIsNotificationOn];
        [self scheduleNotification:time];
    }
    return time;
}

- (void)setNotifyTime:(NSDate *)notifyTime {
    [[NSUserDefaults standardUserDefaults] setObject:notifyTime forKey:kNotifyTime];
    [self scheduleNotification:notifyTime];
}

- (void)scheduleNotification:(NSDate *)date {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = NSDayCalendarUnit;

    notification.alertBody = [NSString stringWithFormat:@"请您开始反省忏悔今日之功过。"];
    notification.alertAction = @"现在就去";

    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (BOOL)isNotificationOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsNotificationOn];
}

- (void)setIsNotificationOn:(BOOL)isNotificationOn {
    [[NSUserDefaults standardUserDefaults] setBool:isNotificationOn forKey:kIsNotificationOn];
    if (isNotificationOn) {
        [self scheduleNotification:self.notifyTime];
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

@end