@interface NSDate (Additions)

- (NSDate *)dateWithoutTime;

- (BOOL)isEarlierThan:(NSDate *)date;
@end