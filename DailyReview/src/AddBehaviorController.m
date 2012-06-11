#import "AddBehaviorController.h"
#import "Behavior.h"
#import "NSManagedObjectContext+Additions.h"

#define DEFAULT_RANK 1

@interface AddBehaviorController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation AddBehaviorController {
  UITextField *rankTextField_;
  NSArray *sortedArray_;
  NSDictionary *categoryDictionary_;
  UIPickerView *picker_;
  UITextField *nameTextField_;
}
@synthesize delegate = delegate_;


- (id)init {
  self = [self initWithStyle:UITableViewStyleGrouped];
  if (self) {
    categoryDictionary_ = [Behavior getAllCategoryDictionary];
    sortedArray_ = [[categoryDictionary_ allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *number1, NSNumber *number2) {
      return [number2 compare:number1];
    }];
  }
  return self;
}

- (void)startInputName {
  [nameTextField_ becomeFirstResponder];
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

  tableView.dataSource = self;
  tableView.delegate = self;
  [view addSubview:tableView];

  self.view = view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UILabel *)labelWithName:(NSString *)name {
  UILabel *const nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 30)];
  nameLabel.textAlignment = UITextAlignmentCenter;
  nameLabel.text = name;
  nameLabel.backgroundColor = [UIColor clearColor];
  return nameLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }

  if (indexPath.row == 0) {
    [cell.contentView addSubview:[self labelWithName:@"名称"]];

    nameTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    nameTextField_.delegate = self;
    nameTextField_.returnKeyType = UIReturnKeyNext;
    [cell.contentView addSubview:nameTextField_];
  } else {
    [cell.contentView addSubview:[self labelWithName:@"功过点数"]];

    rankTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 200, 30)];
    rankTextField_.text = [categoryDictionary_ objectForKey:[NSNumber numberWithInt:DEFAULT_RANK]];

    picker_ = [self getPickerViewSelectedName:rankTextField_.text inSource:categoryDictionary_];
    rankTextField_.inputView = picker_;

    [cell.contentView addSubview:rankTextField_];

  }
  return cell;
}

- (UIPickerView *)getPickerViewSelectedName:(NSString *)selectedName inSource:(NSDictionary *)dict {
  CGFloat const pickerHeight = 216;
  UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, pickerHeight)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 40;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [rankTextField_ becomeFirstResponder];
  return YES;
}

//TODO: refactor to be a separate controller for pickerview
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
  //TODO: add behavior to db, reload table, scroll to recently added cell, prevent duplication, other validation
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
  Behavior *behavior = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
  behavior.name = nameTextField_.text;

  const NSUInteger integer = (NSUInteger) [picker_ selectedRowInComponent:0];
  behavior.rank = [sortedArray_ objectAtIndex:integer];
  [behavior setTimestamp:[NSDate date]];

  NSError *error = nil;
  if (![context save:&error]) {
    NSLog(@"Error: %@", [error localizedDescription]);
    error = nil;
  }

  [delegate_ onSave:behavior];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
