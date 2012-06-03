#import "AddBehaviorController.h"
#import "Behavior.h"

#define DEFAULT_RANK 1

@interface AddBehaviorController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation AddBehaviorController {
  UITextField *rankTextField_;
  NSArray *sortedArray_;
  NSDictionary *categoryDictionary_;
  UIPickerView *picker_;
}

- (id)init
{
  self = [self initWithStyle:UITableViewStyleGrouped];
  if (self) {
    categoryDictionary_ = [Behavior getAllCategoryDictionary];
    sortedArray_ = [[categoryDictionary_ allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *number1, NSNumber *number2) {
      return [number2 compare:number1];
    }];
  }
  return self;
}

- (UITextField *)createTextField {
  UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 200, 30)];
  textField.borderStyle = UITextBorderStyleLine;
  return textField;
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

- (UILabel *)labelWithName:(NSString *)name {
  UILabel *const nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 70, 30)];
  nameLable.textAlignment = UITextAlignmentCenter;
  nameLable.text = name;
  nameLable.backgroundColor = [UIColor clearColor];
  return nameLable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
  }

  if (indexPath.row == 0) {
    [cell.contentView addSubview:[self labelWithName:@"名称"]];
    [cell.contentView addSubview:[self createTextField]];
  } else {
    [cell.contentView addSubview:[self labelWithName:@"功过点数"]];

    rankTextField_ = [self createTextField];

    rankTextField_.text = [categoryDictionary_ objectForKey:[NSNumber numberWithInt:DEFAULT_RANK]];
    rankTextField_.inputView = rankTextField_;
    picker_ = [self getPickerViewSelectedName:rankTextField_.text inSource:categoryDictionary_];

    rankTextField_.inputView = picker_;

    [cell.contentView addSubview:rankTextField_];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 40;
}

#pragma mark - UITextFieldDelegate

- (UIPickerView *)getPickerViewSelectedName:(NSString *)selectedName inSource:(NSDictionary *)dict {
  UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
  picker.delegate = self;
  picker.dataSource = self;
  picker.showsSelectionIndicator = YES;
  [picker selectRow:[self getRowOfCategory:selectedName fromDict:dict] inComponent:0 animated:NO];
  return picker;
}

- (int)getRowOfCategory:(NSString *)categoryName fromDict:(NSDictionary *)dict {
  for (int i = 0; i < sortedArray_.count; i++) {
    if ([[dict objectForKey:[sortedArray_ objectAtIndex:i]] isEqual:categoryName]) {
      return i;
    }
  }
  return 0;
}


#pragma mask - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [Behavior getAllCategoryDictionary].count;
}

#pragma mask - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [categoryDictionary_ objectForKey:[sortedArray_ objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  rankTextField_.text = [categoryDictionary_ objectForKey:[sortedArray_ objectAtIndex:[pickerView selectedRowInComponent:0]]];
}


- (void)addBehavior {
  //TODO: add behavior to db, reload table, scroll to recentely added cell
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
