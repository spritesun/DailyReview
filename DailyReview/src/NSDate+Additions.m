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

- (BOOL)isEarlierThan:(NSDate *)anotherDate {
    return ([self compare:anotherDate] == NSOrderedAscending);
}

- (BOOL)isLaterThan:(NSDate *)anotherDate {
    return ([self compare:anotherDate] == NSOrderedDescending);
}
@end