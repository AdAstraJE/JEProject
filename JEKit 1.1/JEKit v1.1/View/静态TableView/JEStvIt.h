
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JEStvIt;
@class JEStaticTVCell;

typedef void(^JEStvSelectBlock)(JEStvIt *item);///< didSelectRow
typedef void(^JEStvSwitchBlock)(JEStvIt *item,BOOL on);///< cell switch valueChange

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEStvUIStyle   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEStvUIStyle : NSObject

/** 默认样式 */
+ (JEStvUIStyle *)DefaultStyle;

@property (nonatomic,strong) UIColor *backgroundColor;///<   ### JEShare.VCBgClr
@property (nonatomic,assign) CGFloat sectionHeaderHeight;///< ### 12
@property (nonatomic,assign) CGFloat sectionFooterHeight;///< ### 1
@property (nonatomic,assign) CGFloat defaultCellHeight;///< ### 48
@property (nonatomic,assign) CGFloat margin;///< 左右边距 ### 15
@property (nonatomic,assign) CGFloat iconWH;///< 图标长宽 ### 22
@property (nonatomic,assign) CGFloat iconTitleMargin;///< 图标 title 边距 ### 10
@property (nonatomic,strong) UIFont  *titleFont;///<   ### font(14)
@property (nonatomic,strong) UIColor *titleColor;///<   ### Clr_txt
@property (nonatomic,strong) UIFont  *descFont;///<   ### font(14)
@property (nonatomic,strong) UIColor *descColor;///<   ### Clr_txt77
@property (nonatomic,strong) UIFont  *detailFont;///<   ### font(11)
@property (nonatomic,strong) UIColor *detailColor;///<   ### Clr_txt77
@property (nonatomic,strong) UIColor *swiColor;///<   ### nil
@property (nonatomic,strong) UIColor *cellColor;///<   ### nil

@end



UIKIT_EXTERN  JEStvIt *JEStvIt_(id icon, NSString *title, NSString *desc, UITableViewCellAccessoryType indicator, JEStvSelectBlock block);

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface JEStvIt   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEStvIt : NSObject

@property (nonatomic,strong) UIImage *icon;///< icon 图标
@property (nonatomic,strong) NSString *title;///< title 左边文本
@property (nonatomic,strong) NSString *detail;///< title下面的 detail
@property (nonatomic,strong) NSString *desc;///< desc 右边文本
@property (nonatomic,assign) UITableViewCellAccessoryType accessory;///< 

@property (nonatomic,strong) UIView *middleView;///< 居中显示的view

@property (nonatomic,assign) NSInteger cellHeight;///< ### 
@property (nonatomic,assign) CGFloat cellAlpha;///< cell的alpha ### 1
@property (nonatomic,strong) __kindof JEStaticTVCell *cell;///< cell
@property (nonatomic,copy) JEStvSelectBlock selectBlock;///< 点击cell的回调

@property (nonatomic,assign) BOOL switchOn;///< switch状态
@property (nonatomic,copy) JEStvSwitchBlock switchBlock;///< switch valueChange 的回调


/// 各种默认构建方法
+ (JEStvIt *)Title:(NSString *)title select:(JEStvSelectBlock)select;
+ (JEStvIt *)Title:(NSString *)title acc:(UITableViewCellAccessoryType)acc select:(JEStvSelectBlock)select;
+ (JEStvIt *)Title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc select:(JEStvSelectBlock)select;
+ (JEStvIt *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc select:(JEStvSelectBlock)select;
+ (JEStvIt *)CustomCell:(Class)customCell height:(CGFloat)height select:(JEStvSelectBlock)select;
+ (JEStvIt *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc Switch:(JEStvSwitchBlock)Switch on:(BOOL)switchOn select:(JEStvSelectBlock)select;
+ (JEStvIt *)CustomView:(UIView *)view height:(CGFloat)height select:(JEStvSelectBlock)select;
+ (JEStvIt *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc customCell:(Class)customCell Switch:(JEStvSwitchBlock)Switch on:(BOOL)switchOn height:(CGFloat)height select:(JEStvSelectBlock)select;

/// 显示在中间的文本
+ (JEStvIt *)MiddleNoti:(NSString *)noti font:(UIFont *)font color:(UIColor *)color select:(JEStvSelectBlock)select;

@end
