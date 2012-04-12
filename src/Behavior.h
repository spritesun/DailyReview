@interface Behavior : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger rank;

+ (Behavior *)behaviorWithName:(NSString *)name rank:(NSInteger)rank;

@end
