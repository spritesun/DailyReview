typedef void (^GestureActionBlock)(id theRecognizer);

@interface UIGestureRecognizer (Blocks)

+ (id)recognizerWithActionBlock:(GestureActionBlock)action;

@end
