//
//  JEBaseTVC.h
//  
//
//  Created by JE on 15/7/28.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEBaseTVC   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JEBaseTVC : UITableViewController

/** 限制navBar的固定位置 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/** 加个点击取消响应 */
- (void)tapToEndEditing;

@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell1   🔷🔷🔷🔷🔷🔷🔷🔷
/** UITableViewCellStyleValue1 */
@interface JETableViewCell1 : UITableViewCell

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableView   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JETableView : UITableView

@property (nonatomic,assign) BOOL headExpandEffect;///< tableHeaderView 有bound Frame的imageView 拉动时扩张效果 默认NO

/** tableHeaderView里跟随滑动拉伸效果的UIImageView */
- (void)expandEffectView:(UIImageView *)imgv;

/** 跟随滑动拉伸效果传入 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELiteTV   简约型代理自己的tableView

@interface JELiteTV : JETableView <UITableViewDelegate,UITableViewDataSource>

+ (JELiteTV *)F:(CGRect)frame
          style:(UITableViewStyle)style
          cellC:(Class)cellClass
          cellH:(CGFloat)cellHeight
           cell:(void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idx,id obj))cell
         select:(void (^)(UITableView *tv,NSIndexPath *idx,id obj))select;

@property (nonatomic,copy) NSInteger (^sections)(UITableView *tv);///< numberOfSectionsInTableView
@property (nonatomic,copy) NSInteger (^rows)    (UITableView *tv,NSInteger section);///< numberOfRowsInSection
@property (nonatomic,copy) CGFloat   (^rowH)    (UITableView *tv,NSIndexPath *idx);///< heightForRowAtIndexPath
@property (nonatomic,copy) CGFloat   (^headH)   (UITableView *tv,NSInteger section);///< heightForHeaderInSection
@property (nonatomic,copy) CGFloat   (^footH)   (UITableView *tv,NSInteger section);///< heightForFooterInSection

@property (nonatomic,copy) UIView*   (^header)       (UITableView *tv,NSInteger section);///< viewForHeaderInSection
@property (nonatomic,copy) UIView*   (^footer)       (UITableView *tv,NSInteger section);///< viewForFooterInSection
@property (nonatomic,copy) NSString* (^headerTitle)  (UITableView *tv,NSInteger section);///< titleForHeaderInSection
@property (nonatomic,copy) NSString* (^footerTitle)  (UITableView *tv,NSInteger section);///< titleForFooterInSection

@property (nonatomic,copy) void   (^cell)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idx,id obj);///< 自定根据_cellClass自动生成后的cell
@property (nonatomic,copy) UITableViewCell*     (^cells)   (UITableView *tv,NSIndexPath *idx);///< cellForRowAtIndexPath
@property (nonatomic,copy) void   (^select)     (UITableView *tv,NSIndexPath *idx,id obj);///< didSelectRowAtIndexPath

@property (nonatomic,copy) UITableViewCellEditingStyle (^editingStyle)  (UITableView *tv,NSIndexPath *idx);///< editingStyle
@property (nonatomic,copy) void   (^commitEditingStyle)     (UITableView *tv,UITableViewCellEditingStyle editingStyle,NSIndexPath *idx,id obj);///< commitEditingStyle

@end
