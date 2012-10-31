@interface DatabaseManager : NSObject

+ (NSString *)installDatabaseIfNeed;

+ (void)migrateData;
@end