#import "Event.h"
#import "Behavior.h"

#import "ContextTestHelper.h"

SPEC_BEGIN(EventSpec)

describe(@"Event", ^{

  __block NSManagedObjectContext *context;
  __block Behavior *behavior;
  __block NSDate *date;
  __block Event *event;

  beforeEach(^{
    context = [[[ContextTestHelper alloc] init] context];
    [NSManagedObjectContext stub:@selector(defaultContext) andReturn:context];
    behavior = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
    date = [NSDate date];
    event = [Event eventForBehavior:behavior onDate:date];
  });

  it(@"should create event for behavior", ^{
    [[theValue(event.countValue) should] equal:theValue(0)];
    [[event.behavior should] equal:behavior];
    [[event.date should] equal:date];
  });

  it(@"should return YES if on same date with different time", ^{
    [[theValue([event isOnDate:[NSDate date]]) should] equal:theValue(YES)];
  });
});

SPEC_END
