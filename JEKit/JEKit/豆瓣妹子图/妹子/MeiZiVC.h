//
//  MeiZiVC.h
//  
//
//  Created by JE on 2017/1/7.
//  Copyright © 2017年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JEBaseVC.h"


static const NSString *API_MeiZi = @"https://meizi.leanapp.cn/category";

#define MeiZi_Categorys         (@[@"All",@"DaXiong",@"QiaoTun",@"HeiSi",@"MeiTui",@"QingXin",@"ZaHui"])
#define MeiZi_CategorysNames    (@[@"全部",@"大熊"    ,@"瞧豚"   ,@"嘿斯"  ,@"煤腿"  ,@"清新"     ,@"杂烩"])

@interface MeiZiVC : JEBaseVC

@end
