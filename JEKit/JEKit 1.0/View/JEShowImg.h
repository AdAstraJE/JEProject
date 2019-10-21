
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JEShowImg : UIView;

/** window 上显示个图片 UIImageView 取位置  Fromview取原始位置用*/
+ (void)showImgFrom:(UIImageView*)view;
+ (void)showImgFrom:(UIImageView*)view tureImg:(UIImage*)tureimg;/**< window 上显示 真实要显示的图片 */
+ (void)showImgFrom:(UIImageView*)view tureImg:(UIImage*)tureimg showSave:(BOOL)save;/**< 是否显示保存按钮 */
+ (void)hideImage;

@end
