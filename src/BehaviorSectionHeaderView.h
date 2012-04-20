@interface BehaviorSectionHeaderView : UIView

@property(nonatomic, assign) BOOL expanded;
@property(nonatomic, retain, readwrite) NSNumber* todayScore;

+ (BehaviorSectionHeaderView *)viewWithTitle:(NSString *)title andScoreName:(NSString *)name;

- (void)clearScore;

@end
