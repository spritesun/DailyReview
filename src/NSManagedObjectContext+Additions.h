#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Additions)

+ (NSManagedObjectContext *)createDefaultContextWithPath:(NSString *)databasePath;

+ (NSManagedObjectContext *)defaultContext;

@end