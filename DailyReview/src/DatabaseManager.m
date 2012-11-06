#import "DatabaseManager.h"
#import "NSError+Additions.h"
#import "BehaviorResultsController.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSArray+Additions.h"

static NSString *const kDatabaseFileName = @"db.sqlite";

//introduce at version 1.1.0, so just ignore previous
typedef enum {
    DBVersionBefore110 = 0,
    DBVersionBrandNew,
    DBVersion110
} DBVersion;

static NSString *const kDBVersion = @"kDBVersion";

@implementation DatabaseManager

+ (NSString *)installDatabaseIfNeed {
    NSString *targetPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:kDatabaseFileName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        NSString *srcPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseFileName];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:targetPath error:&error]) {
            [error handleWithDescription:@"Unable to install the database."];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:DBVersionBrandNew forKey:kDBVersion];
    }
    return targetPath;
}

+ (void)migrateData {
    DBVersion version = (DBVersion) [[NSUserDefaults standardUserDefaults] integerForKey:kDBVersion];
    switch (version) {
        case DBVersionBefore110:
            NSLog(@"before 1.1.0");
            [self migrateTo110];
            break;
        case DBVersionBrandNew:
            NSLog(@"brand new");
            [[NSUserDefaults standardUserDefaults] setInteger:DBVersionBefore110 forKey:kDBVersion];//TODO: set to be VERSION110 after update db.sqlite
            break;
        case DBVersion110:
            NSLog(@"1.1.0");
            break;
    }
}

+ (void)migrateTo110 {
    NSLog(@"Migrating to 1.1.0");
    //remove zero count event, make sure does not insert zero count event first.
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"count == 0"];
    __block NSArray *events = nil;

    [context performBlockAndWait:^{
        events = [context executeFetchRequest:request error:nil];
    }];
    [events each:^(id event) {
        [context deleteObject:event];
        NSLog(@"Removing zero count event.");
    }];
    [context save];

    //insert annotaion

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:DBVersion110 forKey:kDBVersion];
    [ud synchronize];//Normally unnecessary, but as db migration is very important, ensure here
}
@end