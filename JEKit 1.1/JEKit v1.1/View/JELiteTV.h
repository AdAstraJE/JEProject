
#import <UIKit/UIKit.h>
#import "JETableView.h"


NS_ASSUME_NONNULL_BEGIN

/// 简约型代理自己的tableView
@interface JELiteTV : JETableView <UITableViewDelegate,UITableViewDataSource>

+ (JELiteTV *)Frame:(CGRect)frame
          style:(UITableViewStyle)style
          cellC:(nullable Class)cellClass
          cellH:(CGFloat)cellHeight
           cell:(nullable void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idxP,id obj))cell
         select:(nullable void (^)(UITableView *tv,NSIndexPath *idxP,id obj))select
             to:(UIView * _Nullable)to;

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
@property (nonatomic,copy) void   (^accessoryButtonTap)     (UITableView *tv,NSIndexPath *idx,id obj);///< accessoryButtonTap

@end

NS_ASSUME_NONNULL_END
