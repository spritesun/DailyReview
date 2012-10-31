@interface NSDate (Additions)

- (NSDate *)dateWithoutTime;

- (BOOL)isOnSameDate:(NSDate *)date;

- (BOOL)isEarlierThan:(NSDate *)date;
@end