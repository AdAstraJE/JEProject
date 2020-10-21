
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
    NSMutableArray <NSString *> *_Arr_present;///< 弹出过的
    PickImgBlock _pickImgBlock;
    PickImgEndBlock _pickImgEndBlock;
    jeLocationBlock _locationBlock;
    NSMutableArray <UIAlertController *> *_Arr_alert;
}

static JEKit* _sharedManager;
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
        _sharedManager->_Arr_present = [NSMutableArray array];
        _sharedManager->_Arr_alert = [NSMutableArray array];
        _sharedManager.listManagerBeginPage = 1;
        [_sharedManager defaultTheme];
    });
    
    return _sharedManager;
}

+ (instancetype)Shared{ return [[self alloc] init];}
- (instancetype)init{return _sharedManager;}

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

/** 默认UI */
- (void)defaultTheme{
    _HUDColor = (kRGBA(22, 22, 22,0.9));
    _titleColor = (kHexColor(0x333333));
    _VCBackgroundColor = (kRGB(244, 245, 246));
    _tableSeparatorColor = (kHexColor(0xEFEFEF));
}

- (JESTCUIStyle *)stc{
    if (_stc == nil) {_stc = [JESTCUIStyle DefaultStyle]; }return _stc;
}

#pragma mark -

/** 延迟执行 */
void delay (float time,void (^block)(void)){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(),block);
}


#pragma mark - AlertController

/** 限制一个 keyWindow.rootViewController 显示 UIAlertController */
+ (void)ShowAlert:(NSString*)title msg:(NSString*)msg style:(UIAlertControllerStyle)style block:(void(^)(NSString *actions,NSInteger index))block cancel:(NSString *)cancel actions:(NSArray <NSString *> *)actions destructive:(NSArray <NSString *> *)destructive{
    [[JEKit Shared] ShowAlert:title msg:msg style:style block:block cancel:cancel actions:actions destructive:destructive];
}

- (void)ShowAlert:(NSString*)title msg:(NSString*)msg style:(UIAlertControllerStyle)style block:(void(^)(NSString *actions,NSInteger index))block cancel:(NSString *)cancel actions:(NSArray <NSString *> *)actions destructive:(NSArray <NSString *> *)destructive{
    NSString *MD5 = Format(@"%@%@%@%@%@",title,msg,cancel,[actions componentsJoinedByString:@","],[destructive componentsJoinedByString:@","]).MD5;
    if ([_Arr_present containsObject:MD5]) {
        return;
    }
    [_Arr_present addObject:MD5];
    
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:title  message:msg preferredStyle:style];
    [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull btnTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertActionStyle style = ([destructive containsObject:btnTitle] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault);
        [alert addAction:[UIAlertAction actionWithTitle:btnTitle style:style handler:^(UIAlertAction * _Nonnull action) {
            !block ? : block(btnTitle,idx);
            
            [self->_Arr_alert removeObject:alert];
            [alert removeFromParentViewController];
            alert = nil;
            [self->_Arr_present removeObject:MD5];
        }]];
    }];
    
    if (cancel.length) {
        [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            !block ? : block(cancel,actions.count);
            
            [self->_Arr_alert removeObject:alert];
            [alert removeFromParentViewController];
            alert = nil;
            [self->_Arr_present removeObject:MD5];
        }]];
    }
    
    [JEApp.window.rootViewController presentViewController:alert animated:YES completion:nil];
    [_Arr_alert addObject:alert];
}

+ (void)RemoveAllAlert{
    [[JEKit Shared]->_Arr_alert enumerateObjectsUsingBlock:^(UIAlertController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dismissViewControllerAnimated:YES completion:nil];
        [obj removeFromParentViewController];
        obj = nil;
    }];
    [[JEKit Shared]->_Arr_alert removeAllObjects];
}

#pragma mark - 从系统相册获取图片 | 拍照

/** 从系统相册获取图片 [@"拍照",@"从相册中选择"]  返回修改过大小的图片  */
+ (void)PickImageWithTitle:(NSString*)title edit:(BOOL)edit pick:(PickImgBlock)block{
    JEKit *picker = [JEKit Shared];
    picker->_pickImgBlock = block;
    
    [JEKit ShowAlert:title msg:nil style:UIAlertControllerStyleActionSheet block:^(NSString *actions, NSInteger index) {
        if (index == 0) {
            [picker choosePhoto:UIImagePickerControllerSourceTypeCamera edit:edit];
        }else if (index == 1){
            [picker choosePhoto:UIImagePickerControllerSourceTypePhotoLibrary edit:edit];
        }else{
            picker->_pickImgBlock = nil;
        }
    } cancel:@"取消".loc actions:@[@"拍照".loc,@"从相册中选择".loc] destructive:nil];
}

/** 从系统相册获取图片 直接使用相机或相册 */
+ (void)PickImageWithType:(UIImagePickerControllerSourceType)type edit:(BOOL)edit pick:(PickImgBlock)block{
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
    UIImage *OriginalImage = ([info objectForKey:UIImagePickerControllerEditedImage] ? : [info objectForKey:UIImagePickerControllerOriginalImage] );
    UIImage *FixImg = [OriginalImage je_limitImgSize];
    
    if (_pickImgBlock) {
        _pickImgBlock(OriginalImage,FixImg,picker);
        _pickImgBlock = nil;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{ self->_picker = nil;}];
    if (_pickImgEndBlock) { _pickImgEndBlock();}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{self->_picker = nil; }];
    if (_pickImgEndBlock) {_pickImgEndBlock(); }
}

+ (void)pickImageEnd:(PickImgEndBlock)block{
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
