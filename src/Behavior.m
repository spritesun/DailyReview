#import "Behavior.h"
#import "Event.h"
#import "NSSet+Additions.h"
#import "NSFetchedResultsController+Additions.h"
#import "NSArray+Additions.h"
#import "NSManagedObjectContext+Additions.h"

static NSDictionary *categoryNamesDict = nil;

@implementation Behavior

@dynamic name;
@dynamic rank;
@dynamic timestamp;
@dynamic events;

@dynamic category;

+ (void)initialize {
  if (!categoryNamesDict) {
    categoryNamesDict = DICT(
    [NSNumber numberWithInt:1], @"准一功",
    [NSNumber numberWithInt:3], @"准三功",
    [NSNumber numberWithInt:5], @"准五功",
    [NSNumber numberWithInt:10], @"准十功",
    [NSNumber numberWithInt:30], @"准三十功",
    [NSNumber numberWithInt:50], @"准五十功",
    [NSNumber numberWithInt:100], @"准百功",
    [NSNumber numberWithInt:-1], @"准一过",
    [NSNumber numberWithInt:-3], @"准三过",
    [NSNumber numberWithInt:-5], @"准五过",
    [NSNumber numberWithInt:-10], @"准十过",
    [NSNumber numberWithInt:-30], @"准三十过",
    [NSNumber numberWithInt:-50], @"准五十过",
    [NSNumber numberWithInt:-100], @"准百过"
    );
  }
}

- (Event *)eventForDate:(NSDate *)date {
  return [self.events first:^BOOL(Event *event) {
    return [event isOnDate:date];
  }];
}

- (NSString *)category {
  return [categoryNamesDict objectForKey:self.rank];
}

- (Event *)createEventForDate:(NSDate *)date {
  NSDate *currentDate_ = date;
  if (nil == [self eventForDate:currentDate_]) {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"behavior = %@ AND date = %@", self, currentDate_]];
    __block NSArray *results;
    [context performBlockAndWait:^{
      results = [context executeFetchRequest:request error:nil];
    }];
    if ([results isEmpty]) {
      [self addEventsObject:[Event eventForBehavior:self onDate:currentDate_]];
    } else {
      [self addEventsObject:[results first]];
    }
  }
  
  return [self eventForDate:currentDate_];
}

@end
