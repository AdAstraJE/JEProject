
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

- (void)defaultConfigure{
    if(JEShare.tvBgClr){ self.backgroundColor = JEShare.tvBgClr;}
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

@end
