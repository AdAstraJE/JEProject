//
//  JEStaticTVCell.h
//  JEKit
//
//  Created by JE on 2018/6/14.
//  Copyright © 2018年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JESTCItem.h"

@interface JEStaticTVCell : UITableViewCell <JEStaticTVCellDelegate>

@property (nonatomic,strong) UIImageView *Img_icon;///< 默认图标
@property (nonatomic,strong) UILabel *La_title;///< 标题
@property (nonatomic,strong) UILabel *La_detail;///< 标题下面的描述
@property (nonatomic,strong) UILabel *La_desc;///< 右边的描述
@property (nonatomic,strong) UISwitch *Swi;///< 开关

@end
