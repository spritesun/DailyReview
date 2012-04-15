#import "BehaviorDataSource.h"
#import "ContextProvider.h"

static NSMutableDictionary *categoriesDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"准一功", [NSNumber numberWithInt:1], nil];

@implementation BehaviorDataSource {
  NSMutableArray *behaviorsGroups_;
  NSMutableArray *categories_;
}

- (BehaviorDataSource *)initWithBehaviors:(NSArray *)behaviors {
  self = [super init];

  categories_ = [NSMutableArray new];
  behaviorsGroups_ = [NSMutableArray new];

  NSMutableDictionary *dictionary = [NSMutableDictionary new];

  for (Behavior *behavior in behaviors) {
    NSString *category = [categoriesDict objectForKey:[behavior rank]];
    if (![categories_ containsObject:category]) {
      [categories_ addObject:category];
    }
    if (![[dictionary allKeys] containsObject:[behavior rank]]) {
      NSMutableArray *behaviorGroup = [NSMutableArray new];
      [behaviorGroup addObject:behavior];
      [dictionary setObject:behaviorGroup forKey:[behavior rank]];
    } else {
      [[dictionary objectForKey:[behavior rank]] addObject:behavior];
    }
  }

  NSArray *const sortedKeys = [[dictionary allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {

    if ([obj1 integerValue] > [obj2 integerValue]) {
      return (NSComparisonResult) NSOrderedDescending;
    }

    if ([obj1 integerValue] < [obj2 integerValue]) {
      return (NSComparisonResult) NSOrderedAscending;
    }
    return (NSComparisonResult) NSOrderedSame;
  }];

  for (NSNumber *rank in sortedKeys) {
    [behaviorsGroups_ addObject:[dictionary objectForKey:rank]];
  }
  return self;
}

+ (BehaviorDataSource *)merits {
  NSManagedObjectContext *context = [ContextProvider context];

  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
  [request setPredicate:[NSPredicate predicateWithFormat:@"rank > 0"]];
  [request setSortDescriptors:[NSArray arrayWithObjects:
      [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES],
      [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES], nil]];

  __block NSArray *results;

  [context performBlockAndWait:^{
    results = [context executeFetchRequest:request error:nil];
  }];

  return [[BehaviorDataSource alloc] initWithBehaviors:results];
}

+ (BehaviorDataSource *)demerits {
  return nil;
}

- (NSUInteger)categoryCount {
  return [categories count];
}

- (NSString *)categoryForSection:(NSUInteger)section {
  return [categories objectAtIndex:section];
}

- (NSUInteger)behaviorCountForSection:(NSUInteger)section {
  return [[behaviorsGroups objectAtIndex:section] count];
}

- (Behavior *)behaviorForIndexPath:(NSIndexPath *)indexPath {
  return [[behaviorsGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}


@end