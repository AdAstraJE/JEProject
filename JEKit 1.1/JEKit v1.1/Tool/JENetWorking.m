
#import "JENetWorking.h"
#import <objc/runtime.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "JEKit.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   @implementation JENetWorking   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JENetWorking{
    NSDate *_errorAlertDate;///< 上次HUD error 警告时间 控制时间间隔用
    JENetHandleInfoSucBlock _block_sucHandle;
    JENetHandleDoneCodeBlock _block_doneCodeHandle;
}

static JENetWorking *_instance;

+ (instancetype)Shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance AFM];
        _instance.baseUrl = @"";
        _instance.Arr_task = [NSMutableArray array];
        _instance.debug_enableLog = YES;
        
        [_instance cellularData];
    });
    return _instance;
}

- (void)cellularData{
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    /// 此函数会在网络权限改变时再次调用
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        self->_cellularState = state;
    };
}

- (AFHTTPSessionManager *)AFM{
    if (_AFM == nil) {
        AFHTTPSessionManager *_ = [AFHTTPSessionManager manager];
        _.requestSerializer.timeoutInterval = 15.f;
        _.requestSerializer= [AFJSONRequestSerializer serializer];
        //    _.responseSerializer = [AFJSONResponseSerializer serializer];
        _.responseSerializer = [AFHTTPResponseSerializer serializer];
        _AFM = _;
        [self setActivityIndicatorEnable:YES];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:jkNetworkReachabilityNotificationKey object:@(status)];
                self->_status = status;
            });
        }];
    }
    return _AFM;
}

- (void)cancelAllTask{
    @synchronized (self) {
        [@[_AFM.tasks,_AFM.dataTasks,_AFM.uploadTasks,_AFM.downloadTasks] enumerateObjectsUsingBlock:^(NSArray <NSURLSessionTask *> *eachTasks, NSUInteger idx, BOOL * _Nonnull stop) {
            [eachTasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {[obj cancel]; }];
        }];
        [_Arr_task removeAllObjects];
    }
}

- (void)setActivityIndicatorEnable:(BOOL)enable{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = enable;
}

- (NSDictionary *)fullParam:(NSDictionary *)param{
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionaryWithDictionary:param];
    [_Dic_defaultParam enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([fullParams objectForKey:key] == nil) {
            [fullParams setValue:obj forKey:key];
        }
    }];
    [_Dic_coverParam enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (fullParams[key]) {
            [fullParams setValue:fullParams[key] forKey:obj];
            [fullParams removeObjectForKey:key];
        }
    }];
    
    return fullParams;
}

#pragma mark - ⚫️ POST

- (NSURLSessionTask *)POST:(NSString*)URL param:(NSDictionary*)param vc:(UIViewController*)vc cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock{
    return [self taskWithMethod:AFHttpMethodPOST url:URL param:param vc:vc cache:cacheBlock done:doneBlock suc:sucBlock fail:failBlock];
}

#pragma mark - ⚫️ GET

- (NSURLSessionTask *)GET:(NSString*)URL param:(NSDictionary*)param vc:(UIViewController*)vc cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock{
    return [self taskWithMethod:AFHttpMethodGET url:URL param:param vc:vc cache:cacheBlock done:doneBlock suc:sucBlock fail:failBlock];
}

- (NSURLSessionTask *)taskWithMethod:(AFHttpMethod)method url:(NSString*)url param:(NSDictionary*)param vc:(UIViewController*)vc cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock{
    
    UIViewController *relatingVC = vc ? : [UIApplication sharedApplication].keyWindow.rootViewController;
    if (vc == nil) { relatingVC.noAutoHUD = YES; }
    
    NSURLSessionTask *task;
    if (![url hasPrefix:@"http"]) {
        url = [_baseUrl stringByAppendingString:url ? : @""];   
    }
    
    param = [self fullParam:param];
    
    if (cacheBlock && vc) {
        NSString *cacheKey = [self cacheKeyWithURL:url param:param];
        JECacheType cacheType = vc.Dic_jeCacheType[url].integerValue;
        
        if (cacheType == JECacheTypeVC) {
            NSDictionary <NSString *,id> *URLcache = vc.Dic_jeCache[url];
            id result = URLcache[cacheKey];
            cacheBlock(result);
            if (result) {
                [vc hideHud];
                return nil;
            }
        }else{
            cacheType = cacheBlock((NSDictionary*)[JEDataBase Cache:cacheKey]);
            [vc.Dic_jeCacheType setValue:@(cacheType) forKey:url];
        }
    }

    /////////////////////////////////////////////////POST/////////////////////////////////////////////////////////////////////////////
    if (method == AFHttpMethodPOST) {
        task = [_AFM POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleNetworkSuccess:responseObject task:task param:param vc:relatingVC cache:cacheBlock done:doneBlock suc:sucBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleNetworkFailure:task param:param vc:relatingVC error:error fail:failBlock];
        }];
        ///////////////////////////////////////////////////GET///////////////////////////////////////////////////////////////////////////
    }else if (method == AFHttpMethodGET){
        task = [_AFM GET:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleNetworkSuccess:responseObject task:task param:param vc:relatingVC cache:cacheBlock done:doneBlock suc:sucBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleNetworkFailure:task param:param vc:relatingVC error:error fail:failBlock];
        }];
    }
    
    if (task) {
        [_Arr_task addObject:task];
        [relatingVC.Arr_taskId addObject:@(task.taskIdentifier)];
    }
    
    return task;
}


#pragma mark - ⚫️ 上传流
- (NSURLSessionTask *)uploadDatasWithURL:(NSString *)url
                                   param:(NSDictionary *)param
                                      vc:(UIViewController*)vc
                                   datas:(NSArray<NSData *> *)datas
                                mimeType:(NSString *)mimeType
                                progress:(JENetProgressBlock)progressBlock
                                    done:(JENetDoneBlock)doneBlock
                                    fail:(JENetFailBlock)failBlock {
    if (![url hasPrefix:@"http"]) {
        url = [_baseUrl stringByAppendingString:url ? : @""];
    }

    
    UIViewController *relatingVC = vc ? : [UIApplication sharedApplication].keyWindow.rootViewController;
    NSURLSessionTask *task = [_AFM POST:url parameters:[self fullParam:param] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [datas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:@"file" fileName:@"file"  mimeType:mimeType ? : @""];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat pros = (float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount;
        dispatch_sync(dispatch_get_main_queue(), ^{
            !progressBlock ?: progressBlock(uploadProgress,pros);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleNetworkSuccess:responseObject task:task param:param vc:relatingVC cache:nil done:doneBlock suc:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleNetworkFailure:task param:param vc:relatingVC error:error fail:failBlock];
        
    }];
    
    if (task) {
        [_Arr_task addObject:task];
        if (![_Arr_disableAutoCancelAPI containsObject:url]) {
            [relatingVC.Arr_taskId addObject:@(task.taskIdentifier)];
        }
    }
    
    return task;
}

- (NSString*)cacheKeyWithURL:(NSString *)URL param:(NSDictionary*)param{
    NSMutableDictionary *sift = param.mutableCopy;
    [sift removeObjectForKey:@"token"];
    return [URL stringByAppendingString:(sift.json ? : @"")].MD5;
}

#pragma mark - ✅ 成功处理

- (void)handleNetworkSuccess:(id)responseObject task:(NSURLSessionDataTask *)task param:(NSDictionary*)param vc:(UIViewController*)vc cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock {
    
    [self handleTask:task param:param vc:vc error:nil];
    
    if (task.error.code == NSURLErrorCancelled) {//主动取消网络请求的 不做处理
        return ;
    }
    
    NSDictionary *netRes = responseObject;
    if ([responseObject isKindOfClass:[NSData class]]){
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        netRes = string.jsonDic;
        if (netRes == nil) {if (_debug_enableLog) {JELog(@"\n❌❌❌❌\n%@",string);}}
    }else if ([responseObject isKindOfClass:[NSString class]]){
        netRes = ((NSString*)responseObject).jsonDic;
    }
    
    NSInteger errorCode = 0;
    if (_block_doneCodeHandle) {
        errorCode = _block_doneCodeHandle(netRes);
    }
    !doneBlock ?: doneBlock(netRes,errorCode);
    
    if (sucBlock) {
//        NSAssert(_block_sucHandle != nil, @"先设置 请求完成后的验证处理 setHandleInfoSucBlock");
        NSDictionary *result = _block_sucHandle ? _block_sucHandle(netRes,vc) : netRes;
        if (result == nil) {
            return;
        }
        
        sucBlock(result);
        
        if (cacheBlock && vc) {
            NSString *url = task.currentRequest.URL.absoluteString;
            NSString *cacheKey = [self cacheKeyWithURL:url param:param];
            JECacheType cacheType = vc.Dic_jeCacheType[url].integerValue;
            
            if (cacheType == JECacheTypeDisk) {
                [JEDataBase Cache:result key:[self cacheKeyWithURL:url param:param]];
            }else if (cacheType == JECacheTypeVC){
                NSDictionary <NSString *,id> *URLcache = vc.Dic_jeCache[url];
                if (URLcache == nil) {
                    URLcache = [NSMutableDictionary dictionary];
                    [URLcache setValue:result forKey:cacheKey];
                    [vc.Dic_jeCache setValue:URLcache forKey:url];
                }else{
                    [URLcache setValue:result forKey:cacheKey];
                }
            }  
        }
        
    }
    
    if (_debug_enableLog) { [JEDebugTool__ LogTitle:task.currentRequest.URL.absoluteString noti:param detail:netRes];}
}

- (void)setHandleInfoSucBlock:(JENetHandleInfoSucBlock)HandleInfo{
    _block_sucHandle = HandleInfo;
}

- (void)setHandleDoneCode:(JENetHandleDoneCodeBlock)HandleInfo{
    _block_doneCodeHandle = HandleInfo;
}

#pragma mark - ❌ 失败处理

- (void)handleNetworkFailure:(NSURLSessionDataTask *)task param:(NSDictionary*)param vc:(UIViewController*)vc error:(NSError *)error fail:(JENetFailBlock)failBlock{
    BOOL currentTask = [vc.Arr_taskId.lastObject isEqualToNumber:@(task.taskIdentifier)];
    [self handleTask:task param:param vc:vc error:error];
    if (failBlock) { failBlock(task,error);return;}//有自己的处理方式 返回了
    
    if (task.error.code == NSURLErrorCancelled) {
        if (_debug_enableLog) {JELog(@"❌ Lost or 主动取消的网络请求 %@",task.currentRequest.URL.absoluteString);}
    }else{
        if (!vc.noAutoHUD) {
            if (_errorAlertDate == nil || [[NSDate date] timeIntervalSinceDate:_errorAlertDate] > 1) {
                HUDMarkType type = (_status == AFNetworkReachabilityStatusReachableViaWWAN) ? HUDMarkTypefailure : HUDMarkTypeNetError;
                if ((vc.HUD && !vc.HUD.hidden && currentTask) || ![vc isKindOfClass:[UINavigationController class]]) {
                    ([(vc ? : ([UIApplication sharedApplication].keyWindow.rootViewController))showHUD:@"网络连接失败".loc type:type]);
                }
            }else{
                [vc hideHud];
            }
            _errorAlertDate = [NSDate date];
        }
    }
    [JEDebugTool__ LogTitle:task.currentRequest.URL.absoluteString noti:param detail:error.description];
}

#pragma mark - ▶︎ remove task 请求结束处理 | 构建错误内容
- (void)handleTask:(NSURLSessionDataTask *)task param:(NSDictionary*)param vc:(UIViewController*)vc error:(NSError *)error{
    [_Arr_task removeObject:task];
    [vc.Arr_taskId removeObject:@(task.taskIdentifier)];
    
#ifdef DEBUG
    NSString *resultString = [NSString stringWithFormat:@"\n🌐 <%@> \n%@\n%@\n",@(task.taskIdentifier),task.currentRequest.URL.absoluteString,param.json ?: @"{}"];
    if (error) {
        resultString = [resultString stringByAppendingFormat:@"\n%@\n❌❌❌❌",[error userInfo][@"NSLocalizedDescription"]];
    }
    if (_debug_enableLog) {
        JELog(@"%@",resultString);
    }
#endif
}

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIViewController (JENetWorking)   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation UIViewController (JENetWorking)

- (BOOL)noAutoHUD{ return [objc_getAssociatedObject(self, _cmd) boolValue];}
- (void)setNoAutoHUD:(BOOL)noAutoHUD{ objc_setAssociatedObject(self, @selector(noAutoHUD), @(noAutoHUD), OBJC_ASSOCIATION_RETAIN_NONATOMIC);}

/// 该VC所有进行中的请求id 
- (NSMutableArray <NSNumber *> *)Arr_taskId{
    NSMutableArray *taskId = objc_getAssociatedObject(self, _cmd);
    if (taskId == nil) {
        taskId = [[NSMutableArray alloc]init];
        objc_setAssociatedObject(self, _cmd, taskId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taskId;
}

- (NSMutableDictionary <NSString *,NSDictionary <NSString *,id> *> *)Dic_jeCache{
    NSMutableDictionary *obj = objc_getAssociatedObject(self, _cmd);
    if (obj == nil) {
        obj = [[NSMutableDictionary alloc]init];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)Dic_jeCacheType{
    NSMutableDictionary *obj = objc_getAssociatedObject(self, _cmd);
    if (obj == nil) {
        obj = [[NSMutableDictionary alloc]init];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(viewDidDisappear:) with:@selector(jeNetWork_viewDidDisappear:)];
    });
}

/// 该页面离开导航栏栈了 取消还在进行网络请求 
- (void)jeNetWork_viewDidDisappear:(BOOL)animated{
    [self jeNetWork_viewDidDisappear:animated];
    if (!_instance || self.Nav) {return;}
    @synchronized (self) {
        [[JENetWorking Shared].Arr_task enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.Arr_taskId containsObject:@(task.taskIdentifier)]) {
                [task cancel];
                [[JENetWorking Shared].Arr_task removeObject:task];
            }
        }];
    }
}

- (NSURLSessionTask *)POST:(NSString*)URL param:(NSDictionary*)param cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock{
    return [[JENetWorking Shared] POST:URL param:param vc:self cache:cacheBlock done:doneBlock suc:sucBlock fail:failBlock];
}

- (NSURLSessionTask *)GET:(NSString*)URL  param:(NSDictionary*)param cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock{
    return [[JENetWorking Shared] GET:URL param:param vc:self cache:cacheBlock done:doneBlock suc:sucBlock fail:failBlock];
}

@end
