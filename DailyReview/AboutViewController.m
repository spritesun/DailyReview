#import "AboutViewController.h"

@implementation AboutViewController

#pragma mark - View lifecycle

- (void)viewDidLoad;
{
  [super viewDidLoad];
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  UIImage *backButtonBgImage = [UIImage imageNamed:@"back-button"];
  [backButton setBackgroundImage:backButtonBgImage forState:UIControlStateNormal];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, backButtonBgImage.size.width, backButtonBgImage.size.height)];
  label.text = @"返回";
  label.font = [UIFont systemFontOfSize:11];
  label.textColor = [[UIColor alloc] initWithRed:.82 green:.714 blue:.2 alpha:1];
  label.backgroundColor = [UIColor clearColor];
  [backButton addSubview:label];
  backButton.frame = CGRectMake(0, 0, backButtonBgImage.size.width, backButtonBgImage.size.height);
  [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

  self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)back {
 [[self navigationController] popViewControllerAnimated:YES];
}

@end
