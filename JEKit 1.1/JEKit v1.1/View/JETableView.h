
#import <UIKit/UIKit.h>
#import "JETableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JETableView : UITableView

@property (nonatomic,assign) BOOL headExpandEffect;///< tableHeaderView 有bound Frame的imageView 拉动时扩张效果 默认NO

/// tableHeaderView里跟随滑动拉伸效果的UIImageView
- (void)expandEffectView:(UIImageView *)imgv;

/// 跟随滑动拉伸效果传入 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/// scrollViewDidScroll回调
@property (nonatomic,copy) void (^didScrollBlock)(JETableView *tbv);

/// scrollViewWillBeginDragging回调
@property (nonatomic,copy) void (^willBeginDraggingBlock)(JETableView *tbv);

@end

NS_ASSUME_NONNULL_END
