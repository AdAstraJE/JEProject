
#import "JERefreshFooter.h"
#import "JEKit.h"
#import "MJRefresh.h"

@interface JERefreshFooter()

@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation JERefreshFooter
- (UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    [self setTitle:@"上拉加载更多~".loc forState:MJRefreshStateIdle];
    [self setTitle:@"" forState:MJRefreshStateRefreshing];
//    [self setTitle:@"" forState:MJRefreshStateNoMoreData];
    [self setTitle:@"—————————— • ——————————" forState:MJRefreshStateNoMoreData];
    self.stateLabel.font = font(12);
    self.stateLabel.textColor = kColorText99;
}

- (void)placeSubviews{
    [super placeSubviews];
    self.loadingView.center = CGPointMake(ScreenWidth/2, self.stateLabel.mj_textWidth * 0.5 + self.labelLeftInset);
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}
@end
