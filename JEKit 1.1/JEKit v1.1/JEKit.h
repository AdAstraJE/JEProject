//
//  JEKit.h
//
//
//  Created by JE on 2016/10/19.
//  Copyright © 2016年 JE. All rights reserved.
//


/*
 source 'https://github.com/CocoaPods/Specs.git'
 platform :ios, "10.0"
 inhibit_all_warnings!
 
 target '<#projectName#>' do
 
 pod 'YYKit'
 pod 'FMDB'
 pod 'AFNetworking'
 pod 'MBProgressHUD'
 pod 'UITableView+FDTemplateLayoutCell'
 pod 'MJRefresh'
 
 # pod 'skpsmtpmessage'
 # pod 'Bugly'
 # pod 'Masonry'
 # pod 'IQKeyboardManager'
 
 end
*/

//#if TARGET_OS_SIMULATOR
//[[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
//#endif

//OS_ACTIVITY_MODE = disable

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//------------------------------------------------------------------------------------
#import "UIViewController+JENavBar.h"
#import "UIViewController+JE.h"
#import "UITableViewCell+JE.h"
#import "UIScrollView+JE.h"
#import "NSDictionary+JE.h"
#import "UIImageView+JE.h"
#import "UIButton+JE.h"
#import "UIScreen+JE.h"
#import "NSString+JE.h"
#import "NSObject+JE.h"
#import "UILabel+JE.h"
#import "NSTimer+JE.h"
#import "UIImage+JE.h"
#import "UIColor+JE.h"
#import "CALayer+JE.h"
#import "NSArray+JE.h"
#import "NSDate+JE.h"
#import "UIView+JE.h"
//------------------------------------------------------------------------------------
#import "JETabbarController.h"
#import "JEStaticTableView.h"
#import "JEDebugTool__.h"
#import "JENetWorking.h"
#import "JEAppScheme.h"
#import "JETableView.h"
#import "JEDataBase.h"
#import "JELiteTV.h"
#import "JEButton.h"
#import "JEStvIt.h"
//------------------------------------------------------------------------------------
#import "JEBaseVC.h"
//------------------------------------------------------------------------------------
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIImageView+YYWebImage.h"
#import "NSObject+YYModel.h"
#import "MBProgressHUD.h"
//------------------------------------------------------------------------------------


#pragma mark - define

#define JEShare             ([JEKit Shared])
#define JEBundleImg(file)   ([UIImage imageNamed:[@"JEResource.bundle" stringByAppendingPathComponent:file]])

#ifdef DEBUG
#define JELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
#define JELogs(fmt, ...)    fprintf(stderr,"%s  %d \n %s\n",__func__, __LINE__,[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
#define JELog___(fmt, ...) (({NSString *_ = [NSString stringWithFormat:@"" fmt, ##__VA_ARGS__];fprintf(stderr,"%s\n",[_ UTF8String]); _;}))
#else
#define JELog(...)
#define JELogs(...)
#define JELog___(fmt, ...)   (@"")
#endif

#define JIE1               JELog(@"Debug %s- %d - ",  __func__, __LINE__);
#define JIE2(str)          JELog(@"Debug - %s\n Line:%d \n%@",  __func__, __LINE__,(str));
#define JIE3(num,str)      JELog(@"Debug - %s\n Line:%d \n%d \n%@",  __func__, __LINE__,(num),(str));

#define WSELF          __weak typeof(self) wself = self;
#define SSELF          __strong __typeof(wself)strongSelf = wself;

#define JEApp          ([[UIApplication sharedApplication] delegate])
#define kAPPName       ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
#define kAPPVersions   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define kAPPVersion    ([kAPPVersions stringByReplacingOccurrencesOfString:@"." withString:@""])

#define kAPPLang       [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]
#define kAPPChina      ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] hasPrefix:@"zh-"])

//https://itunes.apple.com/cn/app/id0000000000?mt=8
#pragma mark - JEKit

@interface JEKit : NSObject

/// share
+ (JEKit *)Shared;

/// 写入钥匙串的UUID
+ (NSString*)APP_UUID;

/// IsSimulator
+ (BOOL)IsSimulator;

#pragma mark -
@property (nonatomic,strong) UIColor *HUDClr;///<  HUD颜色 ### UIColor.blackColor
@property (nonatomic,strong) UIColor *textClr;///<  文本颜色 ### 0x333333
@property (nonatomic,strong) UIColor *themeClr;///<  主题颜色 ### nil
@property (nonatomic,strong) UIColor *VCBgClr;/// VC background Color ### (kRGB(244, 245, 246))
@property (nonatomic,strong) UIColor *tvBgClr;///< tableView backgroundColor ### nil
@property (nonatomic,strong) UIColor *tvSepClr;///< tableView separator 分割线颜色 ### kRGB(220, 220, 220)
#pragma mark -
@property (nonatomic,strong) JEStvUIStyle *stc;///< 静态 tableView 样式
#pragma mark -
@property (nonatomic,assign) NSInteger listMgr_beginPage;///< JEListManager --- beginPage ### 1, 网络字段 页数固定从X开始
@property (nonatomic,copy)   NSString *listMgr_pageParam;///< JEListManager --- pageParam ### pageIndex, 网络字段
@property (nonatomic,copy)   NSString *listMgr_rowsParam;///< JEListManager --- rowsParam ### pageSize, 网络字段
@property (nonatomic,assign) NSInteger listMgr_rowsNum;  ///< JEListManager --- rowsNum   ### 15, 每页多少条
#pragma mark -

/// 延迟执行
void delay (float time,void (^block)(void));

#pragma mark - 从系统相册获取图片 | 拍照
typedef void(^pickImgBlock)(UIImage *original,UIImage *fixedImg,UIImagePickerController *picker);
typedef void(^pickImgEndBlock)(void);

@property (nonatomic,strong) UIImagePickerController *picker;///< 调用系统相册中的picker

/// 从系统相册获取图片 [@"拍照",@"从相册中选择"]
+ (void)PickImageWithTitle:(NSString*)title edit:(BOOL)edit pick:(pickImgBlock)block;
/// 从系统相册获取图片 直接使用相机或相册
+ (void)PickImageWithType:(UIImagePickerControllerSourceType)type edit:(BOOL)edit pick:(pickImgBlock)block;
/// 选择完图片回调
+ (void)pickImageEnd:(pickImgEndBlock)block;


#pragma mark - 定位
typedef void(^jeLocationBlock)(id location,NSDictionary *address);

/// 获取当前位置
+ (void)Location:(jeLocationBlock)done;

@end
