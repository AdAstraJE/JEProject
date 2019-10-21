//
//  JEWKWebviewVC.h
//   
//
//  Created by JE on 16/8/12.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JEBaseVC.h"

@interface JEWKWebviewVC : JEBaseVC

/** openURL */
+ (void)Open:(NSString *)url;

/**< url */
- (instancetype)initWithUrl:(NSString*)url;

/**< HTMLString */
- (instancetype)initWithHTMLString:(NSString*)HTMLStr;

@property NSString  *H5Url;
@property NSString  *HTMLString;

@end
