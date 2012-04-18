#import "Behavior.h"

@interface BehaviorRepository : NSObject

- (BehaviorRepository *)initWithBehaviors:(NSArray *)array;

+ (BehaviorRepository *)merits;

+ (BehaviorRepository *)demerits;

- (NSUInteger)categoryCount;

- (NSString *)categoryForSection:(NSUInteger)section;

- (NSUInteger)behaviorCountForSection:(NSUInteger)section;

- (Behavior *)behaviorForIndexPath:(NSIndexPath *)indexPath;

@end