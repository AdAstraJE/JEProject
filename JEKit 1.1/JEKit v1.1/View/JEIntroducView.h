
#import <UIKit/UIKit.h>

/// 引导页 =
@interface JEIntroducView : UIView 

///  默认效果，有UIPageControl (tint = PageControl & 按钮颜色)
+ (instancetype)Introduc:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor;

/// 滑动显示文体、图片渐变效果 @[@[@"title1",@"title2",@"title3"],@[@"detail1",@"detail2",@"detail"]]
+ (instancetype)Introduc:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor titleDesc:(NSArray <NSArray <NSString *> *> *)titleDesc descColor:(UIColor *)descColor done:(void (^)(void))done;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor titleDesc:(NSArray <NSArray <NSString *> *> *)titleDesc descColor:(UIColor *)descColor done:(void (^)(void))done;

/// 重设描述图片frame
- (void)resetDescImgFrame:(CGRect)frame;

- (void)introducDismiss;

@property (nonatomic,strong) UIColor *titleColor;///< ..
@property (nonatomic,strong) UIButton *Btn_finish;///< 进入应用
@property (nonatomic,strong) UIPageControl *Page;

@end
