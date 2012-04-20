#import "BehaviorResultsController.h"
#import "NSManagedObjectContext+Additions.m"
#import "NSArray+Additions.h"
#import "Event.h"
#import "NSDate+Additions.h"

@implementation BehaviorResultsController 

+ (BehaviorResultsController *)sharedMeritResultsController {
  static dispatch_once_t onceToken;
  static BehaviorResultsController *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] initWithPredicate:[NSPredicate predicateWithFormat:@"rank > 0"]
                                        sorter:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES]
                                     cacheName:@"meritCache"];
  });
  return instance;
}

+ (BehaviorResultsController *)sharedDemeritResultsController {
  static dispatch_once_t onceToken;
  static BehaviorResultsController *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] initWithPredicate:[NSPredicate predicateWithFormat:@"rank < 0"]
                                        sorter:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:NO]
                                     cacheName:@"demeritCache"];
  });
  return instance;
}

- (id)initWithPredicate:(NSPredicate *)predicate sorter:(NSSortDescriptor *)sorter cacheName:(NSString *)cacheName {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
  [fetchRequest setSortDescriptors:Array(sorter, [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES])];
  [fetchRequest setPredicate:predicate];

  self = [super initWithFetchRequest:fetchRequest
                managedObjectContext:[NSManagedObjectContext defaultContext]
                  sectionNameKeyPath:@"category"
                           cacheName:cacheName];
  if (self) {
    NSError *error = nil;
    [self performFetch:&error];
    [error handleWithDescription:@"Failed to initialize BehaviorResultsController"];
  }

  return self;
}

- (NSNumber *)totalRank {
  __block NSInteger result = 0;
  [[self fetchedObjects] each:^(Behavior *behavior) {
    result = result + [self totalRankForBehavior:behavior];
  }];
  return [NSNumber numberWithInt:result];
}

- (NSInteger)totalRankForBehavior:(Behavior *)behavior {
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];

  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];

  // TODO: (Lei) use behavior in behavior_list, https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
  [request setPredicate:[NSPredicate predicateWithFormat:@"behavior=%@", behavior]];

  __block NSArray *results = nil;

  [context performBlockAndWait:^{
    results = [context executeFetchRequest:request error:nil];
  }];

  __block NSInteger totalRank = 0;
  [results each:^(Event *event) {
    totalRank = event.countValue * [[behavior rank] intValue];
  }];

  return totalRank;
}

- (NSNumber *)todayRank {
  __block NSInteger result = 0;
  NSDate *today = [[NSDate date] dateWithoutTime];
  [[self fetchedObjects] each:^(Behavior *behavior) {
    result = result + [self totalRankForBehavior:behavior OnDate:today];
  }];
  return [NSNumber numberWithInt:result];
}

//TODO: (Qin) duplicated with totalRankForBehavior, need refactor
- (NSInteger)totalRankForBehavior:(Behavior *)behavior OnDate:(NSDate *)date {
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
  
  // TODO: (Lei) use behavior in behavior_list, https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
  [request setPredicate:[NSPredicate predicateWithFormat:@"behavior = %@ AND date = %@", behavior, date]];
  
  __block NSArray *results = nil;
  
  [context performBlockAndWait:^{
    results = [context executeFetchRequest:request error:nil];
  }];
  
  __block NSInteger totalRank = 0;
  [results each:^(Event *event) {
    totalRank = event.countValue * [[behavior rank] intValue];
  }];
  
  return totalRank;
}

@end