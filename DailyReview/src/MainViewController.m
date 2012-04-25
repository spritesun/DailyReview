#import "MainViewController.h"

@implementation MainViewController

@synthesize tabBar = tabBar_;

#pragma mark - LifeCycles

- (void)viewDidLoad {
  [super viewDidLoad];
  UIImage *image = [UIImage imageNamed:@"bottom-bar-bg.png"];
  UIImageView *bgView = [[UIImageView alloc] initWithImage:image];
  bgView.frame = CGRectMake(0, 432, 320, 48);
  tabBar_.backgroundImage = image;
  UIImage *transparentImage = [self transparentImage];
  tabBar_.selectionIndicatorImage = transparentImage;
}

- (UIImage *)transparentImage {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), YES, 0.0);
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (void)viewDidUnload {
  [self setTabBar:nil];
  [super viewDidUnload];
}
@end
