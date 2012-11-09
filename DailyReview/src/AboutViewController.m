#import "AboutViewController.h"
#import "DRBackButton.h"

@implementation AboutViewController

#pragma mark - View lifecycle

- (void)viewDidLoad; {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[DRBackButton button]];
}


@end
