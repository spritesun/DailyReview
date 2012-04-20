#import "Behavior.h"

@interface BehaviorResultsController : NSFetchedResultsController

+ (BehaviorResultsController *)sharedMeritResultsController;

+ (BehaviorResultsController *)sharedDemeritResultsController;

- (NSNumber *)totalRank;

@end