
#import "JEScrIndexView.h"
#import "JEKit.h"

@interface JEScrIndexView ()<UIScrollViewDelegate>{
    NSMutableArray <JEButton *> *_Arr_titleSeeBtns;///< 视觉差标题Label
    NSInteger _currentIndex;
    NSArray <NSNumber *> *_Arr_selectClrRGBA;
    NSArray <NSNumber *> *_Arr_normalClrRGBA;
    NSArray <NSNumber *> *_Arr_gapClrRGBA;
    CGFloat _startContentOffsetX;
}

@property(nonatomic,strong,readonly) UIScrollView *Scr_title;///< 标题scrollview
@property(nonatomic,strong,readonly) UIView *Ve_board;///< 滑块
@property(nonatomic,strong,readonly) UIView *Ve_hide;///< 视觉差用

@end

@implementation JEScrIndexView

- (void)dealloc{
    jkDeallocLog
}

- (instancetype)initWithFrame:(CGRect)frame lazyLoadView:(LazyLoadBlock)block{
    self = [super initWithFrame:frame];
    _lazyLoadBlock = block;
    NSAssert(block != nil, @"");
    
    _Arr_btns = [NSMutableArray array];
    _Arr_titleSeeBtns = [NSMutableArray array];
    _Arr_view = [NSMutableArray array];
    _Arr_vc = [NSMutableArray array];
    
    _titleFont = [UIFont systemFontOfSize:15];
    self.tintColor = UIColor.systemBlueColor;
    self.normalTitleClr = UIColor.gray1;
    _scale = 0.28;
    
    _titleViewHeight = jkDefaultScrIndexTitleViewH;
    _sliderBoardPer = 0.618;
    _btnWidth = 0;
    _marginPer = 0.0;
    _advances = @[@(1)];
    
    return self;
}

#pragma mark - StyleDark 深色模式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    [self setTintColor:self.tintColor];
    [self setNormalTitleClr:_normalTitleClr];
    [self resetGapClrRGBA];
}

- (void)setTintColor:(UIColor *)tintColor{
    super.tintColor = tintColor;
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self.tintColor getRed:&r green:&g blue:&b alpha:&a];
    _Arr_selectClrRGBA = @[@(r),@(g),@(b),@(a)];
}

- (void)setNormalTitleClr:(UIColor *)normalTitleClr{
    _normalTitleClr = normalTitleClr;
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [_normalTitleClr getRed:&r green:&g blue:&b alpha:&a];
    _Arr_normalClrRGBA = @[@(r),@(g),@(b),@(a)];
}

- (void)resetGapClrRGBA{
    _Arr_gapClrRGBA = @[@(_Arr_selectClrRGBA[0].floatValue - _Arr_normalClrRGBA[0].floatValue),
                        @(_Arr_selectClrRGBA[1].floatValue - _Arr_normalClrRGBA[1].floatValue),
                        @(_Arr_selectClrRGBA[2].floatValue - _Arr_normalClrRGBA[2].floatValue),
                        @(_Arr_selectClrRGBA[3].floatValue - _Arr_normalClrRGBA[3].floatValue),
    ];
}

/// 设置样式后 再设置标题
- (void)loadTitles:(NSArray <NSString *>*)Arr_title{
    for (id obj in Arr_title) {
        [_Arr_view addObject:obj];
    }
    
    [self resetGapClrRGBA];

    //文本的
    _Scr_title = [[UIScrollView alloc]initWithFrame:CGRectMake(self.width*_marginPer,0,self.width*(1 -_marginPer*2),_titleViewHeight)].addTo(self);
    _Scr_title.scrollsToTop = NO;
    _Scr_title.showsHorizontalScrollIndicator = NO;
    _Scr_title.contentSize = CGSizeMake(_btnWidth*Arr_title.count, _Scr_title.frame.size.height);
    
    if (_btnWidth == 0) {
        _btnWidth = _Scr_title.width/Arr_title.count;
    }
    
    [Arr_title enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * stop) {
        JEButton *btn = JEBtn(JR(idx*_btnWidth, 0, _btnWidth,_Scr_title.height),title,_titleFont,nil,self,@selector(boardBtnClick:),nil,0,_Scr_title).tag_(idx + 1);
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.numberOfLines = 2;
        [btn setTitleColor:_normalTitleClr forState:UIControlStateNormal];
        [btn setTitleColor:self.tintColor forState:UIControlStateHighlighted];
        [self->_Arr_btns addObject:btn];
    }];
    
    _Ve_line = JEVe(JR(0, _Scr_title.bottom - 0.5, ScreenWidth, 0.5), (kHexColor(0xDADADA)), self);
    
    //滑块
    _Ve_board = JEVe(JR(0,0, _btnWidth, _Scr_title.height), [UIColor clearColor], _Scr_title);
    _Ve_board.layer.masksToBounds = YES;
    
    _Ve_boardLine = JEVe(JR((1-_sliderBoardPer)*_btnWidth/2 , _Scr_title.height - 2, _btnWidth*_sliderBoardPer, 2), self.tintColor, _Ve_board).rad_(1);
    _Ve_boardLine.rad = _Ve_boardLine.height/2;
    
    //视觉差用
    _Ve_hide = JEVe(JR(0, 0, _Ve_board.width, _Ve_board.height), nil, _Ve_board);
    [Arr_title enumerateObjectsUsingBlock:^(NSString *Title, NSUInteger idx, BOOL * stop) {
        JEButton *btn = JEBtn(JR(idx*self->_btnWidth, 0, _btnWidth,_Scr_title.height),Title,_titleFont,self.tintColor,nil,nil,nil,0,_Ve_hide);
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.numberOfLines = 2;
        [self->_Arr_titleSeeBtns addObject:btn];
    }];
     _Ve_hide.hidden = (_style == JEScrIndexViewStyleScale);
    
    //下面主要显示的
    UIScrollView *_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_Scr_title.bottom,self.width,self.height - _Scr_title.bottom)];
    _.delegate = self;
    _.pagingEnabled = YES;
    _.scrollsToTop = NO;
    _.contentSize = CGSizeMake(_.frame.size.width*Arr_title.count, _.frame.size.height);
    _.bounces = NO;
    _.showsHorizontalScrollIndicator = NO;
    _.delaysContentTouches = NO;
    [self addSubview:(_Scr_scroll_ = _)];
    
    for (int i = 0; i < _Arr_view.count; i++){
        UIView *eachV = _Arr_view[i];
        if ([eachV isKindOfClass:[UIView class]]) {
            eachV.frame = CGRectMake(_.frame.size.width *i, eachV.y, _.frame.size.width, _.frame.size.height);
            [_Scr_scroll_ addSubview:eachV];
        }
    }
    
    [self bringSubviewToFront:_Scr_title];
    [self sliderToIndex:0];
    
}

- (void)changeTitleAt:(NSInteger)index title:(NSString*)title{
    [_Arr_titleSeeBtns[index] setTitle:title forState:UIControlStateNormal];
    [_Arr_btns[index] setTitle:title forState:UIControlStateNormal];
}

#pragma mark - 头顶滑动的板块

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _currentIndex = ((_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width));
//    [self adjustScrTitleXWithIndex:(_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width) animated:YES];
    _startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    _currentIndex = ((_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width));
}

//停止滑动时 改变 某按钮的选中状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentIndex = ((_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width));
    if (_Arr_btns.count > _currentIndex) {
        [self boardBtnClick:[_Arr_btns objectAtIndex:_currentIndex]];
    }
    [self adjustScrTitleXWithIndex:(_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width) animated:YES];
}

- (void)scrollViewDidScroll:( UIScrollView *)scrollView{
    if (scrollView != _Scr_scroll_) {return;}
    
    _Ve_hide.x = - (_Ve_board.x = scrollView.contentOffset.x/(ScreenWidth/(_btnWidth)));
    
    _currentIndex = (_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width);
    if (_Scr_scroll_.contentOffset.x - _startContentOffsetX < 0) {_currentIndex += 1; }
    
    if (_style == JEScrIndexViewStyleScale) {
        JEButton *left = _currentIndex >= 1 ? _Arr_btns[_currentIndex - 1] : nil;
        JEButton *current = _Arr_btns[_currentIndex];
        
        JEButton *right = ((_currentIndex + 1 ) < _Arr_btns.count ? _Arr_btns[_currentIndex + 1] : nil);
        JEButton *effect;
        if (right == nil) { effect = left;}else if (left == nil) { effect = right;}
        else{
            effect = fabs(_Ve_board.x - left.x) < fabs(right.x - _Ve_board.x) ? left : right;
        }
        CGFloat gap = fabs(_Ve_board.centerX - effect.centerX);
        CGFloat change = gap/_btnWidth;
        current.transform = CGAffineTransformMakeScale(1 + change*_scale,1 + change*_scale);
        effect.transform = CGAffineTransformMakeScale(1 + (1 - change)*_scale,1 + (1 - change)*_scale);
        
        UIColor *tintClr = [UIColor
                            colorWithRed:((_Arr_selectClrRGBA[0].floatValue - _Arr_gapClrRGBA[0].floatValue*change))
                            green:((_Arr_selectClrRGBA[1].floatValue - _Arr_gapClrRGBA[1].floatValue*change))
                            blue:((_Arr_selectClrRGBA[2].floatValue - _Arr_gapClrRGBA[2].floatValue*change)) alpha:((_Arr_selectClrRGBA[3].floatValue - _Arr_gapClrRGBA[3].floatValue*change))];
        
        [effect setTitleColor:tintClr forState:(UIControlStateNormal)];
        
        UIColor *norClr = [UIColor
                           colorWithRed:((_Arr_selectClrRGBA[0].floatValue - _Arr_gapClrRGBA[0].floatValue*(1 - change)))
                           green:((_Arr_selectClrRGBA[1].floatValue - _Arr_gapClrRGBA[1].floatValue*(1 - change)))
                           blue:((_Arr_selectClrRGBA[2].floatValue - _Arr_gapClrRGBA[2].floatValue*(1 - change)))
                           alpha:((_Arr_selectClrRGBA[3].floatValue - _Arr_gapClrRGBA[3].floatValue*(1 - change)))];
        [current setTitleColor:norClr forState:(UIControlStateNormal)];
    }
}


#pragma mark -

/// 滑到指定位置  0 1 2 3 4 
- (UIView*)sliderToIndex:(NSInteger)index{
    if (_Arr_btns.count > index) {
        [self boardBtnClick:_Arr_btns[index]];
        return _Arr_view[index];
    }
    return nil;
}

//滑块的按钮点击
- (void)boardBtnClick:(JEButton*)sender{
    _currentIndex = [_Arr_btns indexOfObject:sender];
    !_indexChangeBlock ? : _indexChangeBlock(_currentIndex);
    
    for (int i = 0; i < _Arr_btns.count; i++) {//重置按钮状态
        JEButton *_ = _Arr_btns[i];
        _.userInteractionEnabled = YES;
        _.transform = CGAffineTransformIdentity;
        [_ setTitleColor:_normalTitleClr forState:UIControlStateNormal];
    }
    
    if (_style == JEScrIndexViewStyleScale) {
        sender.transform = CGAffineTransformMakeScale(1 + 1*_scale,1 + 1*_scale);
        [sender setTitleColor:self.tintColor forState:UIControlStateNormal];
    }

    [self getViewFromIndex:_currentIndex];
    
    if (_advances) {
        [_advances enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self getViewFromIndex:_currentIndex + obj.integerValue];
        }];
    }
    
    [_Scr_scroll_ scrollRectToVisible:CGRectMake((_currentIndex)*_Scr_scroll_.frame.size.width,0, _Scr_scroll_.frame.size.width, _Scr_scroll_.frame.size.height) animated:NO];
    [self adjustScrTitleXWithIndex:_currentIndex animated:YES];
    
}

- (UIView *)getViewFromIndex:(NSInteger)index{
    if (index >= _Arr_view.count || index < 0) {
        return nil;
    }
    UIView *eachView = _Arr_view[index];
    if (![eachView isKindOfClass:[UIView class]]) {
        UIViewController *eachVC = _lazyLoadBlock(index);
        [self.superVC addChildViewController:eachVC];
        [_Arr_vc addObject:eachVC];
        
        eachView = eachVC.view;
        eachView.frame = CGRectMake(_Scr_scroll_.frame.size.width *index, eachView.y, _Scr_scroll_.frame.size.width, _Scr_scroll_.frame.size.height);
        [_Scr_scroll_ addSubview:eachVC.view];
        _Scr_scroll_.backgroundColor = eachView.backgroundColor;
        [_Arr_view replaceObjectAtIndex:index withObject:eachView];
    }
    return eachView;
}

- (void)adjustScrTitleXWithIndex:(NSInteger)index animated:(BOOL)animated{
    if (_Arr_btns.count <= index) {
        return;
    }
    if (_Arr_btns.count*_btnWidth < ScreenWidth) {
        return;
    }
    
    CGFloat scr_titleW = _Scr_title.width;
    if (_btnWidth*_Arr_view.count > _Scr_title.width && _Arr_btns[index].x > (_Scr_title.contentOffset.x + scr_titleW - _btnWidth) - _btnWidth*2) {
        CGFloat toX = _Scr_title.contentOffset.x + (_Arr_btns[index].x - (_Scr_title.contentOffset.x + scr_titleW - _btnWidth) + _btnWidth*2);
        [_Scr_title setContentOffset:CGPointMake(toX > (_Scr_title.contentSize.width - scr_titleW) ? (_Scr_title.contentSize.width - scr_titleW) : toX, 0) animated:animated];
    }
    
    if (_Scr_title.contentOffset.x > _Arr_btns[index].x - _btnWidth*2) {
        CGFloat toX = _Arr_btns[index].x - _btnWidth*2;
        [_Scr_title setContentOffset:CGPointMake(toX > 0 ? toX : 0, 0) animated:animated];
    }
}

@end
