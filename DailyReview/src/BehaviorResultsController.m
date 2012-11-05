#import "BehaviorResultsController.h"
#import "NSManagedObjectContext+Additions.m"
#import "NSArray+Additions.h"
#import "Event.h"
#import "NSDate+Additions.h"


@interface BehaviorResultsController ()
@property(nonatomic, copy) NSArray *cache;
@property(nonatomic, strong) NSPredicate *predicate;
@end

@implementation BehaviorResultsController
+ (BehaviorResultsController *)sharedMeritResultsController {
    static dispatch_once_t onceToken;
    static BehaviorResultsController *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithPredicate:[NSPredicate predicateWithFormat:@"rank > 0"]];
    });
    return instance;
}

+ (BehaviorResultsController *)sharedDemeritResultsController {
    static dispatch_once_t onceToken;
    static BehaviorResultsController *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithPredicate:[NSPredicate predicateWithFormat:@"rank < 0"]];
    });
    return instance;
}

- (id)initWithPredicate:(NSPredicate *)predicate {
    self = [super init];
    if (self) {
        self.predicate = predicate;
        [self performFetch];
    }
    return self;
}

- (void)performFetch {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
    request.predicate = self.predicate;
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    __block NSArray *dbResults = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        dbResults = [context executeFetchRequest:request error:&error];
        [error handleWithDescription:@"Failed to initialize BehaviorResultsController"];
    }];

    //sort by behavior total sum descending, abstract rank ascending.
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"events.@sum.count" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"rank.absInt" ascending:YES]];
    self.cache = [dbResults sortedArrayUsingDescriptors:sortDescriptors];
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
    //TODO: could we refactor something here? just a smell.
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
    //TODO: here we could use @sum
    [results each:^(Event *event) {
        totalRank += event.countValue * [[[event behavior] rank] intValue];
    }];

    return totalRank;
}

- (NSArray *)fetchedObjects {
    if (nil == self.cache) {
        [self performFetch];
    }
    return self.cache;
}

- (Behavior *)objectAtIndexPath:(NSIndexPath *)path {
    return [[self fetchedObjects] objectAtIndex:(NSUInteger) path.row];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    NSUInteger row = [[self fetchedObjects] indexOfObject:object];
    return [NSIndexPath indexPathForRow:row inSection:0];
}
@end