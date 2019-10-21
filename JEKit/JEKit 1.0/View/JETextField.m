
#import "JETextField.h"
#import "NSString+JE.h"
#import <objc/runtime.h>

@interface JETextField ()

@property (nonatomic,strong) UIView *Ve_alpha;/**< 编辑的时候不允许点击 覆盖个透明的view */

@end

@implementation JETextField

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.returnKeyType = UIReturnKeyDone;
        self.delegate = (id<UITextFieldDelegate>)self;//   > iOS 8.0
        _JENumber_dotLimit = 2;
    }
    return self;
}


//添加边界 点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bouds = CGRectMake(self.bounds.origin.x - _moreTouchMargin.origin.x,
                              self.bounds.origin.y - _moreTouchMargin.origin.y,
                              self.bounds.size.width + _moreTouchMargin.size.width + _moreTouchMargin.origin.x,
                              self.bounds.size.height + _moreTouchMargin.size.height + _moreTouchMargin.origin.y);
    BOOL contain = CGRectContainsPoint(bouds,point);
    return contain;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.returnKeyType = UIReturnKeyDone;
    if (self.delegate == nil) {
        self.delegate = (id<UITextFieldDelegate>)self;//   > iOS 8.0
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , 8 , 0 );
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , 8 , 0 );
}


- (UILabel*)placeHolderLabel{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceHolderLabel:(UILabel *)placeHolderLabel{
    objc_setAssociatedObject(self, @selector(placeHolderLabel), placeHolderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addRightPlaceHolder:(NSString *)placeHolder{
    CGFloat W =  [placeHolder widthWithFont:[UIFont systemFontOfSize:12] height:20];
    
    UILabel *_ = [self placeHolderLabel];
    if (_ == nil) {
        _ = [[UILabel alloc] init];
        [self addSubview:_];
    }
    _.frame = CGRectMake(self.frame.size.width - W - 8,0, W, self.frame.size.height);
    _.text = placeHolder;
    _.textColor = [UIColor lightGrayColor];
    _.font =  [UIFont systemFontOfSize:12];
    [self setPlaceHolderLabel:_];

    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void)TextFieldChange{
    [self placeHolderLabel].hidden = self.text.length;
}




- (void)setIsTelePhone:(BOOL)isTelePhone{
    _isTelePhone = isTelePhone;
    self.keyboardType = UIKeyboardTypePhonePad;
}

- (void)setDivisions:(NSUInteger)divisions{
    _divisions = divisions;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

//纯数字形式的输入
- (void)setJENumber:(BOOL)JENumber{
    _JENumber = JENumber;
    self.keyboardType = UIKeyboardTypeNumberPad;
}
//数字形式的输入 可以有小数点 点后最多两位数
- (void)setJENumber_dot:(BOOL)JENumber_dot{
    _JENumber_dot = JENumber_dot;
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

//必须是 ASCII字符
- (void)setJEMust_ASCII:(BOOL)JEMust_ASCII{
    _JEMust_ASCII = JEMust_ASCII;
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

//必须是 字母和数字
- (void)setJEMust_AZ09:(BOOL)JEMust_AZ09{
    _JEMust_AZ09 = JEMust_AZ09;
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

//强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！) 加强判断 设另个为0
- (void)setJEMaxCharactersLength:(NSUInteger)JEMaxCharactersLength{
    _JEMaxCharactersLength = JEMaxCharactersLength;
    _JEMaxTextLength = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JETextFieldDidChange) name:UITextFieldTextDidChangeNotification object:self];
}

//强制按text.length长度计算限制文本的最大长度 加强判断  设另个为0
- (void)setJEMaxTextLength:(NSUInteger)JEMaxTextLength{
    _JEMaxTextLength = JEMaxTextLength;
    _JEMaxCharactersLength = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JETextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

//NSNotification
- (void)JETextFieldDidChange{
    if (_JEMaxCharactersLength) {
        if (self.markedTextRange == nil && [self.text textLength] > _JEMaxCharactersLength) {
            self.text = [self.text LimitMaxTextShow:_JEMaxCharactersLength];
        }
    }
    if (_JEMaxTextLength) {
        if (self.markedTextRange == nil && self.text.length > _JEMaxTextLength) {
            self.text = [self.text substringToIndex:_JEMaxTextLength];
        }
    }
}

- (NSRange)selectedRange{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

/** UITextField必须为第一响应者才有效 */
- (void)setSelectedRange:(NSRange)range{
    [self becomeFirstResponder];
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}


#pragma mark - textField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length >= 1) {
        return YES;
    }
    //电话号码
    if (_isTelePhone) {
        NSString *Mix = [textField.text addStr:string];
        if (Mix.delSpace.length > 11 || ![string isNumber] ) {
            return NO;
        }
        if (Mix.length == 3 || Mix.length == 8){
            textField.text = [Mix addStr:@" "];
            return NO;
        }
        return YES;
    }
    //数字
    if (_JENumber) {
        if (![string isNumber]) {
            return NO;
        }
    }
    //可以有小数点的 数字 小数点有判断
    if (_JENumber_dot) {
        if (![string isNumber] && ![string isEqualToString:@"."]) {
            return NO;
        }
        if ([string isEqualToString:@"."]) {
            if (textField.text.length == 0 || [textField.text rangeOfString:@"."].location != NSNotFound) {
                return NO;
            }
        }else{//输入数字
            NSUInteger at =  [textField.text rangeOfString:@"."].location;
            if (at != NSNotFound) {
                if (textField.text.length - at > _JENumber_dotLimit) {//点后最多两位数
                    return NO;
                }
            }
        }
        
    }
    if (_divisions) {
        NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
        NSMutableString *Mix = [NSMutableString stringWithString:[textField.text addStr:string].delSpace];
        if (Mix.delSpace.length > _JEMaxTextLength) {
            return NO;
        }else if (targetCursorPostion != textField.text.length ){
            Mix = [NSMutableString stringWithString:textField.text];
            [Mix insertString:string atIndex:targetCursorPostion];
            Mix = [NSMutableString stringWithString:Mix.delSpace];
            for (int i = 0 ; i<Mix.length; i++) {
                if (i%(_divisions + 1 )== 0) {
                    [Mix insertString:@" " atIndex:i];
                }
            }
            [textField setText:Mix];
            UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion + 1];
            [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
            return NO;
        }
        NSInteger which = _divisions;
        for (int i = 0 ; i<Mix.length; i++) {
            if (i == which) {
                [Mix insertString:@" " atIndex:i];
                which = _divisions*2 + 1;
            }
        }
        [textField setText:Mix];
        return NO;
    }
    
    if (_JEMaxTextLength && textField.text.length >= _JEMaxTextLength) {
        return NO;
    }
    
    if (_JEMaxCharactersLength && textField.text.textLength >= _JEMaxCharactersLength) {
        return NO;
    }

    
    if (_JEMust_AZ09 && ![string is_A_Z_0_9]) {
        return NO;
    }
    
    if (_JEMust_ASCII && ![string isASCII]) {
        return NO;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (UIView *)Ve_alpha{
    if (_Ve_alpha == nil) {
        CGRect bouds = CGRectMake(self.frame.origin.x - _moreTouchMargin.origin.x,
                                  self.frame.origin.y - _moreTouchMargin.origin.y,
                                  self.frame.size.width + _moreTouchMargin.size.width + _moreTouchMargin.origin.x,
                                  self.frame.size.height + _moreTouchMargin.size.height + _moreTouchMargin.origin.y);
        _Ve_alpha = [[UIButton alloc] initWithFrame:bouds];//UIButton 不至于点了可能取消响应
        [self.superview addSubview:(_Ve_alpha)];
    }
    return _Ve_alpha;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_noTouchInEditing) {
        [self.superview bringSubviewToFront:self.Ve_alpha];
        _Ve_alpha.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    !_didEndBlock ? : _didEndBlock(textField);
    _Ve_alpha.hidden = YES;
}


@end
