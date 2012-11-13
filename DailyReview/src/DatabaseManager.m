#import "DatabaseManager.h"
#import "NSError+Additions.h"
#import "BehaviorResultsController.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSArray+Additions.h"
#import "Event.h"

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
            [[NSUserDefaults standardUserDefaults] setInteger:DBVersion110 forKey:kDBVersion];
            break;
        case DBVersion110:
            NSLog(@"1.1.0");
            break;
    }
}

+ (void)migrateTo110 {
    NSLog(@"Migrating to 1.1.0");
    NSManagedObjectContext *ctx = [NSManagedObjectContext defaultContext];

    //1.remove zero count event, make sure does not insert zero count event first.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"count == 0"];
    __block NSArray *events = nil;

    [ctx performBlockAndWait:^{
        events = [ctx executeFetchRequest:request error:nil];
    }];
    [events each:^(id event) {
        [ctx deleteObject:event];
        NSLog(@"Removing zero count event.");
    }];
    [ctx save];

    //2.rename and merge behaviors
    request = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
    __block NSArray *behaviors = nil;
    [ctx performBlockAndWait:^{
        behaviors = [ctx executeFetchRequest:request error:nil];
    }];

    //2.1combine 讲演善法, 谕及十人
    Behavior *mainOne = [self behaviorNamed:@"讲演善法" inBehaviors:behaviors];
    Behavior *theOneNeedToBeMergedBackToMain = [self behaviorNamed:@"谕及十人" inBehaviors:behaviors];
    if (mainOne && theOneNeedToBeMergedBackToMain) {
        [[theOneNeedToBeMergedBackToMain.events allObjects] each:^(Event *mergingEvent) {
            Event *mainEvent = [mainOne findOrCreateEventForDate:mergingEvent.date];
            mainEvent.count = [NSNumber numberWithInt:(mainEvent.count.intValue + mergingEvent.count.intValue)];
            [ctx deleteObject:mergingEvent];
        }];
        mainOne.name = @"讲演善法, 谕及十人";
        [ctx deleteObject:theOneNeedToBeMergedBackToMain];
    }

    //2.2rename 修置三宝寺院 =》 修置三宝寺院、造三宝尊像   造三宝尊像及施香烛灯油等物 =》施香烛灯油等物、施茶水    施茶水、舍棺木一切方便等事 =》舍棺木一切方便等事
    [self behaviorNamed:@"修置三宝寺院" inBehaviors:behaviors].name = @"修置三宝寺院、造三宝尊像";
    [self behaviorNamed:@"造三宝尊像及施香烛灯油等物" inBehaviors:behaviors].name = @"施香烛灯油等物、施茶水";
    [self behaviorNamed:@"施茶水、舍棺木一切方便等事" inBehaviors:behaviors].name = @"舍棺木一切方便等事";

    [ctx save];

    //3.insert annotation
    NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
    NSURL *fileUrl = [NSURL URLWithString:@"initial_data.json" relativeToURL:bundleUrl];
    NSArray *behaviorJSONArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:fileUrl] options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *object in behaviorJSONArray) {
        Behavior *behavior = [self behaviorNamed:[object valueForKey:@"name"] inBehaviors:behaviors];
        behavior.annotation = [object valueForKey:@"annotation"];
    }
    [ctx save];

    //4.raise up db version
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:DBVersion110 forKey:kDBVersion];
    [ud synchronize];//Normally unnecessary, but as db migration is very important, ensure here
    NSLog(@"Finishe migrated to 1.1.0");
}

+ (Behavior *)behaviorNamed:(NSString *)name inBehaviors:(NSArray *)behaviors {
    return [behaviors first:^BOOL(Behavior *behavior) {
        return [behavior.name isEqualToString:name];
    }];
}
@end