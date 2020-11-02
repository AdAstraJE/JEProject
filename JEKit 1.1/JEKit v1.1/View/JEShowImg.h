
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JEShowImgActionType_) {
    JEShowImgActionType_none,
    JEShowImgActionType_share,
    JEShowImgActionType_delete,
};

@interface JEShowImg : UIView;

/// window 上显示个图片
/// @param from UIImageView 取位置用
/// @param trueImg window 上显示 真实要显示的图片
/// @param action 是否显示action按钮
+ (instancetype)ShowImgFrom:(UIImageView*)from trueImg:(UIImage*)trueImg action:(JEShowImgActionType_)action;
+ (instancetype)ShowImgFrom:(UIImageView*)from trueImg:(UIImage*)trueImg;
+ (instancetype)ShowImgFrom:(UIImageView*)from;

/// LivePhoto
+ (instancetype)ShowLivePhoto:(id)livePhoto;

@property (nonatomic,copy) void (^deleteActionClick)(UIImageView *fromView);///<

@end
