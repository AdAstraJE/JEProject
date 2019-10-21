
#import <UIKit/UIKit.h>
#import "JEBaseVC.h"

@interface JEWKWebviewVC : JEBaseVC

/// url =  [JEWKWebviewVC ShowVC:@""]
- (instancetype)initWithUrl:(id)url;

/// HTMLString
- (instancetype)initWithHTMLString:(NSString*)HTMLStr;

@property (nonatomic,strong) id URL;///< URL
@property (nonatomic,copy)  NSString  *HTMLString;

@end


//    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[NSURLCache sharedURLCache] setDiskCapacity:0];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
