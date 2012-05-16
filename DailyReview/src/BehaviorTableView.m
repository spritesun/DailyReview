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
    backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"behavior-table-bg.png"]];
    [self addSubview:backgroundView];
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)layoutSubviews {
  [self sendSubviewToBack:backgroundView];  
  //TODO: why not 30, for there is some px about shadow, please refactor this with BehaviorSectionHeaderView magic number 30.
  CGFloat sectionHeight = 28;
  CGFloat contentOffsetY = self.contentOffset.y;
  if (contentOffsetY < 0) {
    backgroundView.top = sectionHeight;
  } else if (contentOffsetY < self.bottomOffsetY) {
    backgroundView.top = contentOffsetY + sectionHeight;
  } else {
    backgroundView.top = self.bottomOffsetY + sectionHeight;
  }
  [super layoutSubviews];
}

@end