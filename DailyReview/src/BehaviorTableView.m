#import "BehaviorTableView.h"

@implementation BehaviorTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"behavior-table-bg.png"]];
  }
  return self;
}

@end