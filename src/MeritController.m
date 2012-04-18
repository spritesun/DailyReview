#import "MeritController.h"

@implementation MeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  dataSource_ = [BehaviorDataSource merits];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  dataSource_ = nil;
  [super viewDidUnload];  
}

@end
