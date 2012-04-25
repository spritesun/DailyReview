#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (Additions)

- (NSArray *)indexPathsForSection:(id <NSFetchedResultsSectionInfo>)section;

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)sectionIndex;
@end