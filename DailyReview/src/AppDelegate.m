#import "AppDelegate.h"
#import "IntrospectManager.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [IntrospectManager loadIntrospect];

  return YES;
}

@end