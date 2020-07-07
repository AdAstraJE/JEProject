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
 pod 'Masonry'
 pod 'AFNetworking', :git => 'https://github.com/AFNetworking/AFNetworking'
 pod 'MBProgressHUD'
 pod 'UITableView+FDTemplateLayoutCell'
 pod 'MJRefresh'
 pod 'SDWebImage'
 
 # pod 'IQKeyboardManager'
 pod 'skpsmtpmessage'
 
 pod 'Bugly'
 pod 'ShareSDK3'
 pod 'ShareSDK3/ShareSDKPlatforms/QQ'
 pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
 
 end
 
 
 
 pod install
 pod outdated
 pod update  --
 InfoPlist
 Localizable
 
 https://itunes.apple.com/cn/app/id0000000000?mt=8

 #if TARGET_OS_SIMULATOR
 [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
 #endif
 
 OS_ACTIVITY_MODE = disable
 
 defaults read -g com.apple.mouse.scaling
 defaults write -g com.apple.mouse.scaling 9
 
 */




#import <Foundation/Foundation.h>
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
#import "JEDataBase.h"
#import "JESTCItem.h"
#import "JEButton.h"
//------------------------------------------------------------------------------------
#import "JEBaseTVC.h"
#import "JEBaseVC.h"
//------------------------------------------------------------------------------------
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NSObject+YYModel.h"
#import "MBProgressHUD.h"
//------------------------------------------------------------------------------------


#pragma mark - define

#define JEShare             ([JEKit Shared])
#define JEResource(file)    ([@"JEResource.bundle" stringByAppendingPathComponent:file])

#ifdef DEBUG
#define JELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
#define JELogs(fmt, ...)    fprintf(stderr,"%s  %d \n %s\n",__func__, __LINE__,[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
#define JELog___(fmt, ...)  (({NSString *_ = [NSString stringWithFormat:@"" fmt, ##__VA_ARGS__];fprintf(stderr,"%s\n",[_ UTF8String]); _;}))
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
#define kAPPName       (([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]) ? : ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]))
#define kAPPBundleId   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])
#define kAPPVersions   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define kAPPVersion    ([kAPPVersions stringByReplacingOccurrencesOfString:@"." withString:@""])

#define kAPPLang       [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]
#define kAPPChina      ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] hasPrefix:@"zh-"])



#pragma mark - JEKit

@interface JEKit : NSObject

+ (JEKit *)Shared;

+ (NSString*)APP_UUID;///< 写入钥匙串的UUID

+ (BOOL)IsSimulator;

//---------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic,strong) UIColor *HUDColor;///<  HUD颜色 ### nil
@property (nonatomic,strong) UIColor *titleColor;///<  文本颜色 ### 0x333333
@property (nonatomic,strong) UIColor *themeColor;///<  某些JE控件label button 文字颜色 ### nil
@property (nonatomic,strong) UIColor *VCBackgroundColor;///< VC backgroundColor ### (kRGB(244, 245, 246))
@property (nonatomic,strong) UIColor *tableBackgroundColor;///< tableView backgroundColor ### nil
@property (nonatomic,strong) UIColor *tableSeparatorColor;///< tableView分割线颜色 ### nil
@property (nonatomic,strong) JESTCUIStyle *stc;///< 静态 tableView 样式
//---------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic,assign) NSInteger listManagerBeginPage;///< JEListManager BeginPage ### 1


/** 延迟执行 */
void delay (float time,void (^block)(void));


#pragma mark - AlertController

/** UIAlertController 根据字符串组合区分是否重复弹出 */
+ (void)ShowAlert:(NSString*)title msg:(NSString*)msg style:(UIAlertControllerStyle)style block:(void(^)(NSString *actions,NSInteger index))block cancel:(NSString *)cancel actions:(NSArray <NSString *> *)actions destructive:(NSArray <NSString *> *)destructive;

/** RemoveAll UIAlertController  */
+ (void)RemoveAllAlert;

#pragma mark - 从系统相册获取图片 | 拍照

typedef void(^PickImgBlock)(UIImage *original,UIImage *fixedImg,UIImagePickerController *picker);
typedef void(^PickImgEndBlock)(void);

@property (nonatomic,strong) UIImagePickerController *picker;///< 调用系统相册中的picker

/** 从系统相册获取图片 [@"拍照",@"从相册中选择"]  */
+ (void)PickImageWithTitle:(NSString*)title edit:(BOOL)edit pick:(PickImgBlock)block;
/** 从系统相册获取图片 直接使用相机或相册 */
+ (void)PickImageWithType:(UIImagePickerControllerSourceType)type edit:(BOOL)edit pick:(PickImgBlock)block;
/** 选择完图片回调 */
+ (void)pickImageEnd:(PickImgEndBlock)block;




#pragma mark - 定位
typedef void(^jeLocationBlock)(id location,NSDictionary *address);

/** 获取当前位置 */
+ (void)Location:(jeLocationBlock)done;


@end
