#import <CoreData/CoreData.h>

@class Behavior;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) Behavior *behavior;

@property (nonatomic, assign) NSUInteger countValue;

+ (Event *)eventForBehavior:(Behavior *)behavior onDate:(NSDate *)date;

- (BOOL)isOnDate:(NSDate *)date;

@end
