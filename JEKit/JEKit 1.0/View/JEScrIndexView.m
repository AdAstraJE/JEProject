
#import "JEScrIndexView.h"
#import "JEKit.h"

@interface JEScrIndexView ()<UIScrollViewDelegate>{
    NSMutableArray <UIButton*> *_Arr_btns;/**< 按钮 */
    NSMutableArray <UIButton*> *_Arr_titleSeeBtns;/**< 视觉差标题Label */
}

@property(nonatomic,strong,readonly) UIScrollView *Scr_title;/**< 标题scrollview */
@property(nonatomic,strong,readonly) UIView *Ve_board;/**< 滑块 */
@property(nonatomic,strong,readonly) UIView *Ve_hide;/**< 视觉差用 */

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
    
    _titleFont = [UIFont systemFontOfSize:17];
    _tintColore = (kHexColor(0x4DA6F0));
    _titleColore = (kHexColor(0x222222));
    
    _titleViewHeight = jkDefaultScrIndexTitleViewH;
    _sliderBoardPer = 0.6;
    _btnWidth = 60;
    _marginPer = 0.0;
    
    return self;
}

/** 设置样式后 再设置标题 */
- (void)loadTitles:(NSArray <NSString *>*)Arr_title{
    for (id obj in Arr_title) {
        [_Arr_view addObject:obj];
    }

    //文本的
    UIScrollView *titleScr = [[UIScrollView alloc]initWithFrame:CGRectMake(self.width*_marginPer,0,self.width*(1 -_marginPer*2),_titleViewHeight)];
    titleScr.scrollsToTop = NO;titleScr.showsHorizontalScrollIndicator = NO;
    titleScr.contentSize = CGSizeMake(_btnWidth*Arr_title.count, titleScr.frame.size.height);
    [self addSubview:_Scr_title = titleScr];
    
    if (_btnWidth == 0) {
        _btnWidth = titleScr.width/Arr_title.count;
    }
    
    [Arr_title enumerateObjectsUsingBlock:^(NSString *Title, NSUInteger idx, BOOL * stop) {
        UIButton *JBtn = [UIButton Frame:CGRectMake(idx*self->_btnWidth, 0, self->_btnWidth,self->_Scr_title.height) title:Title font:self->_titleFont color:nil rad:0 tar:self sel:@selector(Ve_BotBoard_BtnClick:) img:nil];
        JBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        JBtn.tag = idx + 1;
        [JBtn setTitleColor:self->_titleColore forState:UIControlStateNormal];
        [JBtn setTitleColor:self->_tintColore forState:UIControlStateHighlighted];
        
        [self->_Scr_title addSubview:JBtn];
        [self->_Arr_btns addObject:JBtn];
    }];
    
    [self addSubview:_Ve_line = [UIView Frame:CGRectMake(0, titleScr.bottom - 0.5, ScreenWidth, 0.5) color:(kHexColor(0xDADADA))]];
    
    //滑块
    _Ve_board = [UIView Frame:CGRectMake(0,0, _btnWidth, _Scr_title.height) color:[UIColor clearColor]];
    _Ve_board.layer.masksToBounds = YES;
    
    _Ve_boardLine = [UIView Frame:CGRectMake((1-_sliderBoardPer)*_btnWidth/2 , _Scr_title.height - 2, _btnWidth*_sliderBoardPer, 2) color:_tintColore];
    _Ve_boardLine.rad = _Ve_boardLine.height/2;
    [_Ve_board addSubview:_Ve_boardLine];
    
    //视觉差用
    _Ve_hide = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _Ve_board.width, _Ve_board.height)];
    [Arr_title enumerateObjectsUsingBlock:^(NSString *Title, NSUInteger idx, BOOL * stop) {
        UIButton *JBtn = [UIButton Frame:CGRectMake(idx*self->_btnWidth, 0, self->_btnWidth,self->_Scr_title.height) title:Title font:self->_Arr_btns.firstObject.titleLabel.font color:self->_tintColore rad:0 tar:nil sel:nil img:nil];
        JBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self->_Ve_hide addSubview:JBtn];
        [self->_Arr_titleSeeBtns addObject:JBtn];
    }];
    
    [_Ve_board addSubview:_Ve_hide];
    [_Scr_title addSubview:_Ve_board];
    
    //下面主要显示的
    UIScrollView *_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0,titleScr.bottom,self.width,self.height - titleScr.bottom)];
    _.delegate = self;_.pagingEnabled = YES;
    _.scrollsToTop = NO;
    _.contentSize = CGSizeMake(_.frame.size.width*Arr_title.count, _.frame.size.height);
    _.bounces = NO;
    _.showsHorizontalScrollIndicator = NO;
    _.delaysContentTouches = NO;
    [self addSubview:_Scr_scroll_ = _];
    
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
- (void)scrollViewDidScroll:( UIScrollView *)scrollView{
    if (scrollView == _Scr_scroll_) {
        _Ve_hide.x = - (_Ve_board.x = scrollView.contentOffset.x/(ScreenWidth/(_btnWidth)));
    }
}

//停止滑动时 改变 某按钮的选中状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = ((_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width));
    if (_Arr_btns.count > index) {
        [self Ve_BotBoard_BtnClick:[_Arr_btns objectAtIndex:index]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self adjustScrTitleXWithIndex:(_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width) animated:YES];
}

/** 滑到指定位置  0 1 2 3 4 */
- (UIView*)sliderToIndex:(NSInteger)index{
    if (_Arr_btns.count > index) {
        [self Ve_BotBoard_BtnClick:_Arr_btns[index]];
        return _Arr_view[index];
    }
    return nil;
}

//滑块的按钮点击
- (void)Ve_BotBoard_BtnClick:(UIButton*)sender{
    if (sender.isSelected) {return;}
    NSInteger index = 0;
    for (int i = 0; i < _Arr_btns.count; i++) {//重置按钮状态
        UIButton *Btn = _Arr_btns[i];
        if (sender == Btn) { index = i;}
        Btn.selected = NO;
        Btn.userInteractionEnabled = YES;
    }
    sender.selected = YES;
    
    [self getViewFromIndex:index];
    
    if (_advances) {
        [_advances enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self getViewFromIndex:index + obj.integerValue];
        }];
    }
    
    [_Scr_scroll_ scrollRectToVisible:CGRectMake((index)*_Scr_scroll_.frame.size.width,0, _Scr_scroll_.frame.size.width, _Scr_scroll_.frame.size.height) animated:NO];
    [self adjustScrTitleXWithIndex:index animated:YES];
    
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
    
    CGFloat Scr_titleW = _Scr_title.width;
    if (_Arr_btns[index].x > (_Scr_title.contentOffset.x + Scr_titleW - _btnWidth) - _btnWidth*2) {
        CGFloat toX = _Scr_title.contentOffset.x + (_Arr_btns[index].x - (_Scr_title.contentOffset.x + Scr_titleW - _btnWidth) + _btnWidth*2);
        [_Scr_title setContentOffset:CGPointMake(toX > (_Scr_title.contentSize.width - Scr_titleW) ? (_Scr_title.contentSize.width - Scr_titleW) : toX, 0) animated:animated];
    }
    
    if (_Scr_title.contentOffset.x > _Arr_btns[index].x - _btnWidth*2) {
        CGFloat toX = _Arr_btns[index].x - _btnWidth*2;
        [_Scr_title setContentOffset:CGPointMake(toX > 0 ? toX : 0, 0) animated:animated];
    }
}

@end
