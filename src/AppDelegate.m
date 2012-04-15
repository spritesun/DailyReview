#import "AppDelegate.h"
#import "Introspect.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Introspect loadIntrospect];
  return YES;
}

@end
