#import "DRNavigationBar.h"

@implementation DRNavigationBar

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:@"bottom-bar-bg"];
	[image drawInRect:self.bounds];
}


@end
