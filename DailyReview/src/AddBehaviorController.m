#import "AddBehaviorController.h"

@interface AddBehaviorController ()

@end

@implementation AddBehaviorController

- (id)init {
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)loadView {  
  UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
  
  UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];  
  [view addSubview:navigationBar];

  UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"自定义功德"];
  navigationBar.items = Array(navigationItem);
  UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonSystemItemAdd target:self action:@selector(addBehavior)];
  UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
  navigationItem.leftBarButtonItem = cancelItem;
  navigationItem.rightBarButtonItem = addItem;
  
  self.view = view;
}

- (void)addBehavior {
  //TODO: add behavior to db, reload table, scroll to recentely added cell
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
