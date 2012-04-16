//
//  main.m
//  MeritDemeritCell
//
//  Created by Long Sun on 10/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseManager.h"
#import "NSManagedObjectContext+Additions.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    NSString *databasePath = [DatabaseManager installDatabaseIfNeed];
    [NSManagedObjectContext createDefaultContextWithPath:databasePath];

    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
