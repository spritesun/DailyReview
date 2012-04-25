@interface NSArray (Additions)

- (id)first;

- (id)last;

- (BOOL)isNotEmpty;

- (BOOL)isEmpty;

- (void)each:(void (^)(id item))block;

- (void)eachWithIndex:(void (^)(id item, NSUInteger i))block;

- (NSArray *)filter:(BOOL (^)(id item))block;

- (NSArray *)pick:(BOOL (^)(id item))block;

- (id)first:(BOOL (^)(id item))block;

- (id)last:(BOOL (^)(id item))block;

- (NSArray *)map:(id (^)(id item))block;

- (BOOL)any:(BOOL (^)(id item))block;

- (BOOL)all:(BOOL (^)(id item))block;

- (NSArray *)reverse;


@end