#import "Behavior.h"

@interface BehaviorResultsController : NSObject

+ (BehaviorResultsController *)sharedMeritResultsController;

+ (BehaviorResultsController *)sharedDemeritResultsController;

- (NSNumber *)totalRank;

- (NSNumber *)todayRank;
- (NSArray *)fetchedObjects;

- (Behavior *)objectAtIndexPath:(NSIndexPath *)path;
- (void)performFetch;

- (NSIndexPath *)indexPathForObject:(id)object;
@end