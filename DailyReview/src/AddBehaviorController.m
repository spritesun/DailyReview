#import "AddBehaviorController.h"
#import "Behavior.h"

@interface AddBehaviorController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation AddBehaviorController

- (id)init {
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)loadView {
  float const NAVIGATION_BAR_HEIGHT = 48;

  UIView *const view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

  UINavigationBar *const navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
  [view addSubview:navigationBar];

  UINavigationItem *const navigationItem = [[UINavigationItem alloc] initWithTitle:@"自定义功德"];
  navigationBar.items = Array(navigationItem);
  UIBarButtonItem *const addItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonSystemItemAdd target:self action:@selector(addBehavior)];
  UIBarButtonItem *const cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
  navigationItem.leftBarButtonItem = cancelItem;
  navigationItem.rightBarButtonItem = addItem;

  UITableView *const tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];


  [tableView setDataSource:self];
  [tableView setDelegate:self];
  [view addSubview:tableView];

  self.view = view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
  }

  if (indexPath.row == 0) {
    UILabel *const nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 70, 30)];
    nameLable.textAlignment = UITextAlignmentCenter;
    nameLable.text = @"名称";
    nameLable.backgroundColor = [UIColor clearColor];
    UITextField *const nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 200, 30)];
    nameTextField.adjustsFontSizeToFitWidth = YES;
    nameTextField.borderStyle = UITextBorderStyleLine;
    [cell.contentView addSubview:nameLable];
    [cell.contentView addSubview:nameTextField];
  } else {
    UILabel *const nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 70, 30)];
    nameLable.textAlignment = UITextAlignmentCenter;
    nameLable.text = @"功过点数";
    nameLable.backgroundColor = [UIColor clearColor];
    UITextField *const rankTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 200, 30)];
    rankTextField.adjustsFontSizeToFitWidth = YES;
    rankTextField.borderStyle = UITextBorderStyleLine;
    rankTextField.placeholder = @"请选择";
    rankTextField.delegate = self;
    [cell.contentView addSubview:nameLable];
    [cell.contentView addSubview:rankTextField];

  }
  return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  UIPickerView *const picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 270)];
  picker.delegate = self;
  picker.dataSource = self;
  [self.view addSubview:picker];
  return NO;
}

#pragma mask - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [Behavior getAllCategoryDictionary].count;
}

#pragma mask - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSDictionary *const categoryDictionary = [Behavior getAllCategoryDictionary];
  NSArray *const sortedArray = [[categoryDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *number1, NSNumber *number2) {
    return [number2 compare:number1];
  }];
  return [categoryDictionary objectForKey:[sortedArray objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 40;
}


- (void)addBehavior {
  //TODO: add behavior to db, reload table, scroll to recentely added cell
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
