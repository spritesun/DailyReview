//
//  Behavior.h
//  DailyReview
//
//  Created by Long Sun on 18/04/12.
//  Copyright (c) 2012 Sunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Behavior : NSManagedObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSNumber *rank;
@property(nonatomic, retain) NSDate *timestamp;
@property(nonatomic, retain) NSSet *events;
@property(nonatomic, retain) NSNumber *isHidden;
@property(nonatomic, retain) NSNumber *isCustomised;
@property(nonatomic, retain) NSString *annotation;
@property(nonatomic, readonly) NSString *category;

@property(nonatomic, retain) NSNumber *totalCount;

+ (NSDictionary *)getAllCategoryDictionary;

- (Event *)eventForDate:(NSDate *)date;

- (Event *)createEventForDate:(NSDate *)date;

- (void)increaseEventForDate:(NSDate *)date;

- (Event *)findOrCreateEventForDate:(NSDate *)date;

- (void)decreaseEventForDate:(NSDate *)date;
@end

@interface Behavior (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;

- (void)removeEventsObject:(Event *)value;

- (void)addEvents:(NSSet *)values;

- (void)removeEvents:(NSSet *)values;

@end
