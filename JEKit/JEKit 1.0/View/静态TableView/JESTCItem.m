
#import "JESTCItem.h"
#import "JEStaticTVCell.h"
#import "UILabel+JE.h"
#import "JEKit.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JESTCStyle   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JESTCUIStyle

+ (JESTCUIStyle *)DefaultStyle{
    JESTCUIStyle *mod = [[JESTCUIStyle alloc] init];
    mod.sectionHeaderHeight = 12.0f;
    mod.sectionFooterHeight = 1.0f;
    mod.defaultCellHeight = MAX(48.0f, ScrnAdapt(48.0f));
    mod.margin = 15;
    mod.iconWH = 22;
    mod.iconTitleMargin = 10;
    mod.titleFont = font(14);
    mod.titleColor = kColorText;
    mod.descFont = font(14);
    mod.descColor = kColorText66;
    return mod;
}

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JESTCItem   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JESTCItem

+ (JESTCItem *)Title:(NSString *)title select:(JESTCSelectBlock)select{
    return [self Icon:nil title:title desc:nil indicator:YES customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.defaultCellHeight select:select];
}

+ (JESTCItem *)Title:(NSString *)title indicator:(BOOL)indicator select:(JESTCSelectBlock)select{
    return [self Icon:nil title:title desc:nil indicator:indicator customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.defaultCellHeight select:select];
}

+ (JESTCItem *)Title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator select:(JESTCSelectBlock)select{
    return [self Icon:nil title:title desc:desc indicator:indicator customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.defaultCellHeight select:select];
}

+ (JESTCItem *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator select:(JESTCSelectBlock)select{
    return [self Icon:icon title:title desc:desc indicator:indicator customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.defaultCellHeight select:select];
}

+ (JESTCItem *)CustomCell:(Class <JEStaticTVCellDelegate>)customCell height:(CGFloat)height select:(JESTCSelectBlock)select{
    return [self Icon:nil title:nil desc:nil indicator:NO customCell:customCell Switch:nil on:NO height:height select:select];
}

+ (JESTCItem *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator Switch:(JESTCSwitchBlock)Switch on:(BOOL)switchOn select:(JESTCSelectBlock)select{
    return [self Icon:icon title:title desc:desc indicator:indicator customCell:JEStaticTVCell.class Switch:Switch on:switchOn height:JEShare.stc.defaultCellHeight select:select];
}

+ (JESTCItem *)CustomView:(UIView *)view height:(CGFloat)height select:(JESTCSelectBlock)select{
    JESTCItem *item = [self Icon:nil title:nil desc:nil indicator:NO customCell:JEStaticTVCell.class Switch:nil on:NO height:height select:select];
    [item.cell.contentView addSubview:view];
    return item;
}

+ (JESTCItem *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc indicator:(BOOL)indicator customCell:(Class)customCell Switch:(JESTCSwitchBlock)Switch on:(BOOL)switchOn height:(CGFloat)height select:(JESTCSelectBlock)select{
    JESTCItem *item = [[JESTCItem alloc] init];
    
    if ([icon isKindOfClass:[NSString class]]){ item.icon = [UIImage imageNamed:(NSString *)icon];
    }else if ([icon isKindOfClass:[UIImage class]]){ item.icon = icon;}
    
    item.title = title;
    item.desc = desc;
    item.showIndicator = indicator;
    item.accessory = indicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    item.cellHeight = height;
    item.cellAlpha = 1;
    item.selectBlock = select;
    if (customCell == nil) {
        customCell = JEStaticTVCell.class;
    }
    
    item.switchOn = switchOn;
    item.switchBlock = Switch;
    item.cell = [[customCell alloc] init];
    
    return item;
}

/** 显示在中间的文本 */
+ (JESTCItem *)MiddleNoti:(NSString *)noti font:(UIFont *)font color:(UIColor *)color select:(JESTCSelectBlock)select{
    JESTCItem *item = [[JESTCItem alloc] init];
    item.cellAlpha = 1;
    item.cellHeight = JEShare.stc.defaultCellHeight;
    item.middleView = [UILabel Frame:CGRectMake(0,0, -1, item.cellHeight) text:noti font:font color:color align:NSTextAlignmentCenter];
    [(UILabel *)item.middleView sizeThatWidth];
    item.selectBlock = select;
    item.cell = [[JEStaticTVCell.class alloc] init];
    return item;
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    _cell.Img_icon.image = icon;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _cell.La_title.text = title;
}

- (void)setDetail:(NSString *)detail{
    _detail = detail;
    _cell.La_detail.text = detail;
}

- (void)setDesc:(NSString *)desc{
    _desc = desc;
    _cell.La_desc.text = desc;
}

- (void)setSwitchOn:(BOOL)switchOn{
    _switchOn = switchOn;
    _cell.Swi.on = switchOn;
}

- (void)setAccessory:(UITableViewCellAccessoryType)accessory{
    _accessory = accessory;
    _cell.accessoryType = accessory;
}

@end
