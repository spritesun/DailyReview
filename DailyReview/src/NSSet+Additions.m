#import "NSSet+Additions.h"

@implementation NSSet (Additions)

- (id)first:(BOOL (^)(id item))block {
  id result = nil;
  
  for (id obj in self) {
    if (block(obj)) {
      result = obj;
      break;
    }
  }
  
  return result;
}

- (NSSet *)pick:(BOOL (^)(id item))block {
    NSMutableSet *result = [NSMutableSet setWithCapacity:[self count]];

    for (id obj in self) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }

    return [NSSet setWithSet:result];
}

@end
