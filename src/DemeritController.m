#import "DemeritController.h"

@implementation DemeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
  repository_ = [BehaviorRepository demerits];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  repository_ = nil;
  [super viewDidUnload];  
}

@end
