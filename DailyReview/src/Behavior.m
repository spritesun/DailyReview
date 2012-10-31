#import "Behavior.h"
#import "Event.h"
#import "NSSet+Additions.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSDate+Additions.h"

static NSDictionary *categoryNamesDict = nil;

@implementation Behavior

@dynamic name;
@dynamic rank;
@dynamic timestamp;
@dynamic events;

@dynamic category;

+ (void)initialize {
    if (!categoryNamesDict) {
        categoryNamesDict = DICT(
        [NSNumber numberWithInt:1], @"准一功",
        [NSNumber numberWithInt:3], @"准三功",
        [NSNumber numberWithInt:5], @"准五功",
        [NSNumber numberWithInt:10], @"准十功",
        [NSNumber numberWithInt:30], @"准三十功",
        [NSNumber numberWithInt:50], @"准五十功",
        [NSNumber numberWithInt:100], @"准百功",
        [NSNumber numberWithInt:-1], @"准一过",
        [NSNumber numberWithInt:-3], @"准三过",
        [NSNumber numberWithInt:-5], @"准五过",
        [NSNumber numberWithInt:-10], @"准十过",
        [NSNumber numberWithInt:-30], @"准三十过",
        [NSNumber numberWithInt:-50], @"准五十过",
        [NSNumber numberWithInt:-100], @"准百过"
        );
    }
}

+ (NSDictionary *)getAllCategoryDictionary {
    return categoryNamesDict;
}

- (Event *)eventForDate:(NSDate *)date {
    return [self.events first:^BOOL(Event *event) {
        return [event isOnDate:date];
    }];
}

- (NSString *)category {
    return [categoryNamesDict objectForKey:self.rank];
}

- (Event *)createEventForDate:(NSDate *)currentDate {
    if (nil == [self eventForDate:currentDate]) {
        [self addEventsObject:[Event eventForBehavior:self onDate:currentDate]];
    }
    return [self eventForDate:currentDate];
}
@end
