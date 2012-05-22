//
//  ContextTestHelper.m
//  home-ideas
//
//  Copyright (c) 2011 REA Group. All rights reserved.
//

#import "ContextTestHelper.h"

@implementation ContextTestHelper
@synthesize model = model_;
@synthesize coordinator = coordinator_;
@synthesize context = context_;
@synthesize store = store_;

- (id)init;
{  
  if ((self = [super init])) 
  {
    NSArray *bundles = [NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]];
    
    [self setModel: [NSManagedObjectModel mergedModelFromBundles:bundles]];
    [self setCoordinator: [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]]];
    [self setStore:[[self coordinator] addPersistentStoreWithType:NSInMemoryStoreType 
                                        configuration:nil 
                                                  URL:nil 
                                              options:nil 
                                                error:NULL]];
    [self setContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    [[self context] setPersistentStoreCoordinator:[self coordinator]];
  }
  
  return self;
}

@end
