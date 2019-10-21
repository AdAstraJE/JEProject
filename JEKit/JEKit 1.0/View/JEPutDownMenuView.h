//
//  JEPutDownMenuView.h
//  
//
//  Created by JE on 15/10/22.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 下拉复选框 */
@interface JEPutDownMenuView : UIView

typedef void(^SelectBlock)(NSString *str,NSInteger index);
@property (nonatomic,copy) SelectBlock selectBlock;/**< 点击的回调 */

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)inview List:(NSArray <NSString *> *)list Click:(SelectBlock)block PositionUp:(BOOL)PosUP arrowX:(CGFloat)arrowX;

/** 默认计算frame */
+ (void)ShowIn:(UIView *)view Point:(CGPoint)point List:(NSArray <NSString *> *)list Click:(SelectBlock)block PositionUp:(BOOL)PosUP arrowX:(CGFloat)arrowX;
+ (void)ShowIn:(UIView *)view Point:(CGPoint)point List:(NSArray <NSString *> *)list Click:(SelectBlock)block PositionUp:(BOOL)PosUP;
+ (void)ShowIn:(UIView *)view Point:(CGPoint)point List:(NSArray <NSString *> *)list Click:(SelectBlock)block;


@end



/**< 直接出现消失 下面有半透明黑色背景的 */
@interface JEPutDownMenuViewType1 : JEPutDownMenuView

+ (void)ShowIn:(UIView*)view Point:(CGPoint)point List:(NSArray*)list Click:(SelectBlock)block curStr:(NSString*)curStr;

@end
