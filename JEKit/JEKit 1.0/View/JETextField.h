//
//  JETextField.h
//
//  Created by JE on 15/8/22.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JETextField : UITextField

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font clr:(UIColor *)clr placeholder:(NSString *)placeholder;

@property (nonatomic,assign) CGRect moreTouchMargin;///< 给予更多的边界 点击范围 按照UIEdgeInsets 用
@property (nonatomic,assign) BOOL noTouchInEditing;///< 编辑的时候不允许点击 覆盖个透明的view

/** 右边也加placeHolder */
- (void)addRightPlaceHolder:(NSString *)placeHolder;

@property (nonatomic,assign)  BOOL isTelePhone;///< 认为是电话号码(11位) 按电话号码的限制输入 
@property (nonatomic,assign)  NSUInteger divisions;///< 每隔X 分割一个空格
@property (nonatomic,assign)  BOOL JENumber;///< 纯数字形式的输入
@property (nonatomic,assign)  BOOL JENumber_dot;///< 数字形式的输入 可以有小数点 点后最多JENumber_dotLimit位数
@property (nonatomic,assign)  NSUInteger JENumber_dotLimit;///< 点后最多X位数 ### 2
@property (nonatomic,assign)  BOOL JEMust_ASCII;///< 必须是 ASCII字符 
@property (nonatomic,assign)  BOOL JEMust_AZ09;///< 必须是 字母和数字
@property (nonatomic,assign)  NSUInteger JEMaxCharactersLength;///< 强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！)
@property (nonatomic,assign)  NSUInteger JEMaxTextLength;///< 强制按text.length长度计算限制文本的最大长度

/** 当前选择的范围 */
- (NSRange)selectedRange;

/** 设置选择范围 */
- (void)setSelectedRange:(NSRange) range;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@property (nonatomic,copy) void (^didEndBlock)(UITextField *textField);

@end
