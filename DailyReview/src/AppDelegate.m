#import "AppDelegate.h"
#import "IntrospectManager.h"
#import "BehaviorViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [IntrospectManager loadIntrospect];

  return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {  
  UIViewController *currentController = self.window.rootViewController;
  if ([currentController isKindOfClass:[UITabBarController class]]) {
    UIViewController *selectedController = [(UITabBarController *)currentController selectedViewController];
    if ([selectedController isKindOfClass:[BehaviorViewController class]]) {
      [(BehaviorViewController *)selectedController refreshView];
    }
  }
}

@end