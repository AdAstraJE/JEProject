
#import "UIScrollView+JE.h"
#import <objc/runtime.h>
#import "JEKit.h"
#import "JERefreshHeader.h"
#import "JERefreshFooter.h"

@implementation UIScrollView (JE)

//*< UIScrollView 和侧滑返回的冲突问题  有 UIScrollView时没有全屏侧滑返回，但至少有边界的侧滑返回！
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[FDPanGestureRecognizer class]] && ([otherGestureRecognizer locationInView:otherGestureRecognizer.view].x < QTZAllowedInitialDistanceToLeftEdge )) {
        return YES;
    }
    else{
        return  NO;
    }
}

/** 默认基础数据源 */
- (NSMutableArray *)Arr{
    NSMutableArray *defaultArray = objc_getAssociatedObject(self, _cmd);
    if (defaultArray == nil) {
        [self setArr:(defaultArray = [[NSMutableArray alloc] init])];
    }
    return defaultArray;
}

- (void)setArr:(NSMutableArray *)Arr{
    objc_setAssociatedObject(self, @selector(Arr), Arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** tableview 默认ActView */
- (UIActivityIndicatorView *)ActView{
    UIActivityIndicatorView *act = objc_getAssociatedObject(self, _cmd);
    if (act == nil) {
        [self setActView:(act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray])];
    }
    return act;
}

- (void)setActView:(UIActivityIndicatorView *)ActView{
    objc_setAssociatedObject(self, @selector(ActView), ActView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/** storyboard 静态tableview 加载 */
- (void)staticLoading{
    if (![self isKindOfClass:UITableView.class]) { return;}
    
//    [self layoutIfNeeded];
    [self.ActView startAnimating];
    ((UITableView*)self).backgroundView = self.ActView;
    for (UITableViewCell *cell in ((UITableView*)self).visibleCells) { cell.hidden = YES;}
}

/** storyboard 静态tableview 停止加载 */
- (void)staticStopLoading{
    if (![self isKindOfClass:UITableView.class]) { return;}
    
    [self.ActView stopAnimating];
    ((UITableView*)self).backgroundView = nil;
    for (UITableViewCell *cell in ((UITableView*)self).visibleCells) { cell.hidden = NO;}
}

#pragma mark - 空数据时的展示

- (NSInteger)emptyeInfo:(NSString*)title image:(id)image{
    return [self emptyeInfo:title image:image count:self.Arr.count];
}

- (NSInteger)emptyeInfo:(NSString*)title image:(id)image count:(NSInteger)count{
    if (count != 0) {
        ((UITableView*)self).backgroundView = nil;//有数据了 这个view 滞空
        [(JERefreshFooter*)self.mj_footer setTitle:@"没有更多啦~".loc.del(@"~") forState:MJRefreshStateNoMoreData];
        return count;
    }
    
    //网络请求失败的 没有缓存的 显示的点击加载什么的 需和MJrefresh的匹配
    if (self.mj_header && ((JERefreshHeader*)self.mj_header).JENetworkingFail && count == 0) {
        ((UITableView*)self).backgroundView = [self networkingFailViewWithTarget:self action:@selector(networkingFailRelaodClick)];
        return count;
    }
    
    if (((UITableView*)self).backgroundView != nil) {//有自己定义的view或已经存在
        return count;
    }
    
    ((UITableView*)self).backgroundView = [self customInfo:title image:image];
    [(JERefreshFooter*)self.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    return count;
}

/** 自己定义的没有数据时显示的 视图 */
- (UIView*)customInfo:(NSString*)title image:(id)image{
    [self layoutIfNeeded];
    UIView *header;
    if ([self isKindOfClass:UITableView.class]) { header = ((UITableView*)self).tableHeaderView;}
    CGFloat contantY = header.height;
    CGFloat contatnH = self.height - contantY;
    
    UIView *ve = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    UIImageView *imageV;
    if (image) {
        UIImage *img = image;
        if ([image isKindOfClass:[NSString class]]) {
            img = [UIImage imageNamed:image] ? : [UIImage imageNamed:JEResource(image)] ;
        }
        CGSize size = [img je_reSetMaxWH:ve.width*0.618];//不知道你放的图片的大小 只是限制最大比例屏占比
        imageV = [UIImageView F:CGRectMake((ve.width - size.width)/2,contantY + contatnH/2 - size.height, size.width, size.height) image:img].addTo(ve);
    }
    
    if (title != nil && title.length == 0) {  title = @"无相关数据~".loc;}
    
    [UILabel Frame:CGRectMake(0,imageV ? (imageV.bottom + 20) : (contantY + contatnH*0.4),ve.width, [title heightWithFont:font(14) width:ve.width]) text:title font:@14 color:kColorText66 align:NSTextAlignmentCenter].addTo(ve);
    
    return ve;
}

/** 网络请求失败时显示的   */
- (UIView*)networkingFailViewWithTarget:(id)target action:(SEL)action{
    [self layoutIfNeeded];
    
    UIView *Ve = [self customInfo:(@"网络异常 >_<，请稍后再试").loc image:@"NetWorkerror.png"];
    [Ve.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull La, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([La isKindOfClass:[UILabel class]]) {
            UIButton *btn = [UIButton Frame:CGRectMake((self.width - 100)/2, La.bottom + 20, 100, 30) title:@"重新加载".loc font:font(14) color:kColorText66 rad:5 tar:target sel:action img:[UIColor whiteColor]];
            [btn je_addImgByRadius:btn.height/2 color:(kHexColor(0xDDDDDD)) lineWidth:1];
            [Ve addSubview:btn];
            *stop = YES;
        }
    }];
    
    return Ve;
}

- (void)networkingFailRelaodClick{
    ((UITableView*)self).backgroundView = nil;
    [self.mj_header beginRefreshing];
}


#pragma mark - 列表管理工具

- (void)setListManager:(JEListManager *)ListManager{
    objc_setAssociatedObject(self, @selector(ListManager), ListManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JEListManager *)ListManager{
    return  objc_getAssociatedObject(self, _cmd);
}

/** 列表管理的 */
- (void)listManager:(NSString*)API param:(NSDictionary*)param pages:(BOOL)havePage mod:(Class)modclass superVC:(UIViewController*)superVC caChe:(NSString*)caChe suc:(JEListNetSucBlcok)success fail:(JEListNetFailureBlock)fail method:(AFHttpMethod)method{
    JEListManager *manager = [[JEListManager alloc] initWithAPI:API param:param pages:havePage Tv:self Arr:self.Arr VC:superVC modClass:modclass cacheKey:caChe method:method suc:success fail:fail];
    [self setListManager:manager];
    [manager startNetworking];
}



@end

