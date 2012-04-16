#import "Behavior.h"

@interface BehaviorDataSource : NSObject

- (BehaviorDataSource *)initWithBehaviors:(NSArray *)array;

+ (BehaviorDataSource *)merits;

+ (BehaviorDataSource *)demerits;

- (NSUInteger)categoryCount;

- (NSString *)categoryForSection:(NSUInteger)section;

- (NSUInteger)behaviorCountForSection:(NSUInteger)section;

- (Behavior *)behaviorForIndexPath:(NSIndexPath *)indexPath;

@end