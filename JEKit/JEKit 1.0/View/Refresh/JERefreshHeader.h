//
//  JERefreshHeader.h
//   
//
//  Created by JE on 16/4/14.
//  Copyright © 2016年 JE. All rights reserved.
//

#import "MJRefreshHeader.h"
//#import "MJRefreshNormalHeader.h"

@interface JERefreshHeader : MJRefreshHeader
//@interface JERefreshHeader : MJRefreshNormalHeader

@property (assign, nonatomic) BOOL JENetworkingFail;/**< 网络请求失败过 */

@property (strong, nonatomic) UIColor *color;///< arrow color

@end
