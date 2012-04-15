#import "Behavior.h"

@implementation Behavior

@synthesize name = name_, rank = rank_, count = count_;

+ (Behavior *)behaviorWithName:(NSString *)name rank:(NSInteger)rank {
  return [[self alloc] initWithName:name rank:rank];
}

- (id)initWithName:(NSString *)name rank:(NSInteger)rank {
  self = [super init];
  if (self) {
    name_ = [name copy];
    rank_ = rank;
    count_ = 0;
  }
  return self;
}

@end
