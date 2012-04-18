#import "BehaviorRepository.h"
#import "NSManagedObjectContext+Additions.m"

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
  return [self repositoryFromPredicate:@"rank > 0"];

}

+ (BehaviorRepository *)demerits {
  return [self repositoryFromPredicate:@"rank < 0"];
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
  return [[arrayOfBehaviors_ objectAtIndex:section] count];
}

- (Behavior *)behaviorForIndexPath:(NSIndexPath *)indexPath {
  return [[arrayOfBehaviors_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}


@end