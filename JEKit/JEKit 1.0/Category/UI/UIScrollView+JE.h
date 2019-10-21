//
//  UIScrollView+JE.h
//   
//
//  Created by JE on 16/1/5.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JEListManager.h"

@interface UIScrollView (JE)

@property (nonatomic,strong) NSMutableArray *Arr;///< 默认基础数据源

@property(nonatomic,strong) UIActivityIndicatorView *ActView;///< tableview 默认ActView

/** storyboard 静态tableview 加载 */
- (void)staticLoading;

/** storyboard 静态tableview 停止加载 */
- (void)staticStopLoading;


/** 自带的数组count 为0时 显示的  图片-文本 信息  image = imageName | UIImage */
- (NSInteger)emptyeInfo:(NSString*)title image:(id)image;
- (NSInteger)emptyeInfo:(NSString*)title image:(id)image count:(NSInteger)count;

/** 网络请求失败时显示的   */
- (UIView*)networkingFailViewWithTarget:(id)target action:(SEL)action;



#pragma mark - 列表管理工具
@property (nonatomic,strong)  JEListManager *ListManager;///< 列表管理工具

/** 创建列表管理工具 */
- (void)listManager:(NSString*)API param:(NSDictionary*)param pages:(BOOL)havePage mod:(Class)modclass superVC:(UIViewController*)superVC caChe:(NSString*)caChe suc:(JEListNetSucBlcok)success fail:(JEListNetFailureBlock)fail method:(AFHttpMethod)method;

@end
