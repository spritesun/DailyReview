#import "Event.h"
#import "Behavior.h"
#import "NSManagedObjectContext+Additions.h"


@implementation Event

@dynamic date;
@dynamic count;
@dynamic behavior;
@dynamic countValue;

+ (Event *)eventForBehavior:(Behavior *)behavior {
  Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[NSManagedObjectContext defaultContext]];
  event.behavior = behavior;
  event.count = [NSNumber numberWithInt:0];
  return event;
}

- (NSUInteger)countValue {
  return [self.count intValue];
}

- (void)setCountValue:(NSUInteger)aCountValue {
  self.count = [NSNumber numberWithInt:aCountValue];
}
@end
