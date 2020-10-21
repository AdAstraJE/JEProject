
#import "JENumberAnimateLabel.h"

static CGFloat const jkAnimateDuration = 0.35;///<
static CGFloat const jkTimerDuration = 0.02;///<

@implementation JENumberAnimateLabel{
    NSTimer *_timer;
    NSNumber *_tureNumber;
    NSNumber *_fromNumber;
    NSInteger _process;
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
    eachAdd = MAX(_fromNumber.floatValue*0.05, eachAdd);
    _process += eachAdd;
    if (_process <= 0) {_process = 0;}
    if (_process >= _tureNumber.integerValue) {
        _process = _tureNumber.integerValue;
        [_timer invalidate];_timer = nil;
    }
    
    self.text = @(_process).stringValue;
}

@end
