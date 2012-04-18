#import "UITableView+Additions.h"

@implementation UITableView (Additions)

- (void)willRemoveSubview:(UIView *)subview {
  if ([subview isKindOfClass:[UITableViewCell class]]) {
    if ([self.delegate respondsToSelector:@selector(tableView:willRemoveCell:)]) {
      [(id<UITableViewAdditionDelegate>)self.delegate tableView:self willRemoveCell:(UITableViewCell *)subview];
    }
  }
  [super willRemoveSubview:subview];
}


@end
