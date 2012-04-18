#import "DemeritController.h"

@implementation DemeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  dataSource_ = [BehaviorDataSource demerits];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  dataSource_ = nil;
  [super viewDidUnload];  
}

@end
