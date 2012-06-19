#import "NSManagedObjectContext+Additions.h"
#import "NSError+Additions.h"
#import "Behavior.h"
#import "NSArray+Additions.h"

static NSManagedObjectContext *defaultContext_ = nil;

@implementation NSManagedObjectContext (Additions)

+ (NSManagedObjectContext *)createDefaultContextWithPath:(NSString *)databasePath {
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, nil];
  NSError *error = nil;
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
  [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                            configuration:nil URL:[NSURL fileURLWithPath:databasePath]
          options:options
            error:&error];
  if (error) {
    [error handleWithDescription:@"persistent store coordinator was not created"];
    return nil;
  }
  NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [context setPersistentStoreCoordinator:coordinator];

  defaultContext_ = context;
  return context;
}

+ (NSManagedObjectContext *)createCloudContextWithPath:(NSString *)databasePath {

  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];

//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
  NSString *iCloudEnabledAppId = @"5FQ33QXJZ3.com.sunlong.dailyreview.development";
  NSString *dataFileName = @"db.sqlite";

  NSString *iCloudDataDirectoryName = @"Data.nosync";
  NSString *iCloudLogsDirectoryName = @"Logs";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *iCloud = [fileManager URLForUbiquityContainerIdentifier:nil];

  if (iCloud) {
    NSURL *iCloudLogsPath = [NSURL fileURLWithPath:[[iCloud path] stringByAppendingPathComponent:iCloudLogsDirectoryName]];

    NSLog(@"iCloudEnabledAppID = %@", iCloudEnabledAppId);
    NSLog(@"dataFileName = %@", dataFileName);
    NSLog(@"iCloudDataDirectoryName = %@", iCloudDataDirectoryName);
    NSLog(@"iCloudLogsDirectoryName = %@", iCloudLogsDirectoryName);
    NSLog(@"iCloud = %@", iCloud);
    NSLog(@"iCloudLogsPath = %@", iCloudLogsPath);

    NSString *const iCloudDirectoryPath = [[iCloud path] stringByAppendingPathComponent:iCloudDataDirectoryName];
    if ([fileManager fileExistsAtPath:iCloudDirectoryPath] == NO) {
      NSError *fileSystemError;
      [fileManager createDirectoryAtPath:iCloudDirectoryPath withIntermediateDirectories:YES attributes:nil error:&fileSystemError];
      if (fileSystemError != nil) {
        NSLog(@"Error creating database directory %@", fileSystemError);
      }
    }

    NSString *iCloudData = [iCloudDirectoryPath stringByAppendingPathComponent:dataFileName];
    [[NSFileManager defaultManager] removeItemAtPath:iCloudData error:nil];
    NSLog(@"iCloudData = %@", iCloudData);

    NSMutableDictionary *const options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    [options setObject:iCloudEnabledAppId forKey:NSPersistentStoreUbiquitousContentNameKey];
    [options setObject:iCloudLogsPath forKey:NSPersistentStoreUbiquitousContentURLKey];

    [coordinator lock];

    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:iCloudData] options:options error:nil];

    [coordinator unlock];
  } else {
    NSLog(@"iCloud is not working - using local store");
    NSURL *localStore = [NSURL fileURLWithPath:databasePath];
    NSLog(@"localStore = %@", localStore);
    NSMutableDictionary *const options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];

    [coordinator lock];

    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:localStore] options:options error:nil];

    [coordinator unlock];
  }

//    dispatch_async(dispatch_get_main_queue(), ^void() {
//      [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:self userInfo:nil];
//    });
//  });

  NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

  [context performBlockAndWait:^void() {
    [context setPersistentStoreCoordinator:coordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChangesFrom_iCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
  }];

  defaultContext_ = context;

  [self initDataIfNeeded];

  return context;
}

+ (void)initDataIfNeeded {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
  __block NSArray *result = nil;
  [defaultContext_ performBlockAndWait:^void() {
    result = [defaultContext_ executeFetchRequest:fetchRequest error:nil];
  }];

  if ([result isEmpty]) {
    [self insertData:[self jsonObjectsFromSource:@"initial_data.json"]];
  }
}

+ (void)insertData:(NSArray *)behaviorJSONArray {
  NSError *error = nil;

  for (NSDictionary *object in behaviorJSONArray) {
    Behavior *behavior = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:defaultContext_];
    [behavior setName:[object valueForKey:@"name"]];
    [behavior setRank:[object valueForKey:@"rank"]];
    [behavior setTimestamp:[NSDate date]];
    if (![defaultContext_ save:&error]) {
      NSLog(@"Error: %@", [error localizedDescription]);
      error = nil;
    }
  }
}

+ (NSArray *)jsonObjectsFromSource:(NSString *)sourceFile {
  NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
  NSURL *fileUrl = [NSURL URLWithString:sourceFile relativeToURL:bundleUrl];
  return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:fileUrl] options:NSJSONReadingAllowFragments error:nil];
}

+ (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
  NSLog(@"Merging in changes from iCloud...");
  NSManagedObjectContext *const context = [self defaultContext];
  [context performBlock:^void() {
    [context mergeChangesFromContextDidSaveNotification:notification];
    NSNotification *const refreshNotification = [NSNotification notificationWithName:@"SomethingChanged" object:self userInfo:[notification userInfo]];
    [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
  }];
}

+ (NSManagedObjectContext *)defaultContext {
  AssertWithMessage(defaultContext_, @"Please createDefaultContextWithPath: before ask for defaultContext");
  return defaultContext_;
}

- (void)save {
  NSError *error = nil;
  [self save:&error];
  if (error) {
    [error handleWithDescription:@"NSManagedObjectContext failed to save object."];
  }
}

@end