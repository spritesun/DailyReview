#import "Event.h"
#import "Behavior.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSDate+Additions.h"

@implementation Event

@dynamic date;
@dynamic count;
@dynamic behavior;
@dynamic countValue;

+ (Event *)eventForBehavior:(Behavior *)behavior onDate:(NSDate *)date {
  Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[NSManagedObjectContext defaultContext]];
  event.behavior = behavior;
  event.count = [NSNumber numberWithInt:0];
  event.date = date;
  return event;
}

- (BOOL)isOnDate:(NSDate *)date {
  return [self.date isEqualToDate:date];
}

- (NSUInteger)countValue {
  return (NSUInteger) [self.count intValue];
}

- (void)setCountValue:(NSUInteger)aCountValue {
  self.count = [NSNumber numberWithInt:aCountValue];
}

@end
