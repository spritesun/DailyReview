#import "BehaviorDataSource.h"
#import "NSManagedObjectContext+Additions.m"

static NSMutableDictionary *categoryNamesDict = nil;

@implementation BehaviorDataSource {
  NSMutableArray *arrayOfBehaviors_;
  NSArray *categories_;
}

+ (void)initialize {
  if (!categoryNamesDict) {
    categoryNamesDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        @"准一功", [NSNumber numberWithInt:1],
        @"准三功", [NSNumber numberWithInt:3],
        @"准五功", [NSNumber numberWithInt:5],
        @"准十功", [NSNumber numberWithInt:10],
        @"准三十功", [NSNumber numberWithInt:30],
        @"准五十功", [NSNumber numberWithInt:50],
        @"准百功", [NSNumber numberWithInt:100],
        nil];
  }
}

+ (BehaviorDataSource *)merits {
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];

  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
  [request setPredicate:[NSPredicate predicateWithFormat:@"rank > 0"]];
  //TODO: read this for more ordering, http://stackoverflow.com/questions/2707905/retrieve-core-data-entities-in-order-of-insertion

  __block NSArray *results;

  [context performBlockAndWait:^{
    results = [context executeFetchRequest:request error:nil];
  }];

  return [[BehaviorDataSource alloc] initWithBehaviors:results];
}

+ (BehaviorDataSource *)demerits {
  return nil;
}

- (BehaviorDataSource *)initWithBehaviors:(NSArray *)behaviors {
  self = [super init];
  if (self) {
    NSArray *ranks = [behaviors valueForKeyPath:@"@distinctUnionOfObjects.rank"];
    ranks = [ranks sortedArrayUsingDescriptors:[NSArray arrayWithObject:
                                                [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
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