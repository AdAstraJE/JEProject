//
//  JEScrIndexView.h
//
//
//  Created by JE on 16/4/6.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const jkDefaultScrIndexTitleViewH = 44;///<

@interface JEScrIndexView : UIView

//------------------------------------------------------------------------------------------------------------
@property(nonatomic,assign) CGFloat titleViewHeight;///<  标题scrollview 的高
@property(nonatomic,strong) UIColor *titleColore;///<  字体 颜色
@property(nonatomic,strong) UIColor *tintColore;///<  字体 滑块 颜色
@property(nonatomic,strong) UIFont *titleFont;///<  标题 字体
@property(nonatomic,assign) CGFloat marginPer;///< 文字框间距百分比 默认0
@property (nonatomic,assign) CGFloat btnWidth;///< 按钮宽 默认 60
@property (nonatomic,assign) CGFloat sliderBoardPer;///<  小滑块的百分比长
//------------------------------------------------------------------------------------------------------------

@property(nonatomic,strong,readonly) UIView *Ve_line;///<  滑块底部线条
@property(nonatomic,strong,readonly) UIView *Ve_boardLine;///<  滑块线条

@property (nonatomic,strong) NSArray <NSNumber *> *advances;///< 预先加载VC eg. @[@(-1),@(1),@(2)] = 预先加载左边1个 右边1个第2个
@property(nonatomic,strong,readonly) UIScrollView *Scr_scroll_;///<  下面的容器
@property(nonatomic,strong,readonly) NSMutableArray <__kindof UIViewController *> *Arr_vc;///<  自定义vc
@property(nonatomic,strong,readonly) NSMutableArray <__kindof UIView *> *Arr_view;///<  自定义view
@property(nonatomic,strong,readonly) NSMutableArray <UIButton*> *Arr_btns;///< 按钮 

typedef UIViewController *(^LazyLoadBlock)(NSInteger index);
@property (nonatomic,copy) LazyLoadBlock lazyLoadBlock;


/** 懒加载view */
- (instancetype)initWithFrame:(CGRect)frame lazyLoadView:(LazyLoadBlock)block;

/** 设置样式后 再设置标题 */
- (void)loadTitles:(NSArray <NSString *> *)titles;

/** 修改文字 */
- (void)changeTitleAt:(NSInteger)index title:(NSString*)title;

/** 滑到指定位置 0 1 2 3 4 */
- (__kindof UIView *)sliderToIndex:(NSInteger)index;


@end
