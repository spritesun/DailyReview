#import "BehaviorResultsController.h"
#import "ContextTestHelper.h"
#import "Event.h"
#import "NSDate+Additions.h"

SPEC_BEGIN(BehaviorResultsControllerSpec)

  __block NSManagedObjectContext *context;
  __block BehaviorResultsController *meritResultsController;

  beforeAll(^{
    context = [[[ContextTestHelper alloc] init] context];
    [NSManagedObjectContext stub:@selector(defaultContext) andReturn:context];

    Behavior *meritBehavior1 = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
    meritBehavior1.rank = [NSNumber numberWithInt:1];
    NSDate * date = [NSDate date];

    Event * event1 = [Event eventForBehavior:meritBehavior1 onDate:date];
    Event * event2 = [Event eventForBehavior:meritBehavior1 onDate:date];

    Behavior *meritBehavior2 = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
    meritBehavior2.rank = [NSNumber numberWithInt:10];
    Event * event3 = [Event eventForBehavior:meritBehavior2 onDate:date];


    event1.countValue++;
    event2.countValue++;
    event3.countValue = event3.countValue + 2;

    NSDate *yesterday = [date dateByAddingTimeInterval:-86400.0];
    Event * event4 = [Event eventForBehavior:meritBehavior1 onDate:yesterday];
    Event * event5 = [Event eventForBehavior:meritBehavior2 onDate:yesterday];

    event4.countValue++;
    event5.countValue++;

    meritResultsController = [BehaviorResultsController sharedMeritResultsController];
  });

  beforeEach(^{
    [NSManagedObjectContext stub:@selector(defaultContext) andReturn:context];
  });

  describe(@"BehaviorResultsController", ^{
    it(@"should return merit result controller with total rank", ^{
      [[[meritResultsController totalRank] should] equal:[NSNumber numberWithInt:33]];
    });

    it(@"should return merit result controller with today's rank", ^{
      [[[meritResultsController todayRank] should] equal: [NSNumber numberWithInt:22]];
    });
  });

SPEC_END
