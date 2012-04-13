@interface Behavior : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger rank;
@property (nonatomic, assign) NSUInteger count;

+ (Behavior *)behaviorWithName:(NSString *)name rank:(NSInteger)rank;

@end
