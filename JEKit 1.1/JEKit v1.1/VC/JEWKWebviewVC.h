
#import <UIKit/UIKit.h>
#import "JEBaseVC.h"

@interface JEWKWebviewVC : JEBaseVC

/// url =  [JEWKWebviewVC ShowVC:@""]
- (instancetype)initWithUrl:(id)url;

/// HTMLString
- (instancetype)initWithHTMLString:(NSString*)HTMLStr;

@property (nonatomic,strong) id URL;///< URL
@property (nonatomic,copy)  NSString  *HTMLString;
@property (nonatomic,assign) BOOL handelDarkModel;///< 简单处理黑色模式 ### NO
@property (nonatomic,assign) BOOL disableShareAction;


@end


//    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[NSURLCache sharedURLCache] setDiskCapacity:0];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];

//#import <SafariServices/SafariServices.h>
//SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"] entersReaderIfAvailable:YES];
//safariVC.delegate = self;
//[self presentViewController:safariVC animated:YES completion:nil];
