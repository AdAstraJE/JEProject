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
 pod 'AFNetworking', :git => 'https://github.com/AFNetworking/AFNetworking'
 pod 'MBProgressHUD'
 pod 'UITableView+FDTemplateLayoutCell'
 pod 'MJRefresh'
 
 # pod 'skpsmtpmessage'
 # pod 'Bugly'
 # pod 'Masonry'
 # pod 'IQKeyboardManager'
 
 end


 git config --global http.proxy socks5://127.0.0.1:1080
 git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
 git config --global --unset http.proxy
 git config --global --unset http.https://github.com.proxy
 
 #if TARGET_OS_SIMULATOR
 [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
 #endif
 
 OS_ACTIVITY_MODE = disable
 
 defaults read -g com.apple.mouse.scaling
 defaults write -g com.apple.mouse.scaling 4
 
*/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//------------------------------------------------------------------------------------
#import "UIViewController+JEHUD.h"
#import "UIViewController+JE.h"
#import "UIView+JEAutoLayout.h"
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
#define kAPPBundleId   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])

#define kAPPLang       [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]
#define kAPPChina      ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] hasPrefix:@"zh-"])

#define iPad           ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface JEKit : NSObject

/// share
+ (JEKit *)Shared;

/// 写入钥匙串的UUID
+ (NSString*)APP_UUID;

/// IsSimulator
+ (BOOL)IsSimulator;

#pragma mark -
@property (nonatomic,strong) UIColor *HUDClr;///<  HUD颜色 ### light dark
@property (nonatomic,strong) UIColor *themeClr;///<  主题颜色 ### nil
@property (nonatomic,strong) UIColor *VCBgClr;/// VC background Color ### nil
#pragma mark - "导航栏”
@property (nonatomic,strong)  UIColor *navBarClr;///< 导航栏背景颜色 ###  nil
@property (nonatomic,strong)  UIImage *navBarImage;///< 导航栏背景图片 ### nil
@property (nonatomic,strong)  UIColor *navBarLineClr;///< 导航栏底部线条颜色 ### UIColor.gray3
@property (nonatomic,strong)  UIColor *navBarItemClr;///< 返回键 左右控制键 按钮颜色 ### Clr_blue
@property (nonatomic,assign)  CGFloat navBarItemFontSize;///< 左右控制键 按钮FontSize ### 17
@property (nonatomic,strong)  UIColor *navTitleClr;///< 标题颜色
#pragma mark - tableView
@property (nonatomic,strong) UIColor *tvBgClr;///< tableView backgroundColor ### nil
@property (nonatomic,strong) UIColor *tvSepClr;///< tableView separator 分割线颜色 ### nil
@property (nonatomic,strong) UIColor *tvCellSelectBgClr;///< tableViewCell selectedBackgroundView ### 
#pragma mark - JEStvUIStyle
@property (nonatomic,strong) JEStvUIStyle *stc;///< 静态 tableView 样式
#pragma mark - JEListManager
@property (nonatomic,assign) NSInteger listMgr_beginPage;///< beginPage ### 1, 网络字段 页数固定从X开始
@property (nonatomic,copy)   NSString *listMgr_pageParam;///< pageParam ### pageIndex, 网络字段
@property (nonatomic,copy)   NSString *listMgr_rowsParam;///< rowsParam ### pageSize, 网络字段
@property (nonatomic,assign) NSInteger listMgr_rowsNum;  ///< rowsNum   ### 15, 每页多少条

/// 延迟执行
void delay (float time,void (^block)(void));

@end
