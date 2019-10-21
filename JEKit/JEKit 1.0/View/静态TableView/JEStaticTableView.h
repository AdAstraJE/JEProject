//
//  JEStaticTableView.h
//  JEKit
//
//  Created by JE on 2018/6/14.
//  Copyright © 2018年 JE. All rights reserved.
//

#import "JEBaseTVC.h"
#import "JEStaticTVCell.h"

@interface JEStaticTableView : JETableView

//@property (nonatomic,assign) CGFloat headerHeight;///< ### 12
//@property (nonatomic,assign) CGFloat footerHeight;///< ### 1

@property (nonatomic,strong) NSArray <NSArray <JESTCItem *> *> *Arr_item;///< 静态item 静态cell不复用

@property (nonatomic,strong) NSArray <NSString *> *Arr_headerTitle;///< ### nil
@property (nonatomic,strong) NSArray <NSString *> *Arr_footerTitle;///< ### nil

@end
