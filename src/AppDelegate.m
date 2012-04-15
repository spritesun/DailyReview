#import "AppDelegate.h"
#import "Introspect.h"
#import <CoreData/CoreData.h>
#import "Behavior.h"

NSManagedObjectContext *managedObjectContext(NSString *);
@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Introspect loadIntrospect];
  
  NSString *databaseFile = @"/tmp/merit-demerit-cell.sqlite";
  
  NSManagedObjectContext *context = managedObjectContext(databaseFile);
  insertData(context);
  
  NSError *error = nil;    
  if (![context save:&error]) {
    NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
  }
  
  return YES;
}

void insertData(NSManagedObjectContext *context) {
  Behavior *behavior = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
  [behavior setName:@"赞一人善"];
  [behavior setRank:[NSNumber numberWithInt:1]];
}
@end

NSManagedObjectContext *managedObjectContext(NSString *dataFile) {
  
  static NSManagedObjectContext *context = nil;
  if (context != nil) {
    return context;
  }
  
  @autoreleasepool {
    context = [[NSManagedObjectContext alloc] init];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    [context setPersistentStoreCoordinator:coordinator];
    
    NSString *STORE_TYPE = NSSQLiteStoreType;
    NSURL *url = [NSURL fileURLWithPath:[[dataFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"sqlite"]];
    
    NSError *error;
    NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
    
    if (newStore == nil) {
      NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
    }
  }
  return context;
}