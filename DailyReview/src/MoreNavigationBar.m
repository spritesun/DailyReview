#import "MoreNavigationBar.h"

@implementation MoreNavigationBar

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:@"bottom-bar-bg"];
	[image drawInRect:self.bounds];
}


@end
