#import <CoreData/CoreData.h>

@class Event;

@interface Behavior : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Event *currentEvent;
@end

@interface Behavior (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
