
#import "JEKit.h"
#import "YYKeychain.h"

@implementation JEKit

static JEKit *_shared;
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [super allocWithZone:zone];
        [_shared defaultTheme];
    });
    
    return _shared;
}

+ (instancetype)Shared{ return [[self alloc] init];}
- (instancetype)init{return _shared;}

- (void)defaultTheme{
    _HUDClr = [UIColor Light:kRGBA(0, 0, 0,0.88) dark:kRGBA(255, 255, 255,0.92)];
    
    _navBarLineClr = UIColor.gray3;
    _navBarItemClr = Clr_blue;
    _navTitleClr = UIColor.je_txt;
    _navBarItemFontSize = 17.0;

    _tvSepClr = UIColor.je_sep;
    _tvCellSelectBgClr = [UIColor Light:kRGB(229, 229,234) dark:kRGB(44, 44, 47)];
    
    _shared.listMgr_beginPage = 1;
    _shared.listMgr_pageParam = @"pageIndex";
    _shared.listMgr_rowsParam = @"pageSize";
    _shared.listMgr_rowsNum = 15;
    
}

- (JEStvUIStyle *)stc{
    if (_stc == nil) {_stc = [JEStvUIStyle DefaultStyle]; }return _stc;
}

+ (NSString*)APP_UUID{
    static NSString *__UUID;
    if (__UUID.length) {
        return __UUID;
    }
    NSString *Identifier = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
    NSString *UUIDString = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSError *error;
    YYKeychainItem *Keyitem = [[YYKeychainItem alloc]init];
    Keyitem.service = Identifier;
    Keyitem.account = Identifier;
    YYKeychainItem *oldKeyChain = [YYKeychain selectOneItem:Keyitem error:&error];
    if (oldKeyChain == nil) {
        Keyitem.password = UUIDString;
        Keyitem.passwordData = UUIDString.data;
        [YYKeychain insertItem:Keyitem error:&error];
        return (__UUID = UUIDString);
    }else{
        if (error == nil) {
            return (__UUID = oldKeyChain.password);
        }
        return (__UUID = UUIDString);
    }
}

+ (BOOL)IsSimulator{
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

#pragma mark -

void delay (float time,void (^block)(void)){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(),block);
}


@end
