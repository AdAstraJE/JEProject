
#import "JEAppScheme.h"
#import "JEKit.h"
#import "JEBaseNavtion.h"
#import "JEIntroducView.h"

static NSString * const jkJEDefaultNotiTips         = @"jkJEDefaultNotiTips";///< 区分出现过的情况
static NSString * const jkJEUserClassKey            = @"jkJEUserClassKey";///< 模型class
static NSString * const jkJEUserAccountKey          = @"jkJEUserAccountKey";///< 账号
static NSString * const jkJEUserPasswordKey         = @"jkJEUserPasswordKey";///< 密码
static NSString * const jkJEUserDictionaryKey       = @"jkJEUserDictionaryKey";///< 用户Dic

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @implementation JEAppScheme   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEAppScheme{
    NSObject <JESchemeDelegate> *_appUser;
}

static JEAppScheme* _sharedManager;
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
    });
    
    return _sharedManager;
}

+ (instancetype)Shared{ return [[self alloc] init];}
- (instancetype)init{   return _sharedManager;}

/** 当前用户 */
+ (NSObject <JESchemeDelegate> *)User{
    return [JEAppScheme Shared]->_appUser;
}

/** 更新保存用户 */
+ (void)SaveUser{
    if ([JEAppScheme Shared]->_appUser) {
        [USDF setObject:[[JEAppScheme Shared]->_appUser modelToJSONObject] forKey:jkJEUserDictionaryKey];
        [USDF synchronize];
    }
}

/** 自动登录记录过的用户 */
+ (void)AutoLogin{
    NSDictionary *userDic = [USDF objectForKey:jkJEUserDictionaryKey];
    if (userDic.count && [self CachePassword].length) {
        [self LoginAccount:[self CacheAccount] password:nil user:[(NSClassFromString([USDF objectForKey:jkJEUserClassKey])) modelWithJSON:userDic]];
    }
}

/** 记录并登录用户 */
+ (void)LoginAccount:(NSString *)account password:(NSString *)password user:(NSObject <JESchemeDelegate> *)user{
    if (user == nil ) { return; }

    [JEAppScheme Shared]->_appUser = user;
//    if (user.userId.length == 0) {return;}
    NSString *databaseName = user.userId;
    if ([user.class respondsToSelector:@selector(databaseName)]) {
        databaseName = (user.databaseName ? : user.userId);
    }
    [JEDataBase SharedDbName:databaseName];
    
    if (password) {
        [USDF setObject:NSStringFromClass(user.class) forKey:jkJEUserClassKey];
        [USDF setObject:account forKey:jkJEUserAccountKey];
        [USDF setObject:password forKey:jkJEUserPasswordKey];
        [USDF setObject:[user modelToJSONObject] forKey:jkJEUserDictionaryKey];
        [USDF synchronize];
    }

    if ([user.class respondsToSelector:@selector(WillSetRootVC)]) { [user.class WillSetRootVC];}
    
    UIViewController *root = [user.class HandleRootVC];
    JEApp.window.rootViewController = [[JEBaseNavtion alloc] initWithRootViewController:root];
    [JEApp.window.layer je_fade];
    
    if ([user.class respondsToSelector:@selector(DidSetRootVC)]) { [user.class DidSetRootVC];}
}

/** 退出登录 至(Main.storyboard) */
+ (void)Logout{
    [[JENetWorking Shared] cancelAllTask];
    [JEDataBase Close];
    [USDF removeObjectForKey:jkJEUserPasswordKey];
    [USDF synchronize];
    
    if ([[JEAppScheme Shared]->_appUser.class respondsToSelector:@selector(WillLogout)]) {
        [[JEAppScheme Shared]->_appUser.class WillLogout];
    }
    
    JEApp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [JEApp.window.layer je_fade];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([[JEAppScheme Shared]->_appUser.class respondsToSelector:@selector(DidLogout)]) {
        [[JEAppScheme Shared]->_appUser.class DidLogout];
    }
    
    [JEAppScheme Shared]->_appUser = nil;
}

/** 是否第一次出现的情况  区分版本号否  第一次 返回 YES*/
+ (BOOL)isFirstCaseByVersion:(BOOL)version caseKey:(NSString*)caseKey{
    NSMutableArray <NSString *> *notiArr = [NSMutableArray arrayWithArray:[USDF objectForKey:jkJEDefaultNotiTips]];
    NSString *versionNoti = [NSString stringWithFormat:@"%@_%@",caseKey,version ? kAPPVersion : @""];
    if (![notiArr containsObject:versionNoti]) {
        [notiArr addObject:versionNoti];
        [USDF setObject:notiArr forKey:jkJEDefaultNotiTips];
        [USDF synchronize];
        return YES;
    }

    return NO;
}

/** 自动显示一次引导页,图片名字格式(【引导页%d_%@】,%d:序号从1开始 %@:屏幕分辨率)  eg.引导页1_640_960 */
+ (void)AutoShowIntroducViewWithTint:(UIColor *)tint{
    if (![self isFirstCaseByVersion:NO caseKey:[JEIntroducView ClassName]]) {
        return;
    }

//    NSString *defaultSuffix = @"750_1334";
    NSString *suffix = @"";
    if (iPhone4_Screen) { suffix = @"640_960";}
    else if (iPhone5_Screen || iPhone6_Screen || iPhone6Plus_Screen) { suffix = @"750_1334";}
    else{suffix = @"1125_2436";}
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i<= 10; i++) {
        UIImage *image = [NSString stringWithFormat:@"引导页%d_%@",i,suffix].img ? : [NSString stringWithFormat:@"引导页%d",i].img ;
        if (image == nil) { break;}
        [images addObject:image];
    }
    
    if (images.count) {
        [JEIntroducView Introduc:images tint:tint];
    }
}

+ (JEBaseNavtion *)RootVC  { return (JEBaseNavtion *)JEApp.window.rootViewController;}
+ (NSString *)CacheAccount {return [USDF objectForKey:jkJEUserAccountKey];}
+ (NSString *)CachePassword{return [USDF objectForKey:jkJEUserPasswordKey];}

@end
