
#import <UIKit/UIKit.h>
#import "UIImage+YYAdd.h"

@interface UIImage (JE)

/// 截取view为mage
+ (UIImage *)je_capture:(UIView *)view size:(CGSize)size;
/// 纯色图片 size
+ (UIImage *)je_clr:(UIColor *)color size:(CGSize)size;

+ (UIImage * (^)(UIColor *c))clr;///< 纯色图片 1x1
- (UIImage * (^)(UIColor *c))clr;///< 图片变色
- (UIImage *)je_clr:(UIColor *)color;
- (UIImage * (^)(CGFloat a))alpha;///< 图片变alpha
- (UIImage * (^)(CGRect rect))clip;///< 裁剪

/// export AppIcon, if https://icon.wuruihong.com/ notworking
- (void)exportIcon;

/// 按质量、比例 重设图片
- (UIImage *)je_resetQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate;

/// 按限制的长宽 重设图片
- (UIImage *)je_limitToWH:(CGFloat)maxWH;

/// 重设像素
- (UIImage *)je_sizeTo:(CGSize)size;

/// 保存到指定相册名字
- (void)je_savedToAlbum:(NSString*)AlbumName success:(void(^)(void))completeBlock fail:(void(^)(void))failBlock;

/// 保存到相册
- (void)je_savedToAlbum:(void(^)(void))completeBlock fail:(void(^)(void))failBlock;


/// 水印方向
typedef NS_ENUM(NSUInteger, ImageJEWaterMarkType) {
    ImageJEWaterMarkTypeTopLeft = 0,///< 左上
    ImageJEWaterMarkDTypeTopRight,///< 右上
    ImageJEWaterMarkTypeBottomLeft,///< 左下
    ImageJEWaterMarkTypeBottomRight,///< 右下
    ImageJEWaterMarkTypeCenter,///< 居中
};

/// 加水印文字
- (UIImage *)je_waterMark:(NSString *)text color:(UIColor *)color font:(UIFont *)font type:(ImageJEWaterMarkType)type offset:(CGPoint)offset;

/// 加水印图片
- (UIImage *)je_waterMark:(UIImage *)waterImage size:(CGSize)size type:(ImageJEWaterMarkType)type offset:(CGPoint)offset;

/// 调整方向
- (UIImage *)fixOrientation;

/// 旋转角度后的图片
- (UIImage*)je_rotate:(CGFloat)degrees;

/// 渐变色类型
typedef NS_ENUM(NSUInteger, ImageJEGradualType) {
    ImageJEGradualType1 = 0,///< 上到下
    ImageJEGradualType2 = 1,///< 左到右
    ImageJEGradualType3 = 2,///< 左上到右下
    ImageJEGradualType4 = 3,///< 右上到左下
};

/// 渐变色图片 左到右
+ (UIImage*)je_gradualColors:(NSArray <UIColor *>*)colors size:(CGSize)size type:(ImageJEGradualType)type;

/// 模糊效果图片 blur 0.0~1.0 颜色要有透明度
- (UIImage*)je_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

@end
