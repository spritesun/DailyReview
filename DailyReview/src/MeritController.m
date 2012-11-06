#import "MeritController.h"

@interface MeritController ()
@end

@implementation MeritController

#pragma mark - LifeCycles

- (void)viewDidLoad {
    self.resultsController = [BehaviorResultsController sharedMeritResultsController];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.resultsController = nil;
    [super viewDidUnload];
}

@end
