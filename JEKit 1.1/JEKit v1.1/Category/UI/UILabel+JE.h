
#import <UIKit/UIKit.h>

UIKIT_EXTERN  UILabel * JELab(CGRect rect,NSString *txt,id fnt,UIColor *clr,NSTextAlignment align,__kindof UIView *addTo);
UIKIT_EXTERN  UILabel * JELa_(NSString *txt,id fnt,UIColor *clr);

@interface UILabel (JE)

/** NSLocalizedString 国际化 */
@property (nonatomic,copy) IBInspectable NSString *loc;

/** UILabel  font = NSNumber | UIFont*/
+ (instancetype)Frame:(CGRect)frame text:(NSString*)text font:(id)font color:(UIColor*)color;
+ (instancetype)Frame:(CGRect)frame text:(NSString*)text font:(id)font color:(UIColor*)color align:(NSTextAlignment)ment;

/** 适应当前宽 */
- (instancetype)sizeThatWidth;

/** 适应当前高 */
- (instancetype)sizeThatHeight;

/** 设置文本 和 字体 */
- (void)setText:(NSString *)text font:(UIFont*)font;

/** 设置文本 和 字体颜色 */
- (void)setText:(NSString *)text color:(UIColor*)color;

/** 全部有行间距的 */
- (instancetype)paragraph:(CGFloat)para;
- (instancetype)paragraph:(CGFloat)para str:(NSString*)str;

/** 部分字符串 添加删除线 */
- (void)delLineStr:(NSString*)editStr;

/** 修改 部分字符串 字体大小  */
- (void)editFont:(UIFont*)font str:(NSString*)editStr;
- (void)editFont:(UIFont*)font range:(NSRange)range;

/** 修改 部分字符串 字体颜色  */
- (void)editColor:(UIColor*)color str:(NSString*)editStr;
- (void)editColor:(UIColor*)color range:(NSRange)range;

/** 修改 部分字符串 属性  */
- (void)addAttribute:(NSString *)name value:(id)value editStr:(NSString*)editStr;

/** 修改 部分字符串 字体大小 颜色 */
- (void)editFont:(UIFont*)font color:(UIColor*)color str:(NSArray <NSString *> *)strs;

/** 后缀添加个图片 */
- (void)je_addSuffixImg:(UIImage *)image size:(CGSize)size;

/** 前缀添加个图片 */
- (void)je_addPrefixImg:(UIImage *)image size:(CGSize)size;

/** adjustsFontSizeToFitWidth = YES */
- (__kindof UILabel * (^)(void))adjust;


@end
