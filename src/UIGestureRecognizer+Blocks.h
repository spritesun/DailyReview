typedef void (^GestureActionBlock) (id);

@interface UIGestureRecognizer (Blocks)

+ (id)instanceWithActionBlock:(GestureActionBlock)action;

@end
