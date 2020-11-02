

#import <UIKit/UIKit.h>
@class JEButton;

typedef NS_ENUM(NSUInteger, JEScrIndexViewStyle) {
    /// 渐变
    JEScrIndexViewStyleScale,
    /// 遮盖
    JEScrIndexViewStyleCover,
};

static NSInteger const jkDefaultScrIndexTitleViewH = 44;
typedef UIViewController *(^LazyLoadBlock)(NSInteger index);

@interface JEScrIndexView : UIView

/// 懒加载view
- (instancetype)initWithFrame:(CGRect)frame lazyLoadView:(LazyLoadBlock)block;

/// 设置样式后 再设置标题
- (void)loadTitles:(NSArray <NSString *> *)titles;

/// 修改文字
- (void)changeTitleAt:(NSInteger)index title:(NSString*)title;

/// 滑到指定位置 0 1 2 3 4
- (__kindof UIView *)sliderToIndex:(NSInteger)index;

@property (nonatomic,copy) LazyLoadBlock lazyLoadBlock;

@property(nonatomic,assign) CGFloat titleViewHeight;///<  标题scrollview 的高 ### jkDefaultScrIndexTitleViewH
@property(nonatomic,strong) UIColor *normalTitleClr;///<  未选中时的字体颜色
@property(nonatomic,strong) UIFont *titleFont;///<  标题 字体
@property(nonatomic,assign) CGFloat marginPer;///< 文字框间距百分比 默认0
@property (nonatomic,assign) CGFloat btnWidth;///< 按钮宽 默认平分
@property (nonatomic,assign) CGFloat sliderBoardPer;///<  小滑块的百分比长

@property (nonatomic,assign) JEScrIndexViewStyle style;///<  style
@property (nonatomic,assign) CGFloat scale;///<  渐变大小百分比 ### 0.28

@property(nonatomic,strong,readonly) UIView *Ve_line;///<  滑块底部线条
@property(nonatomic,strong,readonly) UIView *Ve_boardLine;///<  滑块线条

@property (nonatomic,strong) NSMutableArray <JEButton *> *Arr_btns;///< 按钮
@property (nonatomic,strong) NSArray <NSNumber *> *advances;///< 预先加载VC eg. @[@(-1),@(1),@(2)] = 预先加载左边1个 右边1个第2个
@property(nonatomic,strong,readonly) UIScrollView *Scr_scroll_;///<  下面的容器
@property(nonatomic,strong,readonly) NSMutableArray <__kindof UIViewController *> *Arr_vc;///<  自定义vc
@property(nonatomic,strong,readonly) NSMutableArray <__kindof UIView *> *Arr_view;///<  自定义view

@property (nonatomic,copy) void (^indexChangeBlock)(NSInteger index);///< 

@end
