#import "MoreNavigationBar.h"

@implementation MoreNavigationBar

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:@"bottom-bar-bg"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
