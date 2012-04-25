#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (id)first {
  return [self count] > 0 ? [self objectAtIndex:0] : nil;
}

- (id)last {
  return [self lastObject];
}

- (BOOL)isEmpty {
  return [self count] == 0;
}

- (BOOL)isNotEmpty {
  return ![self isEmpty];
}

- (void)each:(void (^)(id item))block {
  [self enumerateObjectsUsingBlock:^(id item, NSUInteger __unused i, BOOL __unused *stop) {
    block(item);
  }];
}

- (void)eachWithIndex:(void (^)(id item, NSUInteger i))block {
  [self enumerateObjectsUsingBlock:^(id item, NSUInteger i, BOOL __unused *stop) {
    block(item, i);
  }];
}


- (NSArray *)filter:(BOOL (^)(id item))block {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

  for (id obj in self) {
    if (!block(obj)) {
      [result addObject:obj];
    }
  }

  return [NSArray arrayWithArray:result];
}

- (NSArray *)pick:(BOOL (^)(id item))block {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

  for (id obj in self) {
    if (block(obj)) {
      [result addObject:obj];
    }
  }

  return [NSArray arrayWithArray:result];
}

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

- (id)last:(BOOL (^)(id item))block {
  id result = nil;

  for (id obj in [self reverseObjectEnumerator]) {
    if (block(obj)) {
      result = obj;
      break;
    }
  }

  return result;
}

- (NSArray *)map:(id (^)(id item))block {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

  for (id obj in self) {
    [result addObject:block(obj)];
  }

  return [NSArray arrayWithArray:result];
}

- (id)reduce:(id (^)(id current, id item))block initial:(id)initial {
  id result = initial;

  for (id obj in self) {
    result = block(result, obj);
  }

  return result;
}

- (BOOL)any:(BOOL (^)(id item))block {
  return NSNotFound != [self indexOfFirst:block];
}

- (BOOL)all:(BOOL (^)(id item))block {
  return NSNotFound == [self indexOfFirst:^BOOL(id item) {
    return !block(item);
  }];
}

- (NSArray *)reverse {
  return [[self reverseObjectEnumerator] allObjects];
}

- (NSUInteger)indexOfFirst:(BOOL (^)(id item))block
{
  return [self indexOfObjectPassingTest:^ BOOL (id item, NSUInteger __unused idx, BOOL *stop) {
		if (block(item))
    {
      *stop = YES;
      return YES;
    }
    
    return NO;
  }];
}

@end