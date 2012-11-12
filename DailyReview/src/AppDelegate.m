#import "AppDelegate.h"
#import "IntrospectManager.h"
#import "BehaviorViewController.h"
#import "DatabaseManager.h"
#import "NSArray+Additions.h"
#import "UserDefaultsManager.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.applicationIconBadgeNumber = 0;
    [IntrospectManager loadIntrospect];
    [DatabaseManager migrateData];
    //If there is no notify time in user defaults(for first time), this will trigger the create, and notification schedule.
    [[UserDefaultsManager sharedManager] notifyTime];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    UIViewController *currentController = self.window.rootViewController;
    if ([currentController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedController = [(UITabBarController *) currentController selectedViewController];
        if ([selectedController isKindOfClass:[BehaviorViewController class]]) {
            [(BehaviorViewController *) selectedController refreshView];
        }
    }
}

@end