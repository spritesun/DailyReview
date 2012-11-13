#import <CoreData/CoreData.h>
#import "Behavior.h"

NSManagedObjectContext *managedObjectContext(NSString *);
NSArray *jsonObjectsFromSource(NSString *sourceFile);
void insertData(NSManagedObjectContext *context, NSArray* behaviorJSONArray);

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSString *databaseFile = @"/tmp/db.sqlite";
    [[NSFileManager defaultManager] removeItemAtPath:databaseFile error:nil];
    
    NSManagedObjectContext *context = managedObjectContext(databaseFile);
    insertData(context, jsonObjectsFromSource(@"initial_data.json"));    
  }
  return 0;
}

void insertData(NSManagedObjectContext *context, NSArray *behaviorJSONArray) {
  NSError *error = nil;    
  
  for (NSDictionary *object in behaviorJSONArray) {
    Behavior *behavior = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
    [behavior setName:[object valueForKey:@"name"]];
    [behavior setRank:[object valueForKey:@"rank"]];
    [behavior setAnnotation:[object valueForKey:@"annotation"]];
    [behavior setTimestamp:[NSDate date]];
    if (![context save:&error]) {
      NSLog(@"Error: %@", [error localizedDescription]);
      error = nil;
    }

  }
}

NSArray *jsonObjectsFromSource(NSString *sourceFile) {
  NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
  NSURL *fileUrl = [NSURL URLWithString:sourceFile relativeToURL:bundleUrl];
  return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:fileUrl] options:NSJSONReadingAllowFragments error:nil];
}


NSManagedObjectContext *managedObjectContext(NSString *dataFile) {
  
  static NSManagedObjectContext *context = nil;
  if (context != nil) {
    return context;
  }
  
  @autoreleasepool {
    context = [[NSManagedObjectContext alloc] init];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    [context setPersistentStoreCoordinator:coordinator];
    
    NSURL *url = [NSURL fileURLWithPath:[[dataFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"sqlite"]];
    
    NSError *error;
    NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    if (newStore == nil) {
      NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
    }
  }
  return context;
}