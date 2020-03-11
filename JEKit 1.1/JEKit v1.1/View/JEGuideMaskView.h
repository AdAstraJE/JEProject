
#import <UIKit/UIKit.h>

@class JEGuideMaskView;

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEGuideMaskViewDataSource   🔷🔷🔷🔷🔷🔷🔷🔷

@protocol JEGuideMaskViewDataSource <NSObject>

@required

/// item 的个数
- (NSInteger)numberOfItemsInGuideMaskView:(JEGuideMaskView *)guideMaskView;

/// 每个 item 的 view
- (UIView *)guideMaskView:(JEGuideMaskView *)guideMaskView viewForItemAtIndex:(NSInteger)index;

/// 每个 item 的文字
- (NSString *)guideMaskView:(JEGuideMaskView *)guideMaskView descriptionForItemAtIndex:(NSInteger)index;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEGuideMaskViewLayout   🔷🔷🔷🔷🔷🔷🔷🔷

@protocol JEGuideMaskViewLayout <NSObject>

@optional
/// 每个 item 的 view 蒙板的圆角：默认为 5
- (CGFloat)guideMaskView:(JEGuideMaskView *)guideMaskView cornerRadiusForViewAtIndex:(NSInteger)index;

/// 每个 item 的 view 与蒙板的边距：默认 (-8, -8, -8, -8)
- (UIEdgeInsets)guideMaskView:(JEGuideMaskView *)guideMaskView insetForViewAtIndex:(NSInteger)index;

/// 每个 item 的子视图（当前介绍的子视图、箭头、描述文字）之间的间距：默认为 20
- (CGFloat)guideMaskView:(JEGuideMaskView *)guideMaskView spaceForItemAtIndex:(NSInteger)index;

///  每个 item 的文字与左右边框间的距离：默认为 30（注意：如果文字的宽度小于当前可视区域的宽度，则会相对于箭头图片居中对齐）
- (CGFloat)guideMaskView:(JEGuideMaskView *)guideMaskView horizontalInsetForDescriptionAtIndex:(NSInteger)index;

/// 每个 item 的文字颜色：默认白色
- (UIColor *)guideMaskView:(JEGuideMaskView *)guideMaskView colorForDescriptionAtIndex:(NSInteger)index;

/// 每个 item 的文字字体：默认 [UIFont systemFontOfSize:16]
- (UIFont *)guideMaskView:(JEGuideMaskView *)guideMaskView fontForDescriptionAtIndex:(NSInteger)index;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEGuideMaskView   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JEGuideMaskView : UIView

/// 根据view desc 实现
+ (instancetype)ShowWithView:(NSArray <__kindof UIView *> *)views desc:(NSArray <NSString *> *)desc;

/// 根据代理实现 
+ (instancetype)ShowWithDatasource:(id<JEGuideMaskViewDataSource>)dataSource layout:(id<JEGuideMaskViewLayout>)layout;

@property (weak, nonatomic) id<JEGuideMaskViewDataSource> dataSource;
@property (weak, nonatomic) id<JEGuideMaskViewLayout>layout;

@property (strong, nonatomic) UIImageView *arrowImgView;///< 箭头图片
@property (strong, nonatomic) UIView *maskView;///< 蒙板   颜色：[黑色]  透明度：[.7f]

@property (copy, nonatomic) void(^dismissHandle)(void);///< 消失完成的回调

@end
