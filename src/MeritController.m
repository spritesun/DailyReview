#import "MeritController.h"

@implementation MeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  repository_ = [BehaviorRepository merits];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  repository_ = nil;
  [super viewDidUnload];  
}

@end
