
#import "JEDebugTool__.h"
#import "JEKit.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JEPutDownMenuView.h"

static NSInteger const jkLabelMargin = 8;///< 各种边距
static NSInteger const jkCellDescribeMaxLength = 1208;///< cell最多显示长度 太长点击看。

static NSString * const jkDebugToolModel     = @"jkDebugToolModel";///< 具体历史tableName
static NSString * const jkDebugToolTimeList  = @"jkDebugToolTimeList";///< 历史列表tableName

static NSString * const jkSeparatedStr = @"  ————  ";///< 分割用
static NSString * const jkDetailIdentifier = @"jkDetailIdentifier";


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugToolModel   🔷 显示模型
@implementation JEDebugToolModel

+ (NSString *)PrimaryKey{return @"indexTime";}

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugToolTimeListModel   🔷 时间列表模型

@interface JEDebugToolTimeListModel : JEDBModel
@property (nonatomic,assign) NSInteger number;///< log数量
@end

@implementation JEDebugToolTimeListModel
+ (NSString *)PrimaryKey{return @"date";}
@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugToolCell   🔷 Cell

@interface JEDebugToolCell : UITableViewCell
@property (nonatomic,strong) UITextView *TextView;///< 详情显示用
@property (nonatomic,strong) UILabel *La_rep;///< 重复次数
@end

@implementation JEDebugToolCell{
    UILabel  *_La_index;///< 请求时间 + index 1 2 3 4
    UILabel  *_La_API;///< 请求地址
    UILabel  *_La_param;///< 请求参数
    UILabel  *_La_des;///< 显示结果 过多显示。。。。。。。。
    JEDebugToolModel *_mod;///< mod
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIFont *font1 = [reuseIdentifier isEqualToString:jkDetailIdentifier] ? font(20) : font(16);
    UIFont *font2 = [reuseIdentifier isEqualToString:jkDetailIdentifier] ? font(15) : font(12);
    _La_index = JELab(JR(jkLabelMargin, 8, ScreenWidth - jkLabelMargin*2, 20),nil,font1,kHexColor(0xDC3023),(1),self.contentView).adjust();
    _La_API = JELab(JR(_La_index.x, _La_index.bottom + jkLabelMargin, _La_index.width, 0),nil,font2,kHexColor(0xE29C45),(0),self.contentView);
    _La_param = JELab(JR(_La_index.x, _La_API.bottom, _La_API.width, 0),nil,font2,kHexColor(0x0C8918),(0),self.contentView);
    _La_des = JELab(JR(_La_index.x, _La_param.bottom, _La_API.width,1),nil,font2,nil,(0),self.contentView);
    return self;
}

- (UITextView *)TextView{
    if (_TextView == nil) {
        _TextView = [[UITextView alloc] initWithFrame:CGRectMake(jkLabelMargin, 0, ScreenWidth - jkLabelMargin*2, 0)].addTo(self.contentView);
        _TextView.dataDetectorTypes = UIDataDetectorTypeAll;
        _TextView.editable = NO;
    }
    return _TextView;
}

-(UILabel *)La_rep{
    if (_La_rep == nil) {
        _La_rep = JELab(JR(jkLabelMargin/2, 0, 30, 30),nil,fontM(15),kColorRed,(1),self.contentView);
        [_La_rep border:kColorRed width:1];
        _La_rep.adjustsFontSizeToFitWidth = YES;[_La_rep beRound];
    }
    return _La_rep;
}

- (void)load:(JEDebugToolModel *)mod indexPath:(NSIndexPath *)indexPath detail:(BOOL)detail{
    _mod = mod;
    self.selectionStyle = (detail ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault);
    BOOL simple = (mod.simple.length != 0);
    if (simple) {
        _La_index.text = _La_API.text = _La_param.text = nil;
        _La_index.height = _La_API.height = _La_param.height = 0;
    }else{
        _La_index.text = Format(@"%@%@[%@]",mod.indexTime,jkSeparatedStr,@(indexPath.row));
        _La_index.height = 20;
        _La_API.text = (detail ? mod.API : [self limitLength:mod.API]);
        _La_param.text = (detail ? mod.param : [self limitLength:mod.param]);
    }
    
    [_La_API sizeThatHeight];
    
    _La_param.y = _La_API.bottom + jkLabelMargin;
    [_La_param sizeThatHeight];
    
    if (detail) {
        self.TextView.y = (simple ? (mod.repeate == 0 ? 0 : 30) : _La_param.bottom);
        _TextView.height = MAX(200, ScreenHeight - ScreenNavBarH - ScreenSafeArea - (_TextView.y) - _La_des.height);
        _TextView.text = simple ? mod.simple : mod.des;
        (simple ? (_La_des.height = _TextView.height) : (_La_des.y = _TextView.bottom));
    }else{
        if (simple) {
            _La_des.text = (detail ? mod.simple : [self limitLength:mod.simple]);
        }else{
            _La_des.text  = (detail ? mod.des : [self limitLength:mod.des]);
        }
        _La_des.y = (simple ? jkLabelMargin : (_La_param.bottom + jkLabelMargin));
        [_La_des sizeThatHeight];
    }
    
    if (mod.repeate == 0) {
        _La_rep.hidden = YES;
    }else{
        self.La_rep.text = Format(@"X%d",(int)mod.repeate + 1);
        _La_rep.hidden = NO;
        if (simple) { _La_des.y += _La_rep.height;}
    }
    
}

- (NSString *)limitLength:(NSString *)string{
    if (string.length > jkCellDescribeMaxLength) {//太长了
        string = [[string substringToIndex:jkCellDescribeMaxLength] addStr:[NSString stringWithFormat:@"\n\n ...... %@/%@ 点击显示全部 ▶︎",@(jkCellDescribeMaxLength),@(string.length)]];
    }
    return string;
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(size.width, _La_des.bottom +  (_mod.simple.length ? jkLabelMargin : jkLabelMargin*2));
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugTimeListVC   🔷 历史时间列表VC

@implementation JEDebugTimeListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"存进DB的历史";
    
    NSDate *date = [NSDate date];
    self.liteTv = [JELiteTV Frame:self.tvFrame style:(UITableViewStyleGrouped) cellC:JETableViewCell1.class cellH:ScrnAdaptMax(50) cell:^(__kindof UITableViewCell *cell, UITableView *tv, NSIndexPath *idx, JEDebugToolTimeListModel *mod) {
        cell.textLabel.text = [mod.date isSameDay:date] ? mod.date.je_HHmmss : mod.date.je_YYYYMMddHHmmss;
        cell.detailTextLabel.text = @(mod.number).stringValue;
        if (idx.row == 0 && ([JEDebugTool__ Shared].beginDate.ts.integerValue - mod.date.ts.integerValue == 0)) {
            cell.textLabel.text = mod.date.je_HHmmss;
            cell.detailTextLabel.text = @"主页LOG".loc;
        }
    } select:^(UITableView *tv, NSIndexPath *idx, JEDebugToolTimeListModel *mod) {
        if (idx.row == 0 && ([JEDebugTool__ Shared].beginDate.ts.integerValue - mod.date.ts.integerValue == 0)) {
            [self.Nav popViewControllerAnimated:YES];return;
        }
        JEDebugMainVC *vc = [JEDebugMainVC VC];
        vc.historyDate = mod.date;
        [self.navigationController pushViewController:vc animated:YES];
    } to:self.view];

    [JEDebugToolTimeListModel AllModel:^(NSMutableArray<JEDBModel *> *models) {
        self.liteTv.Arr = models;
        [self.liteTv reloadData];
    } desc:YES];
}

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @implementation JEDebugMainVC   🔷 数据显示VC

@implementation JEDebugMainVC{
    NSInteger _toDBlogNumber;
    NSMutableArray <JEDebugToolModel *> *_Arr_orgin;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _toDBlogNumber = 0;
    _Arr_orgin = [NSMutableArray array];
    [self je_rightNavBtn:@"更多" target:self act:@selector(actionHandle)];//❖

    //显示某个历史
    if (_historyDate) {
        self.title = _historyDate.je_YYYYMMddHHmmss;
        [JEDebugToolModel Select:Format(@"where date = \"%@\"",self.historyDate.ts) done:^(NSMutableArray<JEDBModel *> *models) {
            self.Tv_list.Arr = models;
            [self.Tv_list reloadData];
        }];
    }
    else if(_detailMod){
        self.title = @"详情";
        [self.Tv_list.Arr addObject:_detailMod];
        [self.Tv_list reloadData];
    }else{
        [JEBtn(JR(10, ScreenStatusBarH, -1, 44),@"历史",@18,kColorBlue,self,@selector(historyBtnClick),nil,0,self.view).touchs(ScreenStatusBarH,3,20,20) sizeThatWidth];
    }
}

- (UITableView *)Tv_list{
    if (_Tv_list == nil) {
        UITableView *_ = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenNavBarH, ScreenWidth, ScreenHeight - ScreenNavBarH)].addTo(self.view);
        NSString *identifier = _detailMod ? jkDetailIdentifier : [JEDebugToolCell className];
        [_ registerClass:[JEDebugToolCell class] forCellReuseIdentifier:identifier];
        _.delegate = self;_.tableFooterView = [UIView new];
        _.dataSource = self;_.backgroundColor = self.view.backgroundColor;
        _Tv_list = _;
    }
    return _Tv_list;
}

- (void)historyBtnClick{
    [self.navigationController pushViewController:[JEDebugTimeListVC VC] animated:YES];
}

- (void)addLogWithTitle:(NSString *)title noti:(id)noti detail:(id)detail simple:(id)simple toDB:(BOOL)toDB{
    JEDebugToolModel *mod = [[JEDebugToolModel alloc]init];
    mod.date = [JEDebugTool__ Shared].beginDate;
    mod.indexTime = [NSString stringWithFormat:@"%@",[NSDate date].je_YYYYMMddHHmmss];
    mod.API = title;
    mod.param = [NSString StringFrom:noti];
    mod.des = [NSString StringFrom:detail];
    mod.simple = [NSString StringFrom:simple];
    mod.MD5 = Format(@"%@%@%@%@",mod.API,mod.param,mod.des,mod.simple).MD5;

    JEDebugToolModel *last = _Arr_orgin.lastObject;
    BOOL repeateContent = ([last.MD5 isEqualToString:mod.MD5]);
    if (repeateContent) {
        last.repeate += 1;
        mod.indexTime = last.indexTime;
        mod.repeate = last.repeate;
    }else{
        [_Arr_orgin addObject:mod];
        [self filterDebugList];
    }

    if (![JEDebugTool__ Shared].nav.view.hidden) {
        [self.Tv_list reloadData];
//        if (_Tv_list.contentOffset.y + _Tv_list.height*1.2 + _Tv_list.y >= _Tv_list.contentSize.height) {
//            [_Tv_list scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_Tv_list.Arr.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        }
    }
    
    if (toDB) {
        [mod dbSave];
        
        if (!repeateContent) { _toDBlogNumber += 1;}
        JEDebugToolTimeListModel *list = [[JEDebugToolTimeListModel alloc] init];
        list.date = [JEDebugTool__ Shared].beginDate;
        list.number = _toDBlogNumber;
        [list dbSave];
    }
    
    //可能重设置了root
    [JEApp.window bringSubviewToFront:[JEDebugTool__ Shared].Btn_touch];
    if (![JEApp.window.subviews containsObject:[JEDebugTool__ Shared].nav.view]) {
        [JEApp.window addSubview:[JEDebugTool__ Shared].nav.view];
        [JEApp.window bringSubviewToFront:[JEDebugTool__ Shared].Btn_touch];
    }
    
}

- (void)filterDebugList{
    [self.Tv_list.Arr removeAllObjects];
    [_Arr_orgin enumerateObjectsUsingBlock:^(JEDebugToolModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.hidde) { [self->_Tv_list.Arr addObject:obj];}
    }];
    
    self.title = Format(@"%@",@(_Tv_list.Arr.count));
}

#pragma mark - UITableView Delegate DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = _detailMod ? jkDetailIdentifier : [JEDebugToolCell className];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(JEDebugToolCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        [cell load:tableView.Arr[indexPath.row] indexPath:indexPath detail:(self.detailMod ? YES : NO)];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ return tableView.Arr.count;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = _detailMod ? jkDetailIdentifier : [JEDebugToolCell className];
    JEDebugToolCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (tableView.Arr.count > indexPath.row) { [cell load:(tableView.Arr[indexPath.row]) indexPath:indexPath detail:(self.detailMod ? YES : NO)];}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= tableView.Arr.count || _detailMod) {  return;}
    
    JEDebugMainVC *vc = [JEDebugMainVC VC];
    vc.detailMod = (tableView.Arr[indexPath.row]);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
}


- (void)actionHandle{
    NSString *cleanAll = @"LOG : 清空显示";
    NSString *shareTxt = @"LOG : 📱本机分享";
    NSString *sendEmail = @"LOG : ✉️发送Email";
    NSString *copy = @"复制";
    NSString *die = @"模拟重装APP";
    
    NSMutableArray <NSString *> *list = @[shareTxt].mutableCopy;
    if (!_historyDate) {[list insertObject:cleanAll atIndex:0];}
    
    id mail = [[NSClassFromString(@"SKPSMTPMessage") alloc] init];
    
    NSDictionary *secret = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JESecret" ofType:@"plist"]];
    if (mail && secret) {[list addObject:sendEmail];}
    
    if (!_historyDate) {[list addObject:die];}
    if (_detailMod) { list = @[copy,shareTxt].mutableCopy;}
    
    [JEPutDownMenuView ShowIn:JEApp.window point:CGPointMake(ScreenWidth, ScreenNavBarH) list:list select:^(NSString *str, NSInteger index) {
        if ([str isEqualToString:cleanAll]){
            for (JEDebugToolModel *obj in self->_Arr_orgin) { obj.hidde = YES;}
            [self filterDebugList];
            [self.Tv_list reloadData];
        }
        else if ([str isEqualToString:copy]){
            [JEApp.window.rootViewController showHUD:nil type:(HUDMarkTypeSuccess)];
            [UIPasteboard generalPasteboard].string = [self->_detailMod modelDescription];
        }
        else if ([str isEqualToString:shareTxt]){
            [[JEDebugTool__ Shared] closeOpen];
            
            [JEApp.window.rootViewController showHUD];
            NSString *filePath = [self createTxtFilePathEnableNetInfo:YES];
            [JEApp.window.rootViewController hideHud];
            
            UIActivityViewController *act = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:filePath]] applicationActivities:nil];
            [JEApp.window.rootViewController presentViewController:act animated:YES completion:nil];
        }
        else if ([str isEqualToString:sendEmail]){
            [[JEDebugTool__ Shared] closeOpen];
            [self Alert:@"发送LOG至开发者邮箱？" msg:nil act:@[@"发送"] destruc:nil _:^(NSString *act, NSInteger index) {
                [self sendLogToEmail];
            }];
        }
        else if ([str isEqualToString:die]){
            [[JEDebugTool__ Shared] closeOpen];
            
            [self Alert:@"Sure ?" msg:@"清除所有本地缓存数据并关闭APP" act:@[@"Sure"] destruc:@[@"Sure"] _:^(NSString *act, NSInteger index) {
                NSDictionary *dic = [USDF dictionaryRepresentation];
                for (id  key in dic) { [USDF removeObjectForKey:key];}
                [USDF synchronize];
                
                [JEDataBase Close];
                [JEDataBase RemoveAll];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSArray *FileArr = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
                for (NSString *filename in FileArr) {
                    [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
                }
                
                [JEApp.window.rootViewController showHUDLabelText:@"🔥..."];
                delay(2, ^{
                    exit(0);
                });
            }];
        
        }
        
    } upward:NO arrowX:0.85];
}

- (NSString *)createTxtFilePathEnableNetInfo:(BOOL)netInfo{
    NSMutableString *txtFile = [self txtHeadInfo];
    
    [self.Tv_list.Arr enumerateObjectsUsingBlock:^(JEDebugToolModel  *mod, NSUInteger idx, BOOL * _Nonnull stop) {
        if (mod.simple) {
            [txtFile appendFormat:@"%@\n",mod.simple];
        }else{
            if (netInfo) {
                NSMutableString *str = [NSMutableString stringWithString:@"{\n"];
                [str appendFormat:@"    %@\n",mod.indexTime];
                if (mod.repeate != 0) {[str appendFormat:@"    rep = \"%@\"\n",@(mod.repeate)];}
                [str appendFormat:@"    API = \"%@\"\n",mod.API];
                [str appendFormat:@"    par = \"%@\"\n",mod.param];
                [str appendFormat:@"    des = \"%@\"\n",mod.des];
                [str appendString:@"}\n"];
                [txtFile appendString:str];
            }
        }
    }];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[self fileName]];
    [txtFile writeToFile:filePath atomically:YES encoding:(NSUTF8StringEncoding) error:nil];
 
    return filePath;
}

- (NSMutableString *)txtHeadInfo{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSMutableString *txtFile = [NSMutableString string];
    [txtFile appendFormat:@"\n%@\n",[dic str:@"CFBundleDisplayName"].value ? : [dic str:@"CFBundleName"]];
    [txtFile appendFormat:@"%@   V%@\n",[dic str:@"CFBundleIdentifier"],kAPPVersions];
    [txtFile appendFormat:@"%@\n",[UIScreen DeviceName]];
    NSString *date = self->_historyDate ? self->_historyDate.je_YYYYMMddHHmmss : [JEDebugTool__ Shared].beginDate.je_YYYYMMddHHmmss;
    [txtFile appendFormat:@"%@ --- %@\n\n",date,self->_historyDate ? @"" : [NSDate date].je_YYYYMMddHHmmss];
    
    if ([JEAppScheme User]) {
        [txtFile appendFormat:@"%@\n",[[JEAppScheme User] modelDescription]];
    }
    [txtFile appendString:@"\n---------------------------------------------------------------------------\n"];
    return txtFile;
}

- (NSString *)fileName{
    NSString *fileName = Format(@"JELOG_%@.txt",(self->_historyDate ? : [NSDate date]).je_YYYYMMddHHmmss);
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return fileName;
}

- (void)sendLogToEmail{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *subject = Format(@"JELOG    %@",[dic str:@"CFBundleIdentifier"]);
    NSDictionary *secret = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JESecret" ofType:@"plist"]];
    
    id mail = [[NSClassFromString(@"SKPSMTPMessage") alloc] init];
    if (!mail || !secret) { return;}
    
    [mail setValue:(secret[@"SKPSMTP_toEmail"]) forKey:@"toEmail"];
    [mail setValue:(secret[@"SKPSMTP_fromEmail"]) forKey:@"fromEmail"];
    [mail setValue:(secret[@"SKPSMTP_relayHost"]) forKey:@"relayHost"];
    [mail setValue:(secret[@"SKPSMTP_login"]) forKey:@"login"];
    [mail setValue:(secret[@"SKPSMTP_pass"]) forKey:@"pass"];

    [mail setValue:@(YES) forKey:@"requiresAuth"];
    [mail setValue:self forKey:@"delegate"];
    [mail setValue:subject forKey:@"subject"];
    
    NSDictionary *plainPart = @{@"kSKPSMTPPartContentTypeKey" : @"text/plain",
                                @"kSKPSMTPPartMessageKey" : [self txtHeadInfo],
                                @"kSKPSMTPPartContentTransferEncodingKey" : @"8bit"};
    
    [JEApp.window.rootViewController showHUD];
    NSString *filePath = [self createTxtFilePathEnableNetInfo:YES];
    
    NSData *vcfData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath] options:(NSDataReadingMappedIfSafe) error:NULL];
    NSString *base64 = [vcfData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *fileName = [self fileName];
    
    NSDictionary *vcfPart = @{@"kSKPSMTPPartContentTypeKey" : Format(@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"",fileName),
                @"kSKPSMTPPartContentDispositionKey" : Format(@"attachment;\r\n\tfilename=\"%@\"",fileName),
                @"kSKPSMTPPartMessageKey" : base64,
                @"kSKPSMTPPartContentTransferEncodingKey" : @"base64"
                };
    [mail setValue:@[plainPart,vcfPart] forKey:@"parts"];
    [mail performSelectorOnMainThread:@selector(send) withObject:nil waitUntilDone:YES];
}

- (void)send{}

- (void)messageSent:(id)message{
    [JEApp.window.rootViewController showHUD:@"已发送" type:(HUDMarkTypeSuccess)];
}

- (void)messageFailed:(id)message error:(NSError *)error{
    [JEApp.window.rootViewController showHUD:Format(@"%@%@",@"失败",error) type:(HUDMarkTypefailure)];
}

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface JEDebugTool__   🔷 工具

static BOOL _enableSimulator = NO;
static dispatch_once_t _onceToken;
static JEDebugTool__* _sharedManager;

@implementation JEDebugTool__

+ (instancetype)Shared{ return [[self alloc] init];}

+ (id)allocWithZone:(struct _NSZone *)zone{
#ifdef DEBUG
    dispatch_once(&_onceToken, ^{
        if ([JEKit IsSimulator] && !_enableSimulator) {
            return ;
        }
        
        _sharedManager = [super allocWithZone:zone];
        _sharedManager.beginDate = [NSDate date];
        [JEDebugToolModel CreateTable];
        [JEDebugToolModel UpdateTable];
        [JEDebugToolTimeListModel CreateTable];
        [_sharedManager loadDebugView];
        //        [[FLEXManager sharedManager] showExplorer];
    });
#endif
    
    return _sharedManager;
}

/** 转换显示或隐藏 */
+ (void)SwitchONOff{
    [JEDebugTool__ Shared]->_Btn_touch.alpha =  [JEDebugTool__ Shared].nav.view.alpha = (fabs(1 - [JEDebugTool__ Shared]->_Btn_touch.alpha));
}

+ (void)EnableSimulator{
    _enableSimulator = YES;
    if (_onceToken != 0) { _onceToken = 0; }
}

- (void)loadDebugView{
    _Btn_touch = JEBtn(JR(ScreenWidth - 50, 240,50, 50),@"on",@20,nil,self,@selector(closeOpen),kColorRed,12,nil);
    [_Btn_touch addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)]];
    self.nav = [[JEBaseNavtion alloc] initWithRootViewController:[[JEDebugMainVC alloc] init]];
    self.nav.je_navBarItemClr = kColorBlue;
    self.nav.je_navTitleClr = kColorText33;
    self.nav.view.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JEApp.window addSubview:self.nav.view];
        [JEApp.window addSubview:self.Btn_touch];
    });
}

#pragma mark  - 添加log

+ (void)LogTitle:(NSString *)title noti:(id)noti detail:(id)detail{[self LogTitle:title noti:noti detail:detail toDB:NO];}
+ (void)LogTitle:(NSString *)title noti:(id)noti detail:(id)detail toDB:(BOOL)toDB{
    if (JEdbQe == nil) {return;}
    dispatch_async(dispatch_get_main_queue(), ^{
        JEDebugMainVC *vc = [JEDebugTool__ Shared].nav.viewControllers.firstObject;
        [vc addLogWithTitle:title noti:noti detail:detail simple:nil toDB:toDB];
    });
}

+ (void)LogSimple:(id)simple{[self LogSimple:simple toDB:YES];}
+ (void)LogSimple:(id)simple toDB:(BOOL)toDB{
    if (JEdbQe == nil) {return;}
    dispatch_async(dispatch_get_main_queue(), ^{
        JEDebugMainVC *vc = [JEDebugTool__ Shared].nav.viewControllers.firstObject;
        [vc addLogWithTitle:nil noti:nil detail:nil simple:simple toDB:toDB];
    });
}

#pragma makr - 拖动手势

- (void)handlePan:(UIPanGestureRecognizer*)recognizer{
    CGFloat A = recognizer.view.transform.a;
    CGPoint translation = [recognizer translationInView:JEApp.window];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x  * (A > 10 ? (A - 10)*0.8 : 1),recognizer.view.center.y + translation.y  * (A > 10 ? (A - 10)*0.8 : 1));
    [recognizer setTranslation:CGPointZero inView:JEApp.window];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            if (recognizer.view.y > ScreenHeight - recognizer.view.height ) {recognizer.view.y = ScreenHeight - recognizer.view.height;}
            if (recognizer.view.y < 0 ) {recognizer.view.y = 0;}
            if (recognizer.view.x >= (ScreenWidth - recognizer.view.width)/2) {recognizer.view.x = ScreenWidth - recognizer.view.width;}
            if (recognizer.view.x < (ScreenWidth - recognizer.view.width)/2) {recognizer.view.x = 0;}
        }];
    }
}

- (void)closeOpen{
    _Btn_touch.selected = !_Btn_touch.selected;
    [_Btn_touch setTitle:_Btn_touch.selected ? @"off" : @"on" forState:UIControlStateNormal];
    _nav.view.hidden = !_Btn_touch.selected;
    JEDebugMainVC *vc = _nav.viewControllers.firstObject;
    if (!_nav.view.hidden && vc.Tv_list.Arr.count) {
        [vc.Tv_list reloadData];
        [vc.Tv_list scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(vc.Tv_list.Arr.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

@end

//不import 硬编码addLog
/*
+ (void)JE_Debug_AddLog:(NSString *)log{
#ifdef DEBUG
    Class debug = NSClassFromString(@"JEDebugTool__");
    if (debug) {
        SEL addLog = NSSelectorFromString(@"LogSimple:");
        if ([debug respondsToSelector:addLog]) {
            [debug performSelectorOnMainThread:addLog withObject:log waitUntilDone:YES];
        }
    }
#endif
}
*/

/*
#define JEDebugAddLog(fmt)      {Class debug = NSClassFromString(@"JEDebugTool__");\
if (debug) {SEL addLog = NSSelectorFromString(@"LogSimple:");\
if ([debug respondsToSelector:addLog]) {[debug performSelectorOnMainThread:addLog withObject:fmt waitUntilDone:YES];}}}
*/

