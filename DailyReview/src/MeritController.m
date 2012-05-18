#import "MeritController.h"


@implementation MeritController

#pragma mark - LifeCycles
@synthesize gongItem = gongItem_;

- (void)viewDidLoad {
  resultsController_ = [BehaviorResultsController sharedMeritResultsController];
  [super setBarItem:gongItem_ withImage:[UIImage imageNamed:@"bottom-bar-item-gong"]];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  resultsController_ = nil;
  self.gongItem = nil;
  [super viewDidUnload];  
}

@end
