//
//  JEStarRateView.h
//  
//
//  Created by JE on 15/9/14.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JEStarRateView : UIView

typedef void(^StarBlock)(NSInteger star);
@property (nonatomic,copy) StarBlock starBlock;

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;

/** 星星评分 */
+ (instancetype)Point:(CGPoint)point addTo:(UIView*)addview numberOfStar:(int)number Block:(StarBlock)block;
@property (nonatomic,assign) CGFloat currentStar;
@property (nonatomic,assign) BOOL suffixTitle;

/**< 设置当前星星等级 */
- (void)ChangeCurrentStar:(CGFloat)star block:(BOOL)block;




@end
