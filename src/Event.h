#import <CoreData/CoreData.h>

@class Behavior;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, assign) NSUInteger countValue;
@property (nonatomic, retain) Behavior *behavior;

+ (Event *)eventForBehavior:(Behavior *)behavior onDate:(NSDate *)date;

@end
