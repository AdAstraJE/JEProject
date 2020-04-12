
#import "UIScrollView+JE.h"
#import <objc/runtime.h>
#import "JEKit.h"
#import "JERefreshHeader.h"
#import "JERefreshFooter.h"

@implementation UIScrollView (JE)

- (CGFloat)contentInsetTop{return self.contentInset.top;}
- (CGFloat)contentInsetLeft{return self.contentInset.left;}
- (CGFloat)contentInsetBottom{return self.contentInset.bottom;}
- (CGFloat)contentInsetRight{return self.contentInset.right;}

- (void)setContentInsetTop:(CGFloat)contentInsetTop{
    self.contentInset = UIEdgeInsetsMake(contentInsetTop, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
}

- (void)setContentInsetLeft:(CGFloat)contentInsetLeft{
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, contentInsetLeft, self.contentInset.bottom, self.contentInset.right);
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom{
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, contentInsetBottom, self.contentInset.right);
}

- (void)setContentInsetRight:(CGFloat)contentInsetRight{
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom, contentInsetRight);
}

/// UIScrollView 处理和侧滑返回的冲突问题,  有UIScrollView时没有全屏侧滑返回，但至少有边界的侧滑返回
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[FDPanGestureRecognizer class]] && ([otherGestureRecognizer locationInView:otherGestureRecognizer.view].x < QTZAllowedInitialDistanceToLeftEdge )) {
        return YES;
    }
    else{
        return  NO;
    }
}

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

- (void)staticLoading{
    if (![self isKindOfClass:UITableView.class]) { return;}
    
//    [self layoutIfNeeded];
    [self.ActView startAnimating];
    ((UITableView*)self).backgroundView = self.ActView;
    for (UITableViewCell *cell in ((UITableView*)self).visibleCells) { cell.hidden = YES;}
}

- (void)staticStopLoading{
    if (![self isKindOfClass:UITableView.class]) { return;}
    if (!self.ActView.isAnimating) {return;}
    
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
        ((UITableView*)self).backgroundView = nil;//有数据了 这个view 置空
        [(JERefreshFooter*)self.mj_footer setTitle:@"——————————   END   ——————————".loc forState:MJRefreshStateNoMoreData];
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

/// 自己定义的没有数据时显示的 视图 
- (UIView*)customInfo:(NSString*)title image:(id)image{
    [self layoutIfNeeded];
    UIView *header;
    if ([self isKindOfClass:UITableView.class]) { header = ((UITableView*)self).tableHeaderView;}
    CGFloat contantY = header.height;
    CGFloat contatnH = self.height - contantY;
    
    UIView *ve = JEVe(JR(0, 0, self.width, self.height), nil, nil);
    UIImageView *imageV;
    if (image) {
        UIImage *img = image;
        if ([image isKindOfClass:[NSString class]]) {
            img = [UIImage imageNamed:image] ? : JEBundleImg(image);
        }
        img = [img je_limitToWH:ve.width*0.618];
        CGSize size = img.size;//不知道你放的图片的大小 只是限制最大比例屏占比
        imageV = JEImg(JR((ve.width - size.width)/2,contantY + contatnH/2 - size.height, size.width, size.height),img,ve);
    }
    
    if (title != nil && title.length == 0) {  title = @"暂无数据".loc;}
    JELab(JR(0,imageV ? (imageV.bottom + 15) : (contantY + contatnH*0.4),ve.width, [title heightWithFont:font(14) width:ve.width]),title,@14,Tgray1,(1),ve);
    
    return ve;
}

- (UIView*)networkingFailViewWithTarget:(id)target action:(SEL)action{
    [self layoutIfNeeded];
    
    UIView *Ve = [self customInfo:(@"网络异常，请稍后再试").loc image:@"ic_markNetError"];
    [Ve.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull La, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([La isKindOfClass:[UILabel class]]) {
            UIButton *btn = JEBtn(JR((self.width - 100)/2, La.bottom + 20, 100, 30),@"重新加载".loc,@14,Tgray1,target,action,[UIColor whiteColor],0,Ve);
            [btn je_addBorderLineImg:(kHexColor(0xDDDDDD)) lineWidth:1 rad:btn.height/2 bgClr:nil];
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

- (void)setListMgr:(JEListManager *)listMgr{
    objc_setAssociatedObject(self, @selector(listMgr), listMgr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JEListManager *)listMgr{
    return  objc_getAssociatedObject(self, _cmd);
}

- (void)listMgr:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages mod:(Class)modClass caChe:(NSString*)caChe suc:(listMgrSucBlock)success{
    [self listManager:API param:param pages:pages mod:modClass superVC:self.superVC caChe:caChe method:(AFHttpMethodPOST) resetAPI:nil sift:nil suc:success fail:nil];
}

- (void)listManager:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages mod:(Class)modClass superVC:(UIViewController*)superVC caChe:(NSString*)caChe method:(AFHttpMethod)method
           resetAPI:(NSString *(^) (NSInteger page))resetAPI
               sift:(NSArray *(^) (id result))sift
                suc:(listMgrSucBlock)success
               fail:(JENetFailBlock)fail {
    JEListManager *manager = [[JEListManager alloc] initWithAPI:API param:param pages:pages tv:self arr:self.Arr vc:superVC mod:modClass caChe:caChe method:method suc:success fail:fail];
    manager.resetAPI = resetAPI;
    manager.siftDataSoure = sift;
    [self setListMgr:manager];
    [manager startNetworking];
}

@end

