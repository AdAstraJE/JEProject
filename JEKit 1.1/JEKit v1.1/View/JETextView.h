
#import <UIKit/UIKit.h>

@interface JETextView : UITextView<UITextViewDelegate>

@property (nonatomic, copy) NSString *placeHolder;///< 提示用户输入的标语
@property (nonatomic, strong) UIColor *placeHolderTextColor;///< 标语文本的颜色

///  获取自身文本占据有多少行
- (NSUInteger)numberOfLinesOfText;

/// 获取每行的高度
+ (NSUInteger)maxCharactersPerLine;

/// 获取某个文本占据自身适应宽带的行数
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@property (nonatomic,assign) NSUInteger JEMaxCharactersLength;///< 强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！)

@property (nonatomic,assign) NSUInteger JEMaxTextLength;///<  强制按text.length长度计算限制文本的最大长度
@property (nonatomic,assign) BOOL ShowToolBar;///< 显示ToolBar 
@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic,strong) UILabel *La_placeHolder;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;

@property (nonatomic,copy) void (^didEndEditing)(UITextView *textView);

@end
