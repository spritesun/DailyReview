#import "NSError+Additions.h"

@implementation NSError (Additions)

- (void)handleWithDescription:(NSString *)description {
  NSLog(@"Handling error with description: %@", description);
  NSLog(@"Error description: %@", [self localizedDescription]);
  NSLog(@"Error user info:  %@", [self userInfo]);
}

@end