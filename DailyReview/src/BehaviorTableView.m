#import "BehaviorTableView.h"
#import "UIView+Additions.h"
#import "UIScrollView+Additions.h"

@implementation BehaviorTableView {
    UIImageView *backgroundView;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"behavior-table-bg"]];
        backgroundView.contentMode = UIViewContentModeTop;
        backgroundView.frame = self.bounds;
        [self addSubview:backgroundView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [self sendSubviewToBack:backgroundView];
    CGFloat contentOffsetY = self.contentOffset.y;
    if (contentOffsetY < 0) {
        backgroundView.top = 0;
    } else if (contentOffsetY < self.bottomOffsetY) {
        backgroundView.top = contentOffsetY;
    } else {
        backgroundView.top = self.bottomOffsetY;
    }
    [super layoutSubviews];
}

@end