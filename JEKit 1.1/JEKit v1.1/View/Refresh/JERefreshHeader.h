

#import "MJRefreshHeader.h"

@interface JERefreshHeader : MJRefreshHeader

@property (assign, nonatomic) BOOL JENetworkingFail;///< 网络请求失败过 

@property (strong, nonatomic) UIColor *color;///< arrow color
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;

@end
