
#import "JETableView.h"
#import "JEKit.h"

@implementation JETableView{
    __weak UIImageView *_Img_expand;
    CGFloat _expandOrginHeight;
}

- (void)dealloc{
    jkDeallocLog
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    [self defaultConfigure];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self defaultConfigure];
    return self;
}

/** 修改有点击效果 */
- (void)defaultConfigure{
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _headExpandEffect = NO;
    
    if (@available(iOS 11.0, *)) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    
    self.delaysContentTouches = NO;
    if (JEShare.tvBgClr) { self.backgroundColor = JEShare.tvBgClr; }
    if (JEShare.tvSepClr) { self.separatorColor = JEShare.tvSepClr; }
    [self handelStyleDark];
}

- (void)setJeSeparatorColor:(UIColor *)jeSeparatorColor{
    _jeSeparatorColor = jeSeparatorColor;
    self.separatorColor = jeSeparatorColor;
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    [self handelStyleDark];
}

/// 手指点在按钮上 依然可以滑动
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (void)setHeadExpandEffect:(BOOL)headExpandEffect{
    _headExpandEffect = headExpandEffect;
    if (headExpandEffect) {
        [self.tableHeaderView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]] && CGRectEqualToRect(obj.bounds, self.tableHeaderView.bounds)) {
                self->_Img_expand = obj;self->_expandOrginHeight = self.tableHeaderView.height;*stop = YES;
            }
        }];
    }
}

- (void)expandEffectView:(UIImageView *)imgv{
    _headExpandEffect = YES;
    _expandOrginHeight = imgv.height;
    _Img_expand = imgv;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_headExpandEffect && _Img_expand) {
        CGFloat y = scrollView.contentOffset.y + self.contentInset.top;
        CGRect orginRect = CGRectMake(0, 0, ScreenWidth, _expandOrginHeight);
        if (y < 0) {
            _Img_expand.frame = CGRectMake((ScreenWidth - (orginRect.size.width - y))/2,y, orginRect.size.width - y, orginRect.size.height - y);
        }else{
            _Img_expand.frame = orginRect;
        }
    }
}

#pragma mark -   dark
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self handelStyleDark];
}

- (void)handelStyleDark{
    BOOL dark = NO;
    if (@available(iOS 13.0, *)) {dark = (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);}
    if (dark) {
        self.separatorColor = kRGBA(84, 84, 89, 0.6);
    }else{
        self.separatorColor = _jeSeparatorColor ? : JEShare.tvSepClr;
    }

    if (JEShare.tvBgClr) {
        self.backgroundColor = dark ? (UIColor.clearColor ? : UIColor.blackColor) : JEShare.tvBgClr;
    }
    
}

@end
