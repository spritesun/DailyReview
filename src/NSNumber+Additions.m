#import "NSNumber+Additions.h"

@implementation NSNumber (Additions)

- (int)absInt {
  return abs([self intValue]);
}

@end
