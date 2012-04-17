#import "DemeritController.h"

@implementation DemeritController

#pragma mark - Initialization

- (id)init {
  self = [super init];
  if (self) {
    self.tabBarItem.image = [UIImage imageNamed:@"guo.png"];
  }
  return self;
}

#pragma mark - LifeCycles

- (void)viewDidLoad {
  self.dataSource = [BehaviorDataSource demerits];

  [super viewDidLoad];
}

- (void)viewDidUnload {
  self.dataSource = nil;
  [super viewDidUnload];  
}

@end
