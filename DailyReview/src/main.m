#import "AppDelegate.h"
#import "DatabaseManager.h"
#import "NSManagedObjectContext+Additions.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        //TODO: this supposed to be bad practise.
        NSString *databasePath = [DatabaseManager installDatabaseIfNeed];
        NSLog(@"database: %@", databasePath);
        [NSManagedObjectContext createDefaultContextWithPath:databasePath];

        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}