#import "Behavior.h"

@interface BehaviorRepository : NSObject

+ (BehaviorRepository *)merits;

+ (BehaviorRepository *)demerits;

- (NSUInteger)categoryCount;

- (NSString *)categoryForSection:(NSUInteger)section;

- (NSUInteger)behaviorCountForSection:(NSUInteger)section;

- (Behavior *)behaviorForIndexPath:(NSIndexPath *)indexPath;

@end