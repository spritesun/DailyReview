#import "MeritController.h"

@implementation MeritController

#pragma mark - Initialization

- (id)init {
  self = [super init];
  if (self) {
    self.tabBarItem.image = [UIImage imageNamed:@"gong.png"];
  }
  return self;
}

#pragma mark - LifeCycles

- (void)viewDidLoad {
  self.dataSource = [BehaviorDataSource merits];
  [super viewDidLoad];
}

- (void)viewDidUnload {
  self.dataSource = nil;
  [super viewDidUnload];  
}

@end
