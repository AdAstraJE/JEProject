
#import "JENumberAnimateLabel.h"

static CGFloat const jkAnimateDuration = 0.35;///<
static CGFloat const jkTimerDuration = 0.025;///<

@implementation JENumberAnimateLabel{
    NSNumber *_tureNumber;
    NSNumber *_fromNumber;
    NSTimer *_timer;
    NSInteger _process;
    NSString *_unit_str;
    UIFont *_unit_font;
    UIColor *_unit_clr;
}

- (void)showAnimateNumber:(NSNumber *)number{
    _fromNumber = _tureNumber;
    if (_fromNumber == nil) {_fromNumber = @(self.text.integerValue);}
    _tureNumber = number;
    if (_timer) {
        self.text = _tureNumber.stringValue;
        [_timer invalidate];_timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:jkTimerDuration target:self selector:@selector(numberAnimate) userInfo:nil repeats:YES];
}

- (void)numberAnimate{
    CGFloat eachAdd = ((_tureNumber.floatValue - _fromNumber.floatValue)*jkTimerDuration/jkAnimateDuration)*((float)(8+arc4random_uniform(5))/10.f)+arc4random_uniform(10);
    eachAdd = MAX(_fromNumber.floatValue*0.05*(eachAdd < 1 ? -1 : 1), eachAdd);
    _process += eachAdd;
    if (_process <= 0) {_process = 0;}
    
    if ((eachAdd > 1 && _process >= _tureNumber.integerValue) || (eachAdd < 1 && _process <= _tureNumber.integerValue)) {
        _process = _tureNumber.integerValue;
        [_timer invalidate];_timer = nil;
    }
    
    NSString *string = @(_process).stringValue;
    if (_unit_str.length) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",string,_unit_str]];
        NSRange range = NSMakeRange(string.length, _unit_str.length);
        if (_unit_font) { [attribute addAttributes:@{NSFontAttributeName : _unit_font} range:range];}
        if (_unit_clr) { [attribute addAttributes:@{NSForegroundColorAttributeName : _unit_clr} range:range];}
        [self setAttributedText:attribute];
    }else{
        self.text = string;
    }
    
}

- (void)suffixUnit:(NSString *)unit font:(UIFont *)font clr:(UIColor *)clr{
    _unit_str = unit;_unit_font = font;_unit_clr = clr;
}

@end
