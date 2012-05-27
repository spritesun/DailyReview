#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSDate *)dateWithoutTime {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];  
  [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  
  NSString *dateStringWithoutTime = [dateFormatter stringFromDate:self];
  
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
  
  return [dateFormatter dateFromString:dateStringWithoutTime];  
}

- (BOOL)isOnSameDate:(NSDate *)date {
  return [[self dateWithoutTime] isEqualToDate:[date dateWithoutTime]];
}

@end