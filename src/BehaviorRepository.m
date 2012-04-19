#import "BehaviorRepository.h"
#import "NSManagedObjectContext+Additions.m"
#import "NSArray+Additions.h"
#import "Event.h"

static NSDictionary *categoryNamesDict = nil;

@implementation BehaviorRepository {
  NSMutableArray *arrayOfBehaviors_;
  NSArray *categories_;
}

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

+ (BehaviorRepository *)repositoryFromPredicate:(NSString *)predicate {
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
  
  [request setPredicate:[NSPredicate predicateWithFormat:predicate]];
  [request setSortDescriptors:Array([NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES])];
  
  __block NSArray *results;
  
  [context performBlockAndWait:^{
    results = [context executeFetchRequest:request error:nil];
  }];
  
  return [[BehaviorRepository alloc] initWithBehaviors:results];
}

+ (BehaviorRepository *)merits {
  static BehaviorRepository *merits;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    merits = [self repositoryFromPredicate:@"rank > 0"];
  });
  return merits;
}

+ (BehaviorRepository *)demerits {
  static BehaviorRepository *demerits;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    demerits = [self repositoryFromPredicate:@"rank < 0"];
  });
  return demerits;
}

- (BehaviorRepository *)initWithBehaviors:(NSArray *)behaviors {
  self = [super init];
  if (self) {
    NSArray *ranks = [behaviors valueForKeyPath:@"@distinctUnionOfObjects.rank"];
    ranks = [ranks sortedArrayUsingDescriptors:[NSArray arrayWithObject:
                                                [NSSortDescriptor sortDescriptorWithKey:@"absInt" ascending:YES]]];
    //TODO: I need NSArray#sortAscending NSArray#reverse
    
    categories_ = [categoryNamesDict objectsForKeys:ranks notFoundMarker:@"未知"];
    
    arrayOfBehaviors_ = [NSMutableArray new];
    for (NSNumber *rank in ranks) {
      NSArray *behaviorsInSameRank = [behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rank = %@", rank]];
      [arrayOfBehaviors_ addObject:behaviorsInSameRank];
    }
  }
  
  return self;
}

- (NSUInteger)categoryCount {
  return [categories_ count];
}

- (NSString *)categoryForSection:(NSUInteger)section {
  return [categories_ objectAtIndex:section];
}

- (NSUInteger)behaviorCountForSection:(NSUInteger)section {
  return [(NSArray *)[arrayOfBehaviors_ objectAtIndex:section] count];
}

- (Behavior *)behaviorForIndexPath:(NSIndexPath *)indexPath {
  return [[arrayOfBehaviors_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSNumber *)totalRank {
  __block NSInteger result = 0;
  [arrayOfBehaviors_ each:^(NSArray *behaviors) {
    [behaviors each:^(id item) {
      result = result + [self totalRankForBehavior:item]; 
    }];
  }];
  return [NSNumber numberWithInt:result];
}

- (NSInteger)totalRankForBehavior:(Behavior *)behavior {
  
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
  
  // TODO: (Lei & Shengtao) use behavior in behavior_list, https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
  [request setPredicate:[NSPredicate predicateWithFormat:@"behavior=%@", behavior]];
  
  __block NSArray *results = nil;
  
  [context performBlockAndWait:^{
    results = [context executeFetchRequest:request error:nil];
  }];
  
  __block NSInteger totalRank = 0;
  [results each:^(Event * event) {
    totalRank = event.countValue * [[behavior rank] intValue];
  }];
  
  return totalRank;
}


@end