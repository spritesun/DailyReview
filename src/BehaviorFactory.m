#import "BehaviorFactory.h"
#import "Behavior.h"

@implementation BehaviorFactory

+ (NSArray *)sharedMerits {
  static dispatch_once_t shared_initialized;
  static NSArray *merits = nil;

  dispatch_once(&shared_initialized, ^{
    NSMutableArray *merits_1 = [NSMutableArray array];
    [merits_1 addObject:[Behavior behaviorWithName:@"赞一人善" rank:1]];
    [merits_1 addObject:[Behavior behaviorWithName:@"掩一人恶" rank:1]];
    [merits_1 addObject:[Behavior behaviorWithName:@"劝息一人争" rank:1]];
    [merits_1 addObject:[Behavior behaviorWithName:@"阻人一非为事" rank:1]];
    [merits_1 addObject:[Behavior behaviorWithName:@"济一人饥" rank:1]];
    [merits_1 addObject:[Behavior behaviorWithName:@"留无归人一宿" rank:1]];
    [merits_1 addObject:[Behavior behaviorWithName:@"救一人寒" rank:1]];
    [merits_1 addObject:[Behavior behaviorWithName:@"施药一服" rank:1]];

    NSMutableArray *merits_3 = [NSMutableArray array];
    [merits_3 addObject:[Behavior behaviorWithName:@"受一横不嗔" rank:3]];
    [merits_3 addObject:[Behavior behaviorWithName:@"任一谤不辩" rank:3]];

    NSMutableArray *merits_5 = [NSMutableArray array];
    [merits_5 addObject:[Behavior behaviorWithName:@"劝息一人讼" rank:5]];
    [merits_5 addObject:[Behavior behaviorWithName:@"传人一保益性命事" rank:5]];

    merits = [NSArray arrayWithObjects:merits_1, merits_3, merits_5, nil];
  });

  return merits;
}

+ (NSArray *)sharedMeritCategories {
  static dispatch_once_t shared_initialized;
  static NSMutableArray *meritCategories = nil;

  dispatch_once(&shared_initialized, ^{
    meritCategories = [NSMutableArray array];
    [meritCategories addObject:@"准一功"];
    [meritCategories addObject:@"准三功"];
    [meritCategories addObject:@"准五功"];
  });

  return meritCategories;
}

@end
