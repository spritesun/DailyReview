#import "AddOrEditBehaviorController.h"
#import "Behavior.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSDate+Additions.h"
#import "MainViewController.h"
#import "NSString+Additions.h"
#import "UIView+Additions.h"

@interface AddOrEditBehaviorController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, retain) Behavior *editingBehavior;
@end

@implementation AddOrEditBehaviorController
{
  NSArray *sortedArray_;
  NSDictionary *categoryDictionary_;
  UIPickerView *picker_;
}

+ (AddOrEditBehaviorController *)editBehaviorController:(Behavior *)behavior {
  AddOrEditBehaviorController *obj = [[self alloc] init];
  obj.editingBehavior = behavior;
  return obj;
}

- (void)awakeFromNib
{
  categoryDictionary_ = [Behavior getAllCategoryDictionary];
  sortedArray_ = [[categoryDictionary_ allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *number1, NSNumber *number2) {
    return [number2 compare:number1];
  }];
}

- (void)startInputName
{
  [self.nameTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSNumber *rank;
  NSString *title;
  NSString *nameText = @"";
  if (self.editingBehavior) {
    title = @"修改项目";
    nameText = self.editingBehavior.name;
    rank = self.editingBehavior.rank;
  } else {
    title = @"添加新项目";
    rank = [NSNumber numberWithInt:((MainViewController *) self.presentingViewController).selectedIndex == 0 ? 1 : -1];
  }
  self.navigationItem.title = title;
    
  UIView *const view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
  self.nameTextField.text = nameText;
  
  //build rank text filed
  self.rankTextField.text = [categoryDictionary_ objectForKey:rank];
  picker_ = [self getPickerViewSelectedName:self.rankTextField.text inSource:categoryDictionary_];
  self.rankTextField.inputView = picker_;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self startInputName];
}

- (UIPickerView *)getPickerViewSelectedName:(NSString *)selectedName inSource:(NSDictionary *)dict {
  CGFloat const pickerHeight = 216;
  UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, pickerHeight)];
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
  [self.rankTextField becomeFirstResponder];
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
  self.rankTextField.text = [categoryDictionary_ objectForKey:[sortedArray_ objectAtIndex:[pickerView selectedRowInComponent:0]]];
}

- (IBAction)save:(id)sender
{
  NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
  NSString *behaviorName = self.nameTextField.text;
  
  if ([behaviorName isBlank]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"项目名称不能为空" delegate:nil cancelButtonTitle:@"明了" otherButtonTitles:nil];
    [alert show];
    return;
  }
 
  if (nil == self.editingBehavior || (![self.editingBehavior.name isEqualToString:self.nameTextField.text])) {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", behaviorName]];
    __block NSUInteger count;
    [context performBlockAndWait:^{
      count = [context countForFetchRequest:request error:nil];
    }];
    if (count > 0) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已存在同名项目，请修改名称" delegate:nil cancelButtonTitle:@"明了" otherButtonTitles:nil];
      [alert show];
      return;
    }
  }
  
  Behavior *behavior = nil;
  if (self.editingBehavior) {
    behavior = self.editingBehavior;
  }
  else {
    behavior = [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:context];
    behavior.isCustomised = [NSNumber numberWithBool:YES];
    [behavior increaseEventForDate:[[NSDate date] dateWithoutTime]];
  }
  
  behavior.name = behaviorName;
  behavior.rank = [sortedArray_ objectAtIndex:(NSUInteger) [picker_ selectedRowInComponent:0]];
  behavior.timestamp = [NSDate date];
  [context save];
  
  MainViewController *controller = (MainViewController *) self.presentingViewController;
  [self dismissViewControllerAnimated:YES completion:^{
    [controller behaviorDidSave:behavior];
  }];
}

- (IBAction)cancel:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
