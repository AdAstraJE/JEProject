
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JEDBModel.h"
#import "JEBaseVC.h"
@class JEDebugToolModel;

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugToolModel   🔷 显示模型

@interface JEDebugToolModel : JEDBModel
@property (nonatomic,copy) NSString *indexTime;///< 请求时间
@property (nonatomic,copy) NSString *API;///< 请求地址
@property (nonatomic,copy) NSString *param;///< 请求参数
@property (nonatomic,copy) NSString *des;///< 原始请求结果

@property (nonatomic,copy) NSString *simple;///< 简约唯一显示的
@property (nonatomic,copy) NSString *MD5;///< 区分重复用
@property (nonatomic,assign) NSInteger repeate;///< 重复次数
@property (nonatomic,assign) BOOL hidde;///< 隐藏这条数据

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugMainVC   🔷 数据显示VC

@interface JEDebugMainVC : JEBaseVC <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSDate *historyDate;///< 某个历史列表时间
@property (nonatomic,strong) JEDebugToolModel *detailMod;///< 要显示某个的详情
@property (nonatomic,strong) UITableView *Tv_list;

- (void)addLogWithTitle:(NSString *)title noti:(id)noti detail:(id)detail simple:(id)simple toDB:(BOOL)toDB;

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugTimeListTVC   🔷 历史时间列表VC

@interface JEDebugTimeListVC : JEBaseVC

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEDebugTool__   🔷

@interface JEDebugTool__ : NSObject

@property (nonatomic,strong) UINavigationController *nav;
@property (nonatomic,strong) UIButton *Btn_touch;///< open close 悬浮小按钮
@property (nonatomic,strong) NSDate *beginDate;///< Log开始时间

- (void)closeOpen;///< 开关控制
    
+ (JEDebugTool__ *)Shared;

+ (void)EnableSimulator;

/** 转换显示或隐藏 */
+ (void)SwitchONOff;

/** 标准添加log     ( id -> NSArray,NSDictionary,NSString,NSNumber )    */
+ (void)LogTitle:(NSString *)title noti:(id)noti detail:(id)detail;
+ (void)LogTitle:(NSString *)title noti:(id)noti detail:(id)detail toDB:(BOOL)toDB;

/** 简单添加log  默认存进数据库 */
+ (void)LogSimple:(id)simple;
+ (void)LogSimple:(id)simple toDB:(BOOL)toDB;

@end


