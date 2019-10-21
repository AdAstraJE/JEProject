
#import <UIKit/UIKit.h>

UIKIT_EXTERN  UIImageView * JEImg(CGRect rect,id img,__kindof UIView *addTo);
UIKIT_EXTERN  UIImageView * JEImg_(CGSize size,id img);

@interface UIImageView (JE)

/** UIImageView */
+ (instancetype)F:(CGRect)frame name:(NSString*)name;
+ (instancetype)F:(CGRect)frame image:(UIImage*)image;
+ (instancetype)F:(CGRect)frame mode:(UIViewContentMode)mode;

- (__kindof UIImageView * (^)(UIViewContentMode mode))mode_;///< self.contentMode =

/** 加个点击放大显示图片功能 */
- (void)tapToshowImg;

@end
