#define HAS_FLAG(flags, flag) (((flags) & (flag)) != 0)

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480

#define Array(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define MArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

#define Set(...) [NSSet setWithObjects:__VA_ARGS__, nil]
#define MSet(...) [NSMutableSet setWithObjects:__VA_ARGS__, nil]

#define IDARRAY(...) ((__autoreleasing id[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define DICT(...) DictionaryWithKeysAndObjects(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

static inline NSDictionary *DictionaryWithKeysAndObjects(id *keysAndObjs, NSUInteger count) {
  id keys[count];
  id objs[count];
  for (NSUInteger i = 0; i < count; i++) {
    keys[i] = keysAndObjs[i * 2];
    objs[i] = keysAndObjs[i * 2 + 1];
  }
  
  return [NSDictionary dictionaryWithObjects:objs forKeys:keys count:count];
}
