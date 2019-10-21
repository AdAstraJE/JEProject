
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JEBaseNavtion.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @protocol JESchemeDelegate   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
@protocol JESchemeDelegate

/** 用户id */
- (NSString *)userId;

/** 设置APP登录后的页面 */
+ (UIViewController *)HandleRootVC;

@optional

/** 数据库名 默认userId */
- (NSString *)databaseName;

/** 将要设置root vc */
+ (void)WillSetRootVC;

/** 设置完root vc */
+ (void)DidSetRootVC;

/** 将要退出登录 */
+ (void)WillLogout;

/** 退出了登录 */
+ (void)DidLogout;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface JEAppScheme   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEAppScheme : NSObject

/** 当前用户 */
+ (NSObject <JESchemeDelegate> *)User;

/** 更新保存用户 */
+ (void)SaveUser;

/** 自动登录记录过的用户 */
+ (void)AutoLogin;

/** 记录并登录用户 */
+ (void)LoginAccount:(NSString *)account password:(NSString *)password user:(NSObject <JESchemeDelegate> *)user;

/** 退出登录 至(Main.storyboard) */
+ (void)Logout;

/** 是否第一次出现的情况  区分版本号否  第一次 返回 YES*/
+ (BOOL)isFirstCaseByVersion:(BOOL)version caseKey:(NSString*)caseKey;

/** 自动显示一次引导页,图片名字格式(【引导页%d_%@】,%d:序号从1开始 _%@:屏幕分辨率,可选)  eg.引导页1_640*960，引导页2*/
+ (void)AutoShowIntroducViewWithTint:(UIColor *)tint;

+ (JEBaseNavtion *)RootVC;///< window.rootViewController
+ (NSString *)CacheAccount;///< 登录过的Account
+ (NSString *)CachePassword;///< 登录过的Password


@end
