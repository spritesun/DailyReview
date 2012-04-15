//
//  Event.h
//  MeritDemeritCell
//
//  Created by Long Sun on 15/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Behavior;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) Behavior *behavior;

@end
