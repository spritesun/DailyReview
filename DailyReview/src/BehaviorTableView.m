#import "BehaviorTableView.h"

@implementation BehaviorTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return self;
}

@end