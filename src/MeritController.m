#import "MeritController.h"

@implementation MeritController

- (void)viewDidLoad {
  self.dataSource = [BehaviorDataSource merits];
  self.tabBarItem.image = [UIImage imageNamed:@"gong.png"];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  self.dataSource = nil;
  [super viewDidUnload];  
}

@end
