
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JEBtnStyle) {
    JEBtnStyleLeft = 1,///< 图片在左
    JEBtnStyleRight = 2,///< 图片在右
    JEBtnStyleTop = 3,///< 图片在上
    JEBtnStyleBottom = 4///< 图片在下
};


//IB_DESIGNABLE
@interface JEButton : UIButton

UIKIT_EXTERN  JEButton * JEBtn(CGRect rect,NSString *title,id fnt,UIColor *clr,id target,SEL action,id img,CGFloat rad,__kindof UIView *addTo);

UIKIT_EXTERN  JEButton * JEBtnSys(CGRect rect,NSString *title,id fnt,UIColor *clr,id target,SEL action,id img,CGFloat rad,__kindof UIView *addTo);

/// xib用 国际化 
@property (nonatomic,copy) IBInspectable NSString *loc;

@property (nonatomic,assign) NSInteger tag2;///< tag .
@property (nonatomic,assign)  IBInspectable CGRect moreTouchMargin;///< xib用 扩大点击范围 按照UIEdgeInsets .left, .top, .right, .bottom用
- (JEButton *(^)(CGFloat top,CGFloat left,CGFloat bottom,CGFloat right))touchs;///< 更多点击范围

/// 按钮图片相对位置
- (JEButton *(^)(JEBtnStyle style,CGFloat imgGap))style;
@property (nonatomic,assign) JEBtnStyle edgeInsetsStyle;///< 图片位置Style
@property (nonatomic,assign) CGFloat imageTitleSpace;///< 图片与文本的间距

@property (nonatomic,strong) UIActivityIndicatorView *Act_;///< UIActivityIndicatorView
@property (nonatomic,assign) BOOL enableInLoading ;///< loading 时可点击,default NO

/// 覆盖式的 进度中。
- (void)coverLoading;

/// 进度中。。
- (void)loading;

///  停止进度
- (void)stopLoading;

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEFrameBtn 完全设定图片文字位置  🔷🔷🔷🔷🔷🔷🔷🔷

@interface JEFrameBtn : JEButton

@property (nonatomic,assign)  CGRect imgf;///< 图片在按钮中的位置  UIViewContentModeScaleAspectFit
@property (nonatomic,assign)  CGRect titf;///< 文本在按钮中的位置

/// 专门的图片位置 & 文本位置 整体
- (instancetype)initWithFrame:(CGRect)frame imgF:(CGRect)imgf titF:(CGRect)titf  title:(NSString*)title font:(id)font color:(UIColor*)titleColor rad:(CGFloat)rad tar:(id)target sel:(SEL)action img:(id)img system:(BOOL)system;

/// 从设置文本和图片距离文本的水平位置 UIControlStateNormal
- (void)resetTitle:(NSString*)title imgMargin:(CGFloat)margin;

@end

