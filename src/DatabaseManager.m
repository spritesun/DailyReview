#import "DatabaseManager.h"
#import "NSError+Additions.h"

static NSString *const kDatabaseFileName = @"mdc.sqlite";

@implementation DatabaseManager

+ (NSString *)installDatabaseIfNeed {
  NSString *targetPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
      stringByAppendingPathComponent:kDatabaseFileName];

  if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
    NSString *srcPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseFileName];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:targetPath error:&error]) {
      [error handleWithDescription:@"Unable to install the database."];
    }
  }
  return targetPath;
}

@end