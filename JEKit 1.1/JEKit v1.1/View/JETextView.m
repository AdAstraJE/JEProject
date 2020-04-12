

#import "JETextView.h"
#import "JEKit.h"

@implementation JETextView
@synthesize toolbar;

#pragma mark - Setters

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup {
     self.delegate = (id<UITextViewDelegate>)self;
    _placeHolderTextColor = [UIColor lightGrayColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = YES;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDone;;
    self.textAlignment = NSTextAlignmentJustified;
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.enablesReturnKeyAutomatically = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JETextViewDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.La_placeHolder.text = placeHolder;
    [self JETextViewDidChange];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    _placeHolderTextColor = placeHolderTextColor;
    _La_placeHolder.textColor = placeHolderTextColor;
}

- (UILabel *)La_placeHolder {
    if(_La_placeHolder == nil) {
        [self addSubview:(_La_placeHolder = [UILabel Frame:CGRectMake(8, 6, self.width - 24, 20) text:nil font:self.font color:[UIColor lightGrayColor]])];
    }
    return _La_placeHolder;
}

#pragma mark - Message text view

- (NSUInteger)numberOfLinesOfText {
    return [JETextView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text {
    return (text.length / [JETextView maxCharactersPerLine]) + 1;
}

#pragma mark - Text view overrides

- (UIToolbar *)toolbar{
    if (toolbar == nil) {
        UIToolbar *actionBar = [[UIToolbar alloc] init];
        [actionBar sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成".loc style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [actionBar setItems:[NSArray arrayWithObjects: flexible, doneButton, nil]];
        toolbar = actionBar;
        toolbar.barStyle  = UIBarStyleDefault;
        toolbar.translucent = YES;
    }
    return toolbar;
}

- (void)doneClick{
    [self endEditing:YES];
}


/// 强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！) 加强判断 设另个为0
- (void)setJEMaxCharactersLength:(NSUInteger)JEMaxCharactersLength{
    _JEMaxCharactersLength = JEMaxCharactersLength;
    _JEMaxTextLength = 0;
}

/// 强制按text.length长度计算限制文本的最大长度 加强判断  设另个为0
- (void)setJEMaxTextLength:(NSUInteger)JEMaxTextLength{
    _JEMaxTextLength = JEMaxTextLength;
    self.delegate = (id<UITextViewDelegate>)self;
    
}

- (void)setShowToolBar:(BOOL)ShowToolBar{
    _ShowToolBar = ShowToolBar;
    self.delegate = (id<UITextViewDelegate>)self;
}


#pragma mark - Notifications

- (void)JETextViewDidChange{
    if (_JEMaxCharactersLength) {
        if (self.markedTextRange == nil  && [self.text textLength] > _JEMaxCharactersLength) {
            self.text = [self.text je_limitTo:_JEMaxCharactersLength];
        }
    }
    if (_JEMaxTextLength) {
        if (self.markedTextRange == nil  &&  self.text.length > _JEMaxTextLength) {
            self.text = [self.text substringToIndex:_JEMaxTextLength];
        }
    }
    _La_placeHolder.hidden = !(self.text.length == 0);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];return NO;
    }
    if (range.length == 1) {
        return YES;
    }
    if (_JEMaxTextLength && self.text.length >_JEMaxTextLength) {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.ShowToolBar) {
        textView.inputAccessoryView = self.toolbar;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    [textView scrollRangeToVisible:NSMakeRange([textView.text length]-1,0)];
    NSRange textRange = [textView selectedRange];
    [textView setSelectedRange:textRange];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    !_didEndEditing ? : _didEndEditing(textView);
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self JETextViewDidChange];
}


@end
