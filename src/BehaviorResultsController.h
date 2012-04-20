#import "Behavior.h"

@interface BehaviorResultsController : NSFetchedResultsController

+ (BehaviorResultsController *)sharedMeritResultsController;

+ (BehaviorResultsController *)sharedDemeritResultsController;

- (NSInteger)totalRankForBehavior:(Behavior *)behavior OnDate:(NSDate *)date;

- (NSNumber *)totalRank;

- (NSNumber *)todayRank;

@end