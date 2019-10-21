
#import "JEListManager.h"
#import "JEDataBase.h"
#import "JENetWorking.h"
#import "JEKit.h"
#import "JERefreshHeader.h"
#import "JERefreshFooter.h"

@interface JEListManager (){
    AFHttpMethod _method;
    NSInteger _beginPage;///< 页数固定从1开始  （与当前后台设置的起始页数为准）
    NSURLSessionTask *_task;
}

@property(nonatomic,weak)   NSMutableArray       *Arr_;/**< 引用数据源 */
@property(nonatomic,weak)   UIViewController      *VC_;
@property(nonatomic,weak)   UITableView           *Tv_;
@property(nonatomic,copy)   NSString              *cacheKey;
@property(nonatomic,getter=isHavePage) BOOL       havePage;
@property(nonatomic,copy)   Class                 modClass;

@end

@implementation JEListManager

- (void)dealloc{
    _block_netSuc = nil;
    _block_netFail = nil;
    jkDeallocLog
}

- (instancetype)initWithAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages Tv:(UIScrollView*)tableview Arr:(NSMutableArray*)dataSoure VC:(UIViewController*)SuperVC modClass:(Class)modclass cacheKey:(NSString*)cacheKey method:(AFHttpMethod)method suc:(JEListNetSucBlcok)suc fail:(JEListNetFailureBlock)fail{
    if (tableview == nil) {
        return nil;
    }
    
    [self resetPage];
    _API = API;_param = param;_havePage = pages;_Tv_ = (UITableView*)tableview;_Arr_ = dataSoure;
    _VC_ = SuperVC;_modClass = modclass;_cacheKey = cacheKey;
    _method = method;_block_netSuc = suc; _block_netFail = fail;
    
    [self setupListManager];
    
    return self;
}

- (void)resetPage{
    _beginPage = [JEKit Shared].listManagerBeginPage;
    _currentPage = _beginPage;
}

- (void)beginAnimating{
    if (_API == nil) { return;}
    _Tv_.mj_footer.hidden = _Tv_.mj_header.hidden = YES;
    _Tv_.backgroundView = _Tv_.ActView;
    [_Tv_.ActView startAnimating];
}

- (void)setupListManager{
    _Tv_.mj_header = [JERefreshHeader headerWithRefreshingBlock:^{
        self->_Tv_.mj_footer.hidden = YES;
        self->_currentPage = self->_beginPage;
        [self startNetworking];
    }];
    
    if (_havePage) { //如果有页的概念   页数固定从_beginPage开始  （与当前后台设置的起始页数为准）
        _Tv_.mj_footer = [JERefreshFooter footerWithRefreshingBlock:^{
            if (self->_Tv_.mj_footer.state == MJRefreshStateNoMoreData) {
                [self->_Tv_.mj_footer endRefreshingWithNoMoreData];return ;
            }
            self->_Tv_.mj_header.hidden = YES;
            self->_currentPage ++ ;
            [self startNetworking];
        }];
    }

    [self beginAnimating];
    
    if (_cacheKey) {//先显示缓存的数据
        NSDictionary *cacheList = (NSDictionary*)[JEDataBase objectForKey:[self cacheKey]];
        if (cacheList != nil) {
            [self defaultHandleSuccess:cacheList];
            [self startNetworking];
        }
    }
    
}

- (NSString*)cacheKey{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:_param];
    [parameters removeObjectForKey:rowsParam];
    [parameters removeObjectForKey:PageParam];
    return  [[_cacheKey addStr:_API] addStr:parameters.JsonStr].MD5;
}

#pragma mark - 网络请求

- (void)startNetworking{
    if (_block_customNetworking) {
        _block_customNetworking(_currentPage,_param,self);//走自定请求处理
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:_param];
    if (_havePage) {
        [parameters setObject:@(_currentPage).stringValue forKey:PageParam];
        if (parameters[rowsParam] == nil) {
            [parameters setObject:@(rowsNum).stringValue forKey:rowsParam];
        }
    }
    
    if (_block_resetAPI) { _API = _block_resetAPI(_currentPage);}
    if (_API == nil) { return;}
    
    _task = [[JENetWorking Shared] taskWithMethod:_method url:_API param:parameters vc:_VC_ cache:nil done:nil suc:^(NSDictionary *object) {
        [self defaultHandleSuccess:object];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self defaultHandleFailure];
        });
    }];
   
}

- (void)resetByNewAPI:(NSString *)API param:(NSDictionary *)param{
    [_task cancel];
    [self refreshingDoneWithFail:NO];
    [self resetPage];
    if (API) { _API = API;}
    if (param) {_param = param.mutableCopy;}
    [_Arr_ removeAllObjects];
    [_Tv_ reloadData];
    [self beginAnimating];
    [self startNetworking];
}

- (void)refreshingDoneWithFail:(BOOL)fail{
    [_Tv_.mj_header endRefreshing];
    [_Tv_.mj_footer endRefreshing];
    _Tv_.backgroundView = _Tv_.ActView = nil;
    _Tv_.mj_header.hidden = NO;
    _Tv_.mj_footer.hidden = fail;
    ((JERefreshHeader*)_Tv_.mj_header).JENetworkingFail = fail;
}

#pragma mark -  成功的处理
- (void)defaultHandleSuccess:(NSDictionary*)netRes{
    [self refreshingDoneWithFail:NO];
    if ((_currentPage == _beginPage || !_havePage) ) {//有页 且是第一次请求的
        [_Arr_ removeAllObjects];
    }
    
    if (netRes == nil || netRes.count == 0) {
        [_Tv_.mj_footer endRefreshingWithNoMoreData];
        [_Tv_ reloadData];
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSMutableArray *arrLists;
    if ([netRes isKindOfClass:[NSArray class]]) {
        arrLists = (NSMutableArray*)netRes;
    }else{
        arrLists = netRes[@"content"];///实际得带的数组
        if (arrLists == nil) {arrLists = netRes[@"data"];}
        if (arrLists == nil) {arrLists = netRes[@"allData"];}
        if (arrLists.isDict) {arrLists = netRes[@"data"][@"allData"];}
    }
    if (arrLists == nil || ![arrLists isKindOfClass:[NSArray class]]) {
        arrLists = [@[] mutableCopy];
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    if (_cacheKey && (_currentPage == _beginPage || !_havePage)) {//重新刷新的 删除所有数据  只缓存page 为_beginPage时 的数据
        [JEDataBase setObject:netRes forKey:[self cacheKey]];
    }
    
    //有自己定义处理请求数据的方法
    _block_netSuc ? _block_netSuc(netRes,_currentPage,_Tv_) : [self defaultHandleListArr:arrLists];
    !_block_end ? : _block_end(_Tv_);
}

/** 获得实际数组 默认处理数组数据方法 */
- (void)defaultHandleListArr:(NSArray*)ArrLists{
    NSInteger maxRow = [[_param objectForKey:rowsParam] integerValue] ? [[_param objectForKey:rowsParam] integerValue] : rowsNum;
    if (ArrLists.count == 0 || (_currentPage == _beginPage && ArrLists.count < maxRow)) {//请求 没数据
        [_Tv_.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (_modClass && [ArrLists isKindOfClass:[NSArray class]]) {
        [_Arr_ addObjectsFromArray:[NSArray modelArrayWithClass:_modClass json:ArrLists]];
    }else{
        if (ArrLists) {
            [ArrLists isKindOfClass:[NSArray class]] ? [_Arr_ addObjectsFromArray:ArrLists] : [_Arr_ addObject:ArrLists];
        }
    }
    
    if (_block_end == nil) {[_Tv_ reloadData];}
    
//    NSLog(@"%@",ArrLists.JsonStr);
}

#pragma mark - 失败的处理
- (void)defaultHandleFailure{
    if (_havePage) {_currentPage--;}//失败了 这次页不算 减去
    [self refreshingDoneWithFail:YES];
    
    [_Tv_ reloadData];
    
    !_block_netFail ?: _block_netFail();
    [_VC_ hideHud];
}


@end
