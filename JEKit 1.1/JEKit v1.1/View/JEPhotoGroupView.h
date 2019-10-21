

#import <UIKit/UIKit.h>

//JE - how to use 
//NSMutableArray *items = [NSMutableArray array];
//
//[_mod.imgList enumerateObjectsUsingBlock:^(M1_kdp_VC_Mod_commentList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//    item.thumbView = ((UIImageView*)[self viewWithTag:idx + 1]);
//    item.largeImageURL = obj.img.url;
//    [items addObject:item];
//}];
//
//JEPhotoGroupView *v = [[JEPhotoGroupView alloc] initWithGroupItems:items];
//[v presentFromImageView:gesture.view toContainer:JEApp.window.rootViewController.view animated:YES completion:nil];



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEPhotoGroupItem   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEPhotoGroupItem : NSObject
@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;
@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEPhotoGroupView   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEPhotoGroupView : UIView
@property (nonatomic, readonly) NSMutableArray <JEPhotoGroupItem *>*groupItems; ///< Array<YYPhotoGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;


- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;

@end
