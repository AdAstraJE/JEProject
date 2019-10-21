//
//  UIImage+JE.h
//  
//
//  Created by JE on 15/6/15.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+YYAdd.h"

@interface UIImage (JE)

/** 截屏吧 截部分视图也行 */
+ (UIImage *)je_captureWithView:(UIView *)view;
+ (UIImage *)je_captureWithView:(UIView *)view size:(CGSize)size;
+ (UIImage *)ImageInRect:(CGRect)rect image:(UIImage *)image;

/** 纯色图片 */
+ (UIImage *)je_ColoreImage:(UIColor *)color;
+ (UIImage *)je_ColoreImage:(UIColor *)color size:(CGSize)size;

/** export AppIcon */
- (void)exportIcon;

/** 添加倒角线条 */
- (UIImage *)addCorner:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin;

/** 按比例 质量 重设图片大小 */
- (UIImage *)je_resizeByQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate;

/** 按比例 重设图片大小 */
- (UIImage *)je_resizeByRate:(CGFloat)rate;

/** 按固定的最大比例压缩图片 */
- (UIImage *)je_limitImgMaxWH:(CGFloat)Max_H_W;
/** 限制到 最大长或宽 800像素  */
- (UIImage *)je_limitImgSize;
/**< 限制到 最大长或宽 150像素 thumbnail（缩略图时 */
- (UIImage *)je_sizeToThum;

/** 返回 按图片比例调整后的最大size */
- (CGSize)je_reSetMaxWH:(CGFloat)WH;

/** 重设像素 */
- (UIImage *)je_sizeTo:(CGSize)size;

/** 图片变颜色 */
- (UIImage *)imageWithColor:(UIColor *)color;

/** imageWithColor */
- (UIImage * (^)(UIColor *c))color;

/** 保存到指定相册名字 */
- (void)je_savedToAlbum:(NSString*)AlbumName success:(void(^)(void))completeBlock fail:(void(^)(void))failBlock;

/** 保存到相册 */
- (void)je_savedToAlbum:(void(^)(void))completeBlock fail:(void(^)(void))failBlock;


/** 水印方向 */
typedef NS_ENUM(NSUInteger, ImageJEWaterMarkType) {
    ImageJEWaterMarkTypeTopLeft = 0,///< 左上
    ImageJEWaterMarkDTypeTopRight,///< 右上
    ImageJEWaterMarkTypeBottomLeft,///< 左下
    ImageJEWaterMarkTypeBottomRight,///< 右下
    ImageJEWaterMarkTypeCenter,///< 居中
};

/** 加水印文字 */
- (UIImage *)je_waterMark:(NSString *)text color:(UIColor *)color font:(UIFont *)font type:(ImageJEWaterMarkType)type offset:(CGPoint)offset;

/** 加水印图片 */
- (UIImage *)je_waterMark:(UIImage *)waterImage size:(CGSize)size type:(ImageJEWaterMarkType)type offset:(CGPoint)offset;

/** 调整方向 */
- (UIImage *)fixOrientation;

/** 旋转角度后的图片 */
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

/** 渐变色类型 */
typedef NS_ENUM(NSUInteger, ImageJEGradualType) {
    ImageJEGradualType1,///< 上到下
    ImageJEGradualType2,///< 左到右
    ImageJEGradualType3,///< 左上到右下
    ImageJEGradualType4,///< 右上到左下
};

/** 渐变色图片 左到右*/
+ (UIImage*)je_GradualColors:(NSArray <UIColor *>*)colors size:(CGSize)size type:(ImageJEGradualType)type;

/** 模糊效果图片 blur 0.0~1.0 颜色要有透明度 */
- (UIImage*)je_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

@end
