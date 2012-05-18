#import "DemeritController.h"

@implementation DemeritController

#pragma mark - LifeCycles
@synthesize guoItem = guoItem_;

- (void)viewDidLoad {
  resultsController_ = [BehaviorResultsController sharedDemeritResultsController];
  [super setBarItem:guoItem_ withImage:[UIImage imageNamed:@"bottom-bar-item-guo"]];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  resultsController_ = nil;
  self.guoItem = nil;
  [super viewDidUnload];
}

@end
