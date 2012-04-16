#import "IntrospectManager.h"

// comment/uncoment this line for DCIntrospect disable/enable
#define WANT_DCINTROSPECT

#if defined(WANT_DCINTROSPECT) && defined(TARGET_IPHONE_SIMULATOR)
#define IS_DCINTROSPECT_ENABLED 1

#import "DCIntrospect.h"

#else
  #define IS_DCINTROSPECT_ENABLED 0
#endif

@implementation IntrospectManager

+ (void)loadIntrospect; {
#if IS_DCINTROSPECT_ENABLED
  [[DCIntrospect sharedIntrospector] start];
#endif
}

@end
