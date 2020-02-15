//
//  JETableViewCell.h
//  BiLinXing
//
//  Created by JE on 2020/2/6.
//  Copyright © 2020 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell   🔷🔷🔷🔷🔷🔷🔷🔷
/// base
@interface JETableViewCell : UITableViewCell

- (void)handelStyleDark;

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell1   🔷🔷🔷🔷🔷🔷🔷🔷
/// 左边textLabel，右边detailTextLabel， UITableViewCellAccessoryDisclosureIndicator
@interface JETableViewCell1 : JETableViewCell

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell3   🔷🔷🔷🔷🔷🔷🔷🔷
/// 左边textLabel，下边detailTextLabel， UITableViewCellAccessoryDisclosureIndicator
@interface JETableViewCell3 : JETableViewCell

@end

NS_ASSUME_NONNULL_END
