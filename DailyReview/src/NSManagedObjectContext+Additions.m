#import "NSManagedObjectContext+Additions.h"
#import "NSError+Additions.h"

static NSManagedObjectContext *defaultContext_ = nil;

@implementation NSManagedObjectContext (Additions)

+ (NSManagedObjectContext *)createDefaultContextWithPath:(NSString *)databasePath {
    NSDictionary *options = @{
    NSMigratePersistentStoresAutomaticallyOption: @YES,
    NSInferMappingModelAutomaticallyOption: @YES
    };
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