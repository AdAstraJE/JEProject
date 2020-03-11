
#import "JEListManager.h"
#import "JEDataBase.h"
#import "JENetWorking.h"
#import "JEKit.h"
#import "JERefreshHeader.h"
#import "JERefreshFooter.h"

@interface JEListManager (){
    AFHttpMethod _method;
    NSURLSessionTask *_task;
}

@property (nonatomic,copy) listMgrSucBlock  block_netSuc;
@property (nonatomic,copy) JENetFailBlock   block_netFail;

@property(nonatomic,weak)   NSMutableArray        *Arr_;///< 引用数据源 
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

- (instancetype)initWithAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages tv:(UIScrollView*)tableview arr:(NSMutableArray*)dataSoure vc:(UIViewController*)superVC mod:(Class)modclass caChe:(NSString*)cacheKey method:(AFHttpMethod)method suc:(listMgrSucBlock)suc fail:(JENetFailBlock)fail{
    if (tableview == nil) {
        return nil;
    }
    
    _currentPage = [JEKit Shared].listMgr_beginPage;
    _API = API;_param = param;_havePage = pages;_Tv_ = (UITableView*)tableview;_Arr_ = dataSoure;
    _VC_ = superVC;_modClass = modclass;_cacheKey = cacheKey;
    _method = method; _block_netSuc = suc; _block_netFail = fail;
    
    [self setupListManager];
    
    return self;
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
        self->_currentPage = [JEKit Shared].listMgr_beginPage;
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
        NSDictionary *cacheList = (NSDictionary*)[JEDataBase Cache:[self cacheKey]];
        if (cacheList != nil) {
            [self defaultHandleSuc:cacheList];
            [self startNetworking];
        }
    }
    
}

- (NSString*)cacheKey{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:_param];
    [parameters removeObjectForKey:[JEKit Shared].listMgr_pageParam];
    [parameters removeObjectForKey:[JEKit Shared].listMgr_rowsParam];
    return  [[_cacheKey addStr:_API] addStr:parameters.json].MD5;
}

#pragma mark - 网络请求

- (void)startNetworking{
    if (_customNetwork) {
        _customNetwork(_currentPage,_param,self);//走自定请求处理
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:_param];
    if (_havePage) {
        [parameters setObject:@(_currentPage).stringValue forKey:[JEKit Shared].listMgr_pageParam];
        if (parameters[[JEKit Shared].listMgr_rowsParam] == nil) {
            [parameters setObject:@([JEKit Shared].listMgr_rowsNum).stringValue forKey:[JEKit Shared].listMgr_rowsParam];
        }
    }
    
    if (_resetAPI) { _API = _resetAPI(_currentPage);}
    if (_API == nil) { return;}
    
    _task = [[JENetWorking Shared] taskWithMethod:_method url:_API param:parameters vc:_VC_ cache:nil done:nil suc:^(NSDictionary *object) {
        [self defaultHandleSuc:object];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self defaultHandleFailure];
            (!self->_block_netFail) ?: self->_block_netFail(task,error);
        });
    }];
   
}

- (void)resetByNewAPI:(NSString *)API param:(NSDictionary *)param{
    [_task cancel];
    [self refreshedSuc:YES];
    _currentPage = [JEKit Shared].listMgr_beginPage;
    if (API) { _API = API;}
    if (param) {_param = param.mutableCopy;}
    [_Arr_ removeAllObjects];
    [_Tv_ reloadData];
    [self beginAnimating];
    [self startNetworking];
}

- (void)refreshedSuc:(BOOL)suc{
    [_Tv_.mj_header endRefreshing];
    [_Tv_.mj_footer endRefreshing];
    _Tv_.backgroundView = _Tv_.ActView = nil;
    _Tv_.mj_header.hidden = NO;
    _Tv_.mj_footer.hidden = !suc;
    ((JERefreshHeader*)_Tv_.mj_header).JENetworkingFail = !suc;
}

#pragma mark -  成功的处理
- (void)defaultHandleSuc:(NSDictionary*)netRes{
    [self refreshedSuc:YES];
    if ((_currentPage == [JEKit Shared].listMgr_beginPage || !_havePage) ) {//有页 且是第一次请求的
        [_Arr_ removeAllObjects];
    }
    
    if (netRes == nil || netRes.count == 0) {
        [_Tv_.mj_footer endRefreshingWithNoMoreData];
        [_Tv_ reloadData];
    }
    
    NSArray *dataSoure;
    if (_siftDataSoure) {
        dataSoure = _siftDataSoure(netRes);
    }else{
        if ([netRes isKindOfClass:[NSArray class]]) {
            dataSoure = (NSMutableArray*)netRes;
        }else{
            dataSoure = netRes[@"content"];///实际得到的数组
            if (dataSoure == nil) {dataSoure = netRes[@"data"];}
            if (dataSoure == nil) {dataSoure = netRes[@"allData"];}
            if (dataSoure.isDict) {dataSoure = netRes[@"data"][@"allData"];}
        }
    }
//    if (dataSoure == nil || ![dataSoure isKindOfClass:[NSArray class]]) { dataSoure = @[]; }

    if (_cacheKey && (_currentPage == [JEKit Shared].listMgr_beginPage || !_havePage)) {//重新刷新的 删除所有数据  只缓存page 为_beginPage时 的数据
        [JEDataBase Cache:netRes key:[self cacheKey]];
    }
    
    //有自己定义处理请求数据的方法
    _block_netSuc ? _block_netSuc(netRes,_currentPage,_Tv_) : [self defaultHandleListArr:dataSoure];
    !_handleEnd ? : _handleEnd(_Tv_);
}

/// 获得实际数组 默认处理数组数据方法 
- (void)defaultHandleListArr:(NSArray*)dataSoure{
    NSInteger maxRow = [[_param objectForKey:([JEKit Shared].listMgr_rowsParam)] integerValue] ? [[_param objectForKey:([JEKit Shared].listMgr_rowsParam)] integerValue] : [JEKit Shared].listMgr_rowsNum;
    if (dataSoure.count == 0 || (_currentPage == [JEKit Shared].listMgr_beginPage && dataSoure.count < maxRow)) {//请求 没数据
        [_Tv_.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (_modClass && [dataSoure isKindOfClass:[NSArray class]]) {
        [_Arr_ addObjectsFromArray:[NSArray modelArrayWithClass:_modClass json:dataSoure]];
    }else{
        if (dataSoure) {
            [dataSoure isKindOfClass:[NSArray class]] ? [_Arr_ addObjectsFromArray:dataSoure] : [_Arr_ addObject:dataSoure];
        }
    }
    
    if (_handleEnd == nil) {[_Tv_ reloadData];}
}

#pragma mark - 失败的处理
- (void)defaultHandleFailure{
    if (_havePage) {_currentPage--;}//失败了 这次页不算 减去
    [self refreshedSuc:NO];
    
    [_Tv_ reloadData];
    [_VC_ hideHud];
}

@end
