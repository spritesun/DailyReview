#import "NSFetchedResultsController+Additions.h"
#import "NSArray+Additions.h"

@implementation NSFetchedResultsController (Additions)
- (NSArray *)indexPathsForSection:(id <NSFetchedResultsSectionInfo>)section {
  return [[section objects] map:^NSIndexPath *(id object) {
    return [self indexPathForObject:object];
  }];
}

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)sectionIndex {
  return [(id <NSFetchedResultsSectionInfo>) [[self sections] objectAtIndex:sectionIndex] numberOfObjects];
}


@end