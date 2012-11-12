// Created by Long Sun on 12/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

@interface UserDefaultsManager : NSObject

@property(nonatomic, strong) NSDate *notifyTime;

@property(nonatomic, assign) BOOL isNotificationOn;

+ (UserDefaultsManager *)sharedManager;
@end