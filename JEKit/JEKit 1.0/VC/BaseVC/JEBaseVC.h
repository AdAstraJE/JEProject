//
//  JEBaseVC.h
//  
//
//  Created by JE on 15/6/14.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JETableView;
@class JEStaticTableView;
@class JELiteTV;


@interface JEBaseVC : UIViewController

@property (nonatomic,strong) JETableView *tableView;///< 默认的tableView
@property (nonatomic,strong) JEStaticTableView *staticTv;///< 静态 tableView （离开栈时 block会置空）
@property (nonatomic,strong) JELiteTV *liteTv;///< 默认的tableView
@property (nonatomic,assign,readonly) CGRect tvFrame;///< tableView默认Frame

/** 默认Frame的tableView创建方法 */
- (JETableView *)defaultTableView:(UITableViewStyle)style cell:(id)cellClass;

/** 去掉静态item的block引用 */
- (void)removeStaticTvBlock;

@end
