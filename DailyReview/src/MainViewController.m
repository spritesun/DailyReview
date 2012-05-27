#import "MainViewController.h"
#import "UIImage+Additions.h"

@implementation MainViewController

@synthesize tabBar = tabBar_;

#pragma mark - LifeCycles

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setBarItem:[tabBar_.items objectAtIndex:0] withImage:[UIImage imageNamed:@"bottom-bar-item-gong"]];
  [self setBarItem:[tabBar_.items objectAtIndex:1] withImage:[UIImage imageNamed:@"bottom-bar-item-guo"]];
  [self setBarItem:[tabBar_.items objectAtIndex:2] withImage:[UIImage imageNamed:@"bottom-bar-item-he"]];
  [self setBarItem:[tabBar_.items objectAtIndex:3] withImage:[UIImage imageNamed:@"bottom-bar-item-more"]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIImage *image = [UIImage imageNamed:@"bottom-bar-bg.png"];
  UIImageView *bgView = [[UIImageView alloc] initWithImage:image];
  bgView.frame = CGRectMake(0, 432, 320, 48);
  tabBar_.backgroundImage = image;
  tabBar_.selectionIndicatorImage = [UIImage transparentImage];
}

- (void)setBarItem:(UITabBarItem *)barItem withImage:(UIImage *)image {
  UIImage *diabledImage = [image grayish];
  [barItem setFinishedSelectedImage:image withFinishedUnselectedImage:diabledImage];
}
@end
