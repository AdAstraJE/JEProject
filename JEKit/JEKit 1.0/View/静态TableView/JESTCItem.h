//
//  JESTCItem.h
//  JEKit
//
//  Created by JE on 2018/6/14.
//  Copyright © 2018年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JESTCItem;
@class JEStaticTVCell;

typedef void(^JESTCSelectBlock)(JESTCItem *item);///< didSelectRow
typedef void(^JESTCSwitchBlock)(JESTCItem *item,BOOL on);///< cell switch valueChange

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @protocol JEStaticTVCellDelegate   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
@protocol JEStaticTVCellDelegate

/** 静态cell加载 */
- (void)loadCell:(JESTCItem *)item;

@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface JESTCUIStyle   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

@interface JESTCUIStyle : NSObject

/** 默认样式 */
+ (JESTCUIStyle *)DefaultStyle;

@property (nonatomic,strong) UIColor *backgroundColor;///<   ### nil
@property (nonatomic,assign) CGFloat sectionHeaderHeight;///< ### 12
@property (nonatomic,assign) CGFloat sectionFooterHeight;///< ### 1
@property (nonatomic,assign) CGFloat defaultCellHeight;///< ### 48
@property (nonatomic,assign) CGFloat margin;///< 左右边距 ### 15
@property (nonatomic,assign) CGFloat iconWH;///< 图标长宽 ### 22
@property (nonatomic,assign) CGFloat iconTitleMargin;///< 图标 title 边距 ### 10
@property (nonatomic,strong) UIFont  *titleFont;///<   ### font(14)
@property (nonatomic,strong) UIColor *titleColor;///<   ### kColorText
@property (nonatomic,strong) UIFont  *descFont;///<   ### font(14)
@property (nonatomic,strong) UIColor *descColor;///<   ### kColorText66
@property (nonatomic,strong) UIColor *swiColor;///<   ### nil
@property (nonatomic,strong) UIColor *cellColor;///<   ### nil

@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface JESTCItem   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
@interface JESTCItem : NSObject

/** 各种默认构建方法 */
+ (JESTCItem *)Title:(NSString *)title select:(JESTCSelectBlock)select;
+ (JESTCItem *)Title:(NSString *)title indicator:(BOOL)indicator select:(JESTCSelectBlock)select;
+ (JESTCItem *)Title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator select:(JESTCSelectBlock)select;
+ (JESTCItem *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator select:(JESTCSelectBlock)select;
+ (JESTCItem *)CustomCell:(Class <JEStaticTVCellDelegate>)customCell height:(CGFloat)height select:(JESTCSelectBlock)select;
+ (JESTCItem *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator Switch:(JESTCSwitchBlock)Switch on:(BOOL)switchOn select:(JESTCSelectBlock)select;
+ (JESTCItem *)CustomView:(UIView *)view height:(CGFloat)height select:(JESTCSelectBlock)select;
+ (JESTCItem *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator customCell:(Class)customCell Switch:(JESTCSwitchBlock)Switch on:(BOOL)switchOn height:(CGFloat)height select:(JESTCSelectBlock)select;


/** 显示在中间的文本 */
+ (JESTCItem *)MiddleNoti:(NSString *)noti font:(UIFont *)font color:(UIColor *)color select:(JESTCSelectBlock)select;


@property (nonatomic,strong) UIImage *icon;///< icon 图标
@property (nonatomic,strong) NSString *title;///< title 左边文本
@property (nonatomic,strong) NSString *detail;///< title下面的 detail
@property (nonatomic,strong) NSString *desc;///< desc 右边文本
@property (nonatomic,assign) BOOL showIndicator;///< UITableViewCellAccessoryDisclosureIndicator
@property (nonatomic,assign) UITableViewCellAccessoryType accessory;///< 

@property (nonatomic,strong) UIView *middleView;///< 居中显示的view

@property (nonatomic,assign) NSInteger cellHeight;///< ### 
@property (nonatomic,assign) CGFloat cellAlpha;///< cell的alpha ### 1
@property (nonatomic,strong) __kindof JEStaticTVCell <JEStaticTVCellDelegate> *cell;///< cell
@property (nonatomic,copy) JESTCSelectBlock selectBlock;///< 点击cell的回调

@property (nonatomic,assign) BOOL switchOn;///< switch状态
@property (nonatomic,copy) JESTCSwitchBlock switchBlock;///< switch valueChange 的回调



@end
