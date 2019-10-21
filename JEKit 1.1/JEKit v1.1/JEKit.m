
#import "JEKit.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import "YYKeychain.h"

@interface JEKit ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation JEKit{
    pickImgBlock _pickImgBlock;
    pickImgEndBlock _pickImgEndBlock;
    jeLocationBlock _locationBlock;
}

static JEKit* _sharedManager;
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
        [_sharedManager defaultTheme];
    });
    
    return _sharedManager;
}

+ (instancetype)Shared{ return [[self alloc] init];}
- (instancetype)init{return _sharedManager;}

/** 默认UI */
- (void)defaultTheme{
    _HUDClr = (kHexColor(0x202020));
    _textClr = (kHexColor(0x333333));
    _VCBgClr = (kRGB(244, 245, 246));
    _tvSepClr = (kRGB(220, 220, 220));
    
    _sharedManager.listMgr_beginPage = 1;
    _sharedManager.listMgr_pageParam = @"pageIndex";
    _sharedManager.listMgr_rowsParam = @"pageSize";
    _sharedManager.listMgr_rowsNum = 15;
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

/** 延迟执行 */
void delay (float time,void (^block)(void)){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(),block);
}

#pragma mark - 从系统相册获取图片 | 拍照

/** 从系统相册获取图片 [@"拍照",@"从相册中选择"]  返回修改过大小的图片  */
+ (void)PickImageWithTitle:(NSString*)title edit:(BOOL)edit pick:(pickImgBlock)block{
    JEKit *picker = [JEKit Shared];

    [JEApp.window.rootViewController Alert:title msg:nil act:@[@"拍照".loc,@"从相册中选择".loc] destruc:nil _:^(NSString *act, NSInteger idx) {
        picker->_pickImgBlock = block;
        if (idx == 0) {
            [picker choosePhoto:UIImagePickerControllerSourceTypeCamera edit:edit];
        }else if (idx == 1){
            [picker choosePhoto:UIImagePickerControllerSourceTypePhotoLibrary edit:edit];
        }
    }];
}

/** 从系统相册获取图片 直接使用相机或相册 */
+ (void)PickImageWithType:(UIImagePickerControllerSourceType)type edit:(BOOL)edit pick:(pickImgBlock)block{
    JEKit *picker = [JEKit Shared];
    picker->_pickImgBlock = block;
    [picker choosePhoto:type edit:edit];
}

//@"拍照",@"从相册中选择"
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
    
    if (_pickImgBlock) {
        _pickImgBlock(originalImage,fixImg,picker);
        _pickImgBlock = nil;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{ self->_picker = nil;}];
    if (_pickImgEndBlock) { _pickImgEndBlock();}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{self->_picker = nil; }];
    if (_pickImgEndBlock) {_pickImgEndBlock(); }
}

+ (void)pickImageEnd:(pickImgEndBlock)block{
    [JEKit Shared]->_pickImgEndBlock = block;
}


#pragma mark - 定位
/** 获取当前位置 */
+ (void)Location:(jeLocationBlock)done{
    [JEKit Shared]->_locationBlock = done;
    [[JEKit Shared].locationManager startUpdatingLocation];
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
        NSDictionary *mark = placemarks.firstObject.addressDictionary;
        if ([JEKit Shared]->_locationBlock) {
            [JEKit Shared]->_locationBlock(locations.lastObject,mark);
            [JEKit Shared]->_locationBlock = nil;
        }
    }];
}

@end
