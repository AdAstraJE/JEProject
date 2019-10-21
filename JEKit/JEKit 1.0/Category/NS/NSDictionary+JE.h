//
//  NSDictionary+JE.h
//   
//
//  Created by JE on 16/8/7.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JE)

/** create MJExtension xcode @property (nonatomic, ----- *** */
- (NSString *)je_propertyCodeMJ:(NSString*)modName;

/** create YYmodel xcode @property (nonatomic, ----- *** */
- (NSString *)je_propertyCodeYY:(NSString*)modName;

/** 将NSDictionary转换成url 参数字符串 */
@property (nonatomic,copy,readonly) NSString *URLQueryString;

    
@end




