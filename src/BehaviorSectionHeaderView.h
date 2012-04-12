@interface BehaviorSectionHeaderView : UIView

@property (nonatomic, assign) BOOL expanded;

+ (BehaviorSectionHeaderView *)viewWithTitle:(NSString *)title section:(NSInteger)section;

@end
