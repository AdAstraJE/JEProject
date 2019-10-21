//
//  JEPickerView.h
//  
//
//  Created by JE on 16/3/28.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JEBaseBackView.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEPickerView   🔷
@interface JEPickerView : JEBaseBackView <UIPickerViewDelegate,UIPickerViewDataSource>

typedef void(^JEPVCusArrBlock)(NSInteger index,NSString *title);
typedef void(^JEPVLocationBlock)(NSArray <NSString * > *area,NSString *mixStr);
typedef void(^JEPVDateBlock)(NSDate *date);

@property (nonatomic,copy) JEPVCusArrBlock cusArrBlock;
@property (nonatomic,copy) JEPVDateBlock dateBlock;

@property (nonatomic,strong) UIView *Ve_actionBar;///< 取消 确定
@property (nonatomic,strong) UIPickerView *pickV;
@property (strong, nonatomic) UIDatePicker *datePicker;

/** 自定义的数组 */
+ (void)ShowCustomArr:(NSArray <NSString *>*)arr res:(JEPVCusArrBlock)block;
+ (void)ShowCustomArr:(NSArray <NSString *>*)arr title:(NSString *)title res:(JEPVCusArrBlock)block;
+ (void)ShowCustomArr:(NSArray <NSString *>*)arr title:(NSString *)title current:(id)current res:(JEPVCusArrBlock)block;

/** 时间选择器 */
+ (void)ShowDatePicker:(JEPVDateBlock)date;
+ (void)ShowDatePicker:(JEPVDateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max;
+ (void)ShowDatePicker:(JEPVDateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max mode:(UIDatePickerMode)mode;
+ (void)ShowDatePicker:(JEPVDateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max title:(NSString *)title mode:(UIDatePickerMode)mode;

/** 地区选择 三项 省-市-区 */
+ (void)ShowLocationPick:(JEPVLocationBlock)loca;
/** 地区选择 两项 省-市 */
+ (void)ShowLocationPick:(JEPVLocationBlock)loca both:(BOOL)both;
+ (void)ShowLocationPick:(JEPVLocationBlock)loca both:(BOOL)both currentCity:(NSString *)currentCity;

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEPickerView_City   🔷 地区选择
@interface JEPickerView_City : JEPickerView

@property (nonatomic,copy) JEPVLocationBlock locationBlock;

- (instancetype)initWithFrame:(CGRect)frame loca:(JEPVLocationBlock)loca both:(BOOL)both currentCity:(NSString *)currentCity;

@end
