#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Additions)

+ (NSManagedObjectContext *)createDefaultContextWithPath:(NSString *)databasePath;

+ (NSManagedObjectContext *)createCloudContextWithPath:(NSString *)databasePath;

+ (NSManagedObjectContext *)defaultContext;

- (void)save;

@end