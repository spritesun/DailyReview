#import "Event.h"
#import "Behavior.h"
#import "DatabaseManager.h"
#import "NSManagedObjectContext+Additions.h"

#import "ContextTestHelper.h"

SPEC_BEGIN(EventSpec)

describe(@"Event", ^{

  it(@"should create event for behavior", ^{ 
    NSManagedObjectContext *context = [[[ContextTestHelper alloc] init] context];
    [NSManagedObjectContext stub:@selector(defaultContext) andReturn:context];
    Behavior *behavior = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
    
    NSDate *date = [NSDate new];
    
    Event *event = [Event eventForBehavior:behavior onDate:date];
    
    [[theValue(event.countValue) should] equal:theValue(0)];
    [[event.behavior should] equal:behavior];
    [[event.date should] equal:date];
  });

});

SPEC_END
