
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell1   🔷🔷🔷🔷🔷🔷🔷🔷
/// 左边textLabel，右边detailTextLabel， UITableViewCellAccessoryDisclosureIndicator
@interface JETableViewCell1 : UITableViewCell

@end
#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell3   🔷🔷🔷🔷🔷🔷🔷🔷
/// 左边textLabel，下边detailTextLabel， UITableViewCellAccessoryDisclosureIndicator
@interface JETableViewCell3 : UITableViewCell

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableView   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JETableView : UITableView

@property (nonatomic,assign) BOOL headExpandEffect;///< tableHeaderView 有bound Frame的imageView 拉动时扩张效果 默认NO

/// tableHeaderView里跟随滑动拉伸效果的UIImageView
- (void)expandEffectView:(UIImageView *)imgv;

/// 跟随滑动拉伸效果传入 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/// dark
- (void)handelStyleDark;

@end

NS_ASSUME_NONNULL_END
