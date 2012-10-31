#import "BehaviorResultsController.h"
#import "NSManagedObjectContext+Additions.m"
#import "NSArray+Additions.h"
#import "Event.h"
#import "NSDate+Additions.h"

@implementation BehaviorResultsController

+ (BehaviorResultsController *)sharedMeritResultsController {
    static dispatch_once_t onceToken;
    static BehaviorResultsController *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithPredicate:[NSPredicate predicateWithFormat:@"rank > 0"]
                                            sorter:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES]
                                         cacheName:@"meritCache"];
    });
    return instance;
}

+ (BehaviorResultsController *)sharedDemeritResultsController {
    static dispatch_once_t onceToken;
    static BehaviorResultsController *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithPredicate:[NSPredicate predicateWithFormat:@"rank < 0"]
                                            sorter:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:NO]
                                         cacheName:@"demeritCache"];
    });
    return instance;
}

- (id)initWithPredicate:(NSPredicate *)predicate sorter:(NSSortDescriptor *)sorter cacheName:(NSString *)cacheName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
    [fetchRequest setSortDescriptors:Array([NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO], sorter)];
    [fetchRequest setPredicate:predicate];

    self = [super initWithFetchRequest:fetchRequest
                  managedObjectContext:[NSManagedObjectContext defaultContext]
                    sectionNameKeyPath:nil
                             cacheName:cacheName];
    if (self) {
        NSError *error = nil;
        [self performFetch:&error];
        [error handleWithDescription:@"Failed to initialize BehaviorResultsController"];
    }

    return self;
}

- (NSNumber *)totalRank {
    return [NSNumber numberWithInt:[self totalRankOnDate:nil]];
}

- (NSNumber *)todayRank {
    NSDate *today = [[NSDate date] dateWithoutTime];
    NSInteger result = [self totalRankOnDate:today];
    return [NSNumber numberWithInt:result];
}

- (NSPredicate *)getDatePredicate:(NSDate *)date {
    if (date) {
        return [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", date, [date dateByAddingTimeInterval:86400]];
    }
    return nil;
}

- (NSInteger)totalRankOnDate:(NSDate *)date {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSPredicate *behaviorsPredicate = [NSPredicate predicateWithFormat:@"behavior IN %@", [self fetchedObjects]];
    NSPredicate *datePredicate = [self getDatePredicate:date];

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:behaviorsPredicate, datePredicate, nil]];

    [request setPredicate:predicate];

    __block NSArray *results = nil;

    [context performBlockAndWait:^{
        results = [context executeFetchRequest:request error:nil];
    }];

    __block NSInteger totalRank = 0;
    [results each:^(Event *event) {
        totalRank += event.countValue * [[[event behavior] rank] intValue];
    }];

    return totalRank;
}
@end