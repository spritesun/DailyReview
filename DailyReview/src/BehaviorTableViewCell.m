#import "BehaviorTableViewCell.h"
#import "UIColor+Additions.h"

@implementation BehaviorTableViewCell

+ (BehaviorTableViewCell *)cell; {
    return [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (void)drawCellKeyline {
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
    border.backgroundColor = [UIColor colorWithRed:.561 green:.698 blue:.349];
    [self addSubview:border];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor colorWithRed:.102 green:.169 blue:.2];
        self.detailTextLabel.textColor = [UIColor colorWithRed:.243 green:0 blue:0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:26];

        [self drawCellKeyline];
    }
    return self;
}

- (void)displayEventCount:(NSNumber *)count {
    if (count.intValue == 0) {
        self.detailTextLabel.text = @" ";
    } else {
        self.detailTextLabel.text = count.stringValue;
    }
}
@end
