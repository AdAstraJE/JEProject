
#import "JETextField.h"
#import "JEKit.h"
//#import <objc/runtime.h>

static NSInteger const jkTextMargin = 8;///<

@interface JETextField ()

@property (nonatomic,strong) UIView *Ve_alpha;///< 编辑的时候不允许点击 覆盖个透明的view

@end

@implementation JETextField{
    UILabel *_La_rightPlaceHolder;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.delegate = (id<UITextFieldDelegate>)self;
    [self setup];
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.returnKeyType = UIReturnKeyDone;
    if (self.delegate == nil) {
        self.delegate = (id<UITextFieldDelegate>)self;
    }
    [self setup];
}

- (void)setup{
    self.returnKeyType = UIReturnKeyDone;
    _floatDotLimit = 2;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification) name:UITextFieldTextDidEndEditingNotification object:self];
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

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , jkTextMargin , 0 );
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , jkTextMargin , 0 );
}


#pragma mark -   set
- (void)setIsTelePhone:(BOOL)isTelePhone{
    _isTelePhone = isTelePhone;
    self.keyboardType = UIKeyboardTypePhonePad;
}

- (void)setDivisions:(NSUInteger)divisions{
    _divisions = divisions;
}

- (void)setNumberOnly:(BOOL)numberOnly{
    _numberOnly = numberOnly;
    self.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setFloatOnly:(BOOL)floatOnly{
    _floatOnly = floatOnly;
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setASCIIOnly:(BOOL)ASCIIOnly{
    _ASCIIOnly = ASCIIOnly;
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

- (void)setAZ09Only:(BOOL)AZ09Only{
    _AZ09Only = AZ09Only;
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

- (void)setJEMaxCharactersLength:(NSUInteger)JEMaxCharactersLength{
    _JEMaxCharactersLength = JEMaxCharactersLength;
    _JEMaxTextLength = 0;
}

- (void)setJEMaxTextLength:(NSUInteger)JEMaxTextLength{
    _JEMaxTextLength = JEMaxTextLength;
    _JEMaxCharactersLength = 0;
}

#pragma mark -   Notification
- (void)textFieldDidChangeNotification{
    if (_JEMaxCharactersLength) {
        if (self.markedTextRange == nil && [self.text textLength] > _JEMaxCharactersLength) {
            self.text = [self.text je_limitTo:_JEMaxCharactersLength];
        }
    }
    if (_JEMaxTextLength) {
        if (self.markedTextRange == nil && self.text.length > _JEMaxTextLength) {
            self.text = [self.text substringToIndex:_JEMaxTextLength];
        }
    }
    _La_rightPlaceHolder.hidden = self.text.length;
    
    !_didChangeBlock ? : _didChangeBlock(self);
}


- (void)addRightPlaceHolder:(NSString *)placeHolder{
    if (_La_rightPlaceHolder == nil) {
        _La_rightPlaceHolder= JELab(JR(0, 0, self.width - jkTextMargin, self.height),placeHolder,self.font,[UIColor lightGrayColor],(2),self);
    }
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

- (NSRange)selectedRange{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

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
    if (_numberOnly) {
        if (![string isNumber]) {
            return NO;
        }
    }
    //可以有小数点的 数字 小数点有判断
    if (_floatOnly) {
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
                if (textField.text.length - at > _floatDotLimit) {//点后最多两位数
                    return NO;
                }
            }
        }
        
    }
    if (_divisions) {
        NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
        NSMutableString *mix = [NSMutableString stringWithString:[textField.text addStr:string].delSpace];
        if (mix.delSpace.length > _JEMaxTextLength) {
            return NO;
        }else if (targetCursorPostion != textField.text.length ){
            mix = [NSMutableString stringWithString:textField.text];
            [mix insertString:string atIndex:targetCursorPostion];
            mix = [NSMutableString stringWithString:mix.delSpace];
            for (int i = 0 ; i<mix.length; i++) {
                if (i%(_divisions + 1 )== 0) {
                    [mix insertString:@" " atIndex:i];
                }
            }
            [textField setText:mix];
            UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion + 1];
            [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
            return NO;
        }
        NSInteger which = _divisions;
        for (int i = 0 ; i<mix.length; i++) {
            if (i == which) {
                [mix insertString:@" " atIndex:i];
                which = _divisions*2 + 1;
            }
        }
        [textField setText:mix];
        return NO;
    }
    
    if (_JEMaxTextLength && textField.text.length >= _JEMaxTextLength) {
        return NO;
    }
    
    if (_JEMaxCharactersLength && Format(@"%@%@",textField.text,string).textLength > _JEMaxCharactersLength) {
        return NO;
    }

    if (_AZ09Only && ![string is_A_Z_0_9]) {
        return NO;
    }
    
    if (_ASCIIOnly && ![string isASCII]) {
        return NO;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_disabelWhenEditing) {
        [self.superview bringSubviewToFront:self.Ve_alpha];
        _Ve_alpha.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    !_didEndBlock ? : _didEndBlock(textField);
    _Ve_alpha.hidden = YES;
}


@end
