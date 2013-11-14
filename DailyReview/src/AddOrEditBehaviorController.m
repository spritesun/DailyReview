#import "AddOrEditBehaviorController.h"
#import "Behavior.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSDate+Additions.h"
#import "MainViewController.h"
#import "NSString+Additions.h"
#import "UIView+Additions.h"

@interface AddOrEditBehaviorController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, retain) Behavior *editingBehavior;
@end

@implementation AddOrEditBehaviorController {
    UITextField *rankTextField_;
    NSArray *sortedArray_;
    NSDictionary *categoryDictionary_;
    UIPickerView *picker_;
    UITextField *nameTextField_;
}

+ (AddOrEditBehaviorController *)editBehaviorController:(Behavior *)behavior {
    AddOrEditBehaviorController *obj = [[self alloc] init];
    obj.editingBehavior = behavior;
    return obj;
}

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

    float const NAVIGATION_BAR_HEIGHT = 48;

    UIView *const view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UINavigationBar *const navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    [view addSubview:navigationBar];

    UINavigationItem *const navigationItem = [[UINavigationItem alloc] initWithTitle:title];
    navigationBar.items = Array(navigationItem);
  UIBarButtonItem *const addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(save)];
  UIBarButtonItem *const cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    navigationItem.leftBarButtonItem = cancelItem;
    navigationItem.rightBarButtonItem = addItem;

    UITableView *const tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, view.height - NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [view addSubview:tableView];

    //build name text filed
    nameTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    nameTextField_.delegate = self;
    nameTextField_.returnKeyType = UIReturnKeyNext;
    nameTextField_.text = nameText;
    nameTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;

    //build rank text filed
    rankTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    rankTextField_.text = [categoryDictionary_ objectForKey:rank];
    picker_ = [self getPickerViewSelectedName:rankTextField_.text inSource:categoryDictionary_];
    rankTextField_.inputView = picker_;

    self.view = view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UILabel *)labelWithName:(NSString *)name {
    UILabel *const nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 30)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
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
        [cell.contentView addSubview:nameTextField_];
    } else {
        [cell.contentView addSubview:[self labelWithName:@"功过点数"]];
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

- (void)save {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    NSString *behaviorName = nameTextField_.text;

    if ([behaviorName isBlank]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"项目名称不能为空" delegate:nil cancelButtonTitle:@"明了" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if (nil == self.editingBehavior || (![self.editingBehavior.name isEqualToString:nameTextField_.text])) {
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

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
