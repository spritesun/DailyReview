#import "DemeritController.h"

@implementation DemeritController

- (void)viewDidLoad {
  self.dataSource = [BehaviorDataSource demerits];
  self.tabBarItem.image = [UIImage imageNamed:@"guo.png"];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  self.dataSource = nil;
  [super viewDidUnload];  
}

@end
