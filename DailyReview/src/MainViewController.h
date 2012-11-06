@class Behavior;

@interface MainViewController : UITabBarController <UITabBarDelegate>

@property(strong, nonatomic) IBOutlet UITabBar *tabBar;

- (void)behaviorDidSave:(Behavior *)behavior;

@end
