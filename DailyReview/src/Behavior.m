#import "Behavior.h"
#import "Event.h"
#import "NSSet+Additions.h"
#import "NSManagedObjectContext+Additions.h"

static NSDictionary *categoryNamesDict = nil;

@implementation Behavior

@dynamic name;
@dynamic rank;
@dynamic timestamp;
@dynamic events;
@dynamic isHidden;
@dynamic isCustomised;
@dynamic annotation;
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
    return [self.events first:^BOOL(Event *theEvent) {
        return [theEvent isOnDate:date];
    }];
}

- (Event *)createEventForDate:(NSDate *)date {
    Event *event = [Event eventForBehavior:self onDate:date];
    [self addEventsObject:event];
    return event;
}

- (NSString *)category {
    return [categoryNamesDict objectForKey:self.rank];
}

- (void)increaseEventForDate:(NSDate *)date {
    Event *event = [self findOrCreateEventForDate:date];
    event.countValue++;
    [[NSManagedObjectContext defaultContext] save];
}

- (Event *)findOrCreateEventForDate:(NSDate *)date {
    Event *event = [self eventForDate:date];
    if (nil == event) {
        event = [self createEventForDate:date];
    }
    return event;
}

- (void)decreaseEventForDate:(NSDate *)date {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    Event *event = [self eventForDate:date];
    if (event.countValue > 0) {
        event.countValue--;
        if (event.countValue == 0) {
            [context deleteObject:event];
        }
        [context save];
    }
}
@end
