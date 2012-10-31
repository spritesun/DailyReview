@interface NSSet (Additions)

- (id)first:(BOOL (^)(id item))block;

- (NSSet *)pick:(BOOL (^)(id item))block;
@end
