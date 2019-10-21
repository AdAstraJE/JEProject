//
//  UITableViewCell+JE.h
//  
//
//  Created by JE on 2016/11/11.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (JE)

/** cell 对应的 indexpath */
@property(nonatomic,strong,readonly) NSIndexPath *indexPath;

/** 方便构建方法 传入模型？  返回自己 */
- (instancetype)je_loadCell:(id)mod;

@end


