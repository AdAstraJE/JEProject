
#import "JEBaseBackView.h"
#import "JEKit.h"

const static CGFloat kAnimateDuration  = 0.25;///< 动画时间
#define kViewMargin (ScreenWidth *0.11)

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @implementation JEBaseBackView   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEBaseBackView

- (void)dealloc{ jkDeallocLog}

+ (instancetype)Show{
    JEBaseBackView *view = [[[self class] alloc] initWithFrame:JEApp.window.bounds];
    [JEApp.window addSubview:view];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame contentHieht:(CGFloat)height{
    self = [super initWithFrame:frame];
    self.alpha = 0;
    self.backgroundColor = kRGBA(0, 0, 0, 0.4);
    
    _backView = [[UIView alloc] initWithFrame:self.bounds].addTo(self);//隐藏的点击背景
    
    //仿系统alertview 视图
    _Ve_content = [UIView Frame:CGRectMake(kViewMargin, (ScreenHeight - height)/2, ScreenWidth - kViewMargin*2, height) color:kRGBA(255, 255, 255, 1)].addTo(self);
    _Ve_content.rad = 12;
    _maskView = [UIView Frame:_Ve_content.bounds color:kRGBA(255, 255, 255, 0.8)].addTo(_Ve_content);
    
    return self;
}

- (void)resetWidth:(CGFloat)widht{
    _Ve_content.frame = CGRectMake((ScreenWidth - widht)/2, _Ve_content.y, widht, _Ve_content.height);
    _maskView.frame = _Ve_content.bounds;
}

- (void)setPopType:(JEPopType)popType{
    _popType = popType;
    if (_popType == JEPopTypeBottom) {
        _Ve_content.rad = 0;
        _Ve_content.height += ScreenSafeArea;
        _Ve_content.frame = CGRectMake(0, ScreenHeight, ScreenWidth, _Ve_content.height);
        _maskView.frame = _Ve_content.bounds;
    }else{
        _Ve_content.y = (ScreenHeight - _Ve_content.height)/2;
    }
}

- (void)setTapToDismiss:(BOOL)tapToDismiss{
    _tapToDismiss = tapToDismiss;
    tapToDismiss ? [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]] : [_backView removeGestureRecognizer:_backView.gestureRecognizers.firstObject];
}

/** 显示 */
- (void)show{
    NSAssert(_Ve_content != nil, @"");
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 1;
        if (self -> _popType == JEPopTypeBottom) { self->_Ve_content.y = (self->_Ve_content.y - self->_Ve_content.height);}
    }];
}

/** 隐藏 销毁 */
- (void)dismiss{
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 0;
        if (self -> _popType == JEPopTypeBottom) { self -> _Ve_content.y = ScreenHeight;}
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  举个例子   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame contentHieht:140];
    //    self.popType = JEPopTypeBottom;
    //    self.tapToDismiss = YES;
    
    [self.Ve_content addSubview:[UILabel Frame:CGRectMake(0, 19, self.Ve_content.width, 22) text:@"Alert" font:fontB(17) color:kColorText33 align:NSTextAlignmentCenter]];;
    [self.Ve_content addSubview:[UILabel Frame:CGRectMake(0, 42, self.Ve_content.width, 32) text:@"Here is a message where we can put absolutely anything we want." font:fontB(13) color:kColorText33 align:NSTextAlignmentCenter]];;
    
    
    CGFloat btnHeight = 44;
    [self.Ve_content addSubview:({
        
        UIButton *_ = [UIButton Frame:CGRectMake(0, self.Ve_content.height - btnHeight, self.Ve_content.width/2,btnHeight) title:@"取消" font:fontM(17) color:kHexColor(0x007AFF) rad:0 tar:self sel:@selector(test) img:nil];
        _.bcImg_h = kRGBA(235, 235, 235, 0.8);_;
    })];
    [self.Ve_content addSubview:({
        UIButton *_ = [UIButton Frame:CGRectMake(self.Ve_content.width/2, self.Ve_content.height - btnHeight, self.Ve_content.width/2,btnHeight) title:@"确认" font:font(17) color:kHexColor(0x007AFF) rad:0 tar:self sel:@selector(test) img:nil];
        _.bcImg_h = kRGBA(235, 235, 235, 0.8);_;
    })];
    
    
    [self.Ve_content addSubview:[UIView Frame:CGRectMake(0, self.Ve_content.height - btnHeight - 0.5, self.Ve_content.width, 0.5) color:kRGBA(187, 188, 189, 0.65)]];
    [self.Ve_content addSubview:[UIView Frame:CGRectMake(self.Ve_content.width/2, self.Ve_content.height - btnHeight - 0.5, 0.5, btnHeight) color:kRGBA(187, 188, 189, 0.65)]];
    
    [self show];
    
    return self;
}


- (void)test{
    [self dismiss];
    [JEKit ShowAlert:@"Alert" msg:@"Here is a message where we can put absolutely anything we want." style:UIAlertControllerStyleAlert block:^(NSString *actions, NSInteger index) {
        [self dismiss];
        
    } cancel:@"取消" actions:@[@"确认"] destructive:nil];
}


@end
