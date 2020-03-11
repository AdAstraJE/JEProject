
#import "JEAppScheme.h"
#import "JEKit.h"
#import "JEBaseNavtion.h"
#import "JEIntroducView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>

static NSString * const jkJEDefaultNotiTips         = @"jkJEDefaultNotiTips";///< 区分出现过的情况
static NSString * const jkJEUserClassKey            = @"jkJEUserClassKey";///< 模型class
static NSString * const jkJEUserAccountKey          = @"jkJEUserAccountKey";///< 账号
static NSString * const jkJEUserPasswordKey         = @"jkJEUserPasswordKey";///< 密码
static NSString * const jkJEUserDictionaryKey       = @"jkJEUserDictionaryKey";///< 用户Dic

@implementation JEAppScheme{
    NSObject <JESchemeDelegate> *_appUser;

    void (^_pickImgEnd)(void);
    void (^_pickImgDone)(UIImage *original,UIImage *fixedImg,UIImagePickerController *picker);
    
    CLLocationManager *_locationManager;
    void (^_location)(id location,id placemark);
}

static JEAppScheme *_shared;
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [super allocWithZone:zone];
    });
    
    return _shared;
}

+ (instancetype)Shared{ return [[self alloc] init];}
- (instancetype)init{   return _shared;}

+ (NSObject <JESchemeDelegate> *)User{
    return _shared->_appUser;
}

+ (void)SaveUser{
    if (_shared->_appUser) {
        [USDF setObject:[_shared->_appUser modelToJSONObject] forKey:jkJEUserDictionaryKey];
        [USDF synchronize];
    }
}

+ (void)AutoLogin{
    NSDictionary *userDic = [USDF objectForKey:jkJEUserDictionaryKey];
    if (userDic.count && [self CachePassword].length) {
        [self LoginAccount:[self CacheAccount] password:nil user:[(NSClassFromString([USDF objectForKey:jkJEUserClassKey])) modelWithJSON:userDic]];
    }
}

+ (void)LoginAccount:(NSString *)account password:(NSString *)password user:(NSObject <JESchemeDelegate> *)user{
    if (user == nil ) { return; }

    _shared->_appUser = user;
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

+ (void)Logout{
    [[JENetWorking Shared] cancelAllTask];
    [JEDataBase Close];
    [USDF removeObjectForKey:jkJEUserPasswordKey];
    [USDF synchronize];
    
    if ([_shared->_appUser.class respondsToSelector:@selector(WillLogout)]) {
        [_shared->_appUser.class WillLogout];
    }
    
    JEApp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [JEApp.window.layer je_fade];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([_shared->_appUser.class respondsToSelector:@selector(DidLogout)]) {
        [_shared->_appUser.class DidLogout];
    }
    
    _shared->_appUser = nil;
}

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

+ (void)AutoShowIntroducViewWithTint:(UIColor *)tint{
    if (![self isFirstCaseByVersion:NO caseKey:[JEIntroducView className]]) {
        return;
    }

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


#pragma mark - 从系统相册获取图片 | 拍照
+ (void)PickImageWithTitle:(NSString*)title edit:(BOOL)edit pick:(void (^)(UIImage *original,UIImage *fixedImg,UIImagePickerController *picker))block{
    [JEApp.window.rootViewController Alert:title msg:nil act:@[@"拍照".loc,@"从相册中选择".loc] destruc:nil _:^(NSString *act, NSInteger idx) {
        _shared->_pickImgDone = block;
        if (idx == 0) {
            [_shared choosePhoto:UIImagePickerControllerSourceTypeCamera edit:edit];
        }else if (idx == 1){
            [_shared choosePhoto:UIImagePickerControllerSourceTypePhotoLibrary edit:edit];
        }
    }];
}

+ (void)PickImageWithType:(UIImagePickerControllerSourceType)type edit:(BOOL)edit pick:(void (^)(UIImage *original,UIImage *fixedImg,UIImagePickerController *picker))block{
    _shared->_pickImgDone = block;
    [_shared choosePhoto:type edit:edit];
}

- (void)choosePhoto:(UIImagePickerControllerSourceType)choosetype edit:(BOOL)edit{
    if(![UIImagePickerController isSourceTypeAvailable:choosetype]){
        return;
    }
    if(choosetype == UIImagePickerControllerSourceTypeCamera){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.translucent = YES;
    picker.allowsEditing = edit;
    picker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self;
    picker.sourceType = choosetype;
    [JEApp.window.rootViewController presentViewController:picker animated:YES completion:nil];
    _picker = picker;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *originalImage = ([info objectForKey:UIImagePickerControllerEditedImage] ? : [info objectForKey:UIImagePickerControllerOriginalImage] );
    UIImage *fixImg = [originalImage je_limitToWH:800];
    
    if (_pickImgDone) {
        _pickImgDone(originalImage,fixImg,picker);
        _pickImgDone = nil;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{ self->_picker = nil;}];
    if (_pickImgEnd) { _pickImgEnd();}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{self->_picker = nil; }];
    if (_pickImgEnd) {_pickImgEnd(); }
}

+ (void)pickImageEnd:(void (^)(void))block{
    _shared->_pickImgEnd = block;
}


#pragma mark - 定位
+ (void)Location:(void (^)(id location,id placemark))done{
    _shared->_location = done;
    [_shared.locationManager startUpdatingLocation];
}

- (CLLocationManager *)locationManager {
    if(_locationManager == nil) {
        CLLocationManager *_ = [[CLLocationManager alloc] init];
        _.delegate = (id<CLLocationManagerDelegate>)self;
        _.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [_ requestWhenInUseAuthorization];
        _locationManager = _;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || [placemarks count] == 0) {  return ;}
        if (_shared->_location) {
            _shared->_location(locations.lastObject,placemarks);
            _shared->_location = nil;
        }
    }];
}


@end
