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

@end
