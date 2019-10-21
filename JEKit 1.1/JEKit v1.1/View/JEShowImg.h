
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JEShowImg : UIView;

/// window 上显示个图片
/// @param from UIImageView 取位置用
/// @param tureImg window 上显示 真实要显示的图片
/// @param action 是否显示action按钮
+ (instancetype)ShowImgFrom:(UIImageView*)from tureImg:(UIImage*)tureImg action:(BOOL)action;
+ (instancetype)ShowImgFrom:(UIImageView*)from;
+ (instancetype)ShowImgFrom:(UIImageView*)from tureImg:(UIImage*)tureImg;

@end