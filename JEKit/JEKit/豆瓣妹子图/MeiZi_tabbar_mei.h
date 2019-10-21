//
//  vc1.h
//  
//
//  Created by JE on 2017/3/28.
//  Copyright © 2017年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JEBaseVC.h"
#import "JEAppScheme.h"

@interface MeiZiUser : NSObject <JESchemeDelegate>

@property (nonatomic,copy) NSString *name;///< name
@property (nonatomic,copy) NSString *userId;///< userId

@end

@interface MeiZi_tabbar_mei : JEBaseVC

@end
