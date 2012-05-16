#import "UIGestureRecognizer+Blocks.h"
#import <objc/runtime.h>

static char kBlock;

@implementation UIGestureRecognizer (Blocks)

+ (id)recognizerWithActionBlock:(GestureActionBlock)action; {
  return [[[self class] alloc] initWithActionBlock:action];
}

- (id)initWithActionBlock:(GestureActionBlock)action; {
  if ((self = [self initWithTarget:self action:@selector(handleAction:)])) {
    [self setActionBlock:action];
  }

  return self;
}

- (void)handleAction:(UIGestureRecognizer *)recognizer; {
  GestureActionBlock block = [self actionBlock];
  if (nil != block) {
    block(recognizer);
  }
}

- (GestureActionBlock)actionBlock; {
  return objc_getAssociatedObject(self, &kBlock);
}

- (void)setActionBlock:(GestureActionBlock)block; {
  objc_setAssociatedObject(self, &kBlock, block, OBJC_ASSOCIATION_COPY);
}

@end
