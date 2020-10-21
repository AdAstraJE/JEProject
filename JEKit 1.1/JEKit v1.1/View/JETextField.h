
#import <UIKit/UIKit.h>

static NSInteger const jkTfTextMargin = 8;///<

@interface JETextField : UITextField

@property (nonatomic,assign) CGRect moreTouchMargin;///< 给予更多的边界 点击范围 按照UIEdgeInsets 用
@property (nonatomic,assign) BOOL disabelWhenEditing;///< 编辑的时候不允许点击 覆盖个透明的view
@property (nonatomic,assign)  BOOL isTelePhone;///< 认为是电话号码(11位) 按电话号码的限制输入 
@property (nonatomic,assign)  NSUInteger divisions;///< 每隔X 分割一个空格
@property (nonatomic,assign)  BOOL numberOnly;///< 纯数字形式的输入
@property (nonatomic,assign)  BOOL floatOnly;///< 数字形式的输入 可以有小数点 点后最多floatDotLimit位数
@property (nonatomic,assign)  NSUInteger floatDotLimit;///< 点后最多X位数 ### 2
@property (nonatomic,assign)  BOOL ASCIIOnly;///< 必须是 ASCII字符
@property (nonatomic,assign)  BOOL AZ09Only;///< 必须是 字母和数字
@property (nonatomic,assign)  NSUInteger JEMaxCharactersLength;///< 强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！)
@property (nonatomic,assign)  NSUInteger JEMaxTextLength;///< 强制按text.length长度计算限制文本的最大长度

/// 右边也加placeHolder
- (void)addRightPlaceHolder:(NSString *)placeHolder;

/// 当前选择的范围
- (NSRange)selectedRange;

/// 设置选择范围 必须为第一响应者才有效 
- (void)setSelectedRange:(NSRange)range;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@property (nonatomic,copy) void (^didBeginBlock)(__kindof UITextField *textField);
@property (nonatomic,copy) void (^didChangeBlock)(__kindof UITextField *textField);
@property (nonatomic,copy) void (^didEndBlock)(__kindof UITextField *textField);

@end
