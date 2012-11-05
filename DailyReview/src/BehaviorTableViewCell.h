#import "Behavior.h"

@interface BehaviorTableViewCell : UITableViewCell

+ (BehaviorTableViewCell *)cell;

- (void)displayEventCount:(NSNumber *)count;
@end
