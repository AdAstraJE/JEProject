
#import "JEStvIt.h"
#import "JEStaticTVCell.h"
#import "UILabel+JE.h"
#import "JEKit.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEStvUIStyle   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEStvUIStyle

+ (JEStvUIStyle *)DefaultStyle{
    JEStvUIStyle *mod = [[JEStvUIStyle alloc] init];
    mod.backgroundColor = JEShare.tvBgClr;
//    mod.cellHeight = MAX(48.0f, ScrnAdapt(45.0f));
    mod.cellHeight = 48.0f;
    mod.sectionHeaderHeight = mod.cellHeight*0.618;
    mod.sectionFooterHeight = 1.0f;
    mod.margin = 15;
    mod.iconWH = mod.cellHeight*0.618;
    mod.iconTitleMargin = 12;
    mod.titleFont = font(15);
    mod.descFont = font(14);
    mod.descColor = Tgray1;
    mod.detailFont = font(11);
    mod.detailColor = Tgray1;
    
    return mod;
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEStvIt   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JEStvIt

JEStvIt *JEStvIt_(id icon, NSString *title, NSString *desc, UITableViewCellAccessoryType acc, JEStvSelectBlock block){
    JEStvIt *item = [JEStvIt Icon:icon title:title desc:desc acc:acc select:block];
    item.accessory = acc;
    return item;
}

+ (JEStvIt *)Title:(NSString *)title select:(JEStvSelectBlock)select{
    return [self Icon:nil title:title desc:nil acc:1 customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.cellHeight select:select];
}

+ (JEStvIt *)Title:(NSString *)title desc:(NSString *)desc select:(JEStvSelectBlock)select{
    return [self Icon:nil title:title desc:desc acc:1 customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.cellHeight select:select];
}

+ (JEStvIt *)Title:(NSString *)title Switch:(JEStvSwitchBlock)Switch on:(BOOL)switchOn{
    return [self Icon:nil title:title desc:nil acc:0 customCell:JEStaticTVCell.class Switch:Switch on:switchOn height:JEShare.stc.cellHeight select:nil];
}

+ (JEStvIt *)Title:(NSString *)title acc:(UITableViewCellAccessoryType)acc select:(JEStvSelectBlock)select{
    return [self Icon:nil title:title desc:nil acc:acc customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.cellHeight select:select];
}

+ (JEStvIt *)Title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc select:(JEStvSelectBlock)select{
    return [self Icon:nil title:title desc:desc acc:acc customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.cellHeight select:select];
}

+ (JEStvIt *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc select:(JEStvSelectBlock)select{
    return [self Icon:icon title:title desc:desc acc:acc customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.cellHeight select:select];
}

+ (JEStvIt *)Icon:(id)icon title:(NSString *)title select:(JEStvSelectBlock)select{
    return [self Icon:icon title:title desc:nil acc:1 customCell:JEStaticTVCell.class Switch:nil on:NO height:JEShare.stc.cellHeight select:select];
}

+ (JEStvIt *)CustomCell:(Class)customCell height:(CGFloat)height select:(JEStvSelectBlock)select{
    return [self Icon:nil title:nil desc:nil acc:0 customCell:customCell Switch:nil on:NO height:height select:select];
}

+ (JEStvIt *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc Switch:(JEStvSwitchBlock)Switch on:(BOOL)switchOn select:(JEStvSelectBlock)select{
    return [self Icon:icon title:title desc:desc acc:acc customCell:JEStaticTVCell.class Switch:Switch on:switchOn height:JEShare.stc.cellHeight select:select];
}

+ (JEStvIt *)CustomView:(UIView *)view height:(CGFloat)height select:(JEStvSelectBlock)select{
    JEStvIt *item = [self Icon:nil title:nil desc:nil acc:0 customCell:JEStaticTVCell.class Switch:nil on:NO height:height select:select];
    [item.cell.contentView addSubview:view];
    return item;
}

+ (JEStvIt *)Icon:(id)icon title:(NSString *)title desc:(NSString *)desc acc:(UITableViewCellAccessoryType)acc customCell:(Class)customCell Switch:(JEStvSwitchBlock)Switch on:(BOOL)switchOn height:(CGFloat)height select:(JEStvSelectBlock)select{
    JEStvIt *item = [[JEStvIt alloc] init];
    
    if ([icon isKindOfClass:[NSString class]]){ item.icon = [UIImage imageNamed:(NSString *)icon].templateClr();
    }else if ([icon isKindOfClass:[UIImage class]]){ item.icon = ((UIImage *)icon).templateClr();}
    
    item.title = title;
    item.desc = desc;
    item.accessory = acc;
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

+ (JEStvIt *)MiddleNoti:(NSString *)noti font:(UIFont *)font color:(UIColor *)color select:(JEStvSelectBlock)select{
    JEStvIt *item = [[JEStvIt alloc] init];
    item.cellAlpha = 1;
    item.cellHeight = JEShare.stc.cellHeight;
    item.middleView = [UILabel Frame:CGRectMake(0,0, -1, item.cellHeight) text:noti font:font color:color align:NSTextAlignmentCenter];
    [(UILabel *)item.middleView sizeThatWidth];
    item.selectBlock = select;
    item.cell = [[JEStaticTVCell.class alloc] init];
    return item;
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    if (![_cell.class isKindOfClass:JEStaticTVCell.class]) {return;}
    _cell.Img_icon.image = icon;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if (![_cell isKindOfClass:JEStaticTVCell.class]) {return;}
    _cell.La_title.text = title;
    [_cell resetTitleDescFrame];
}

- (void)setDetail:(NSString *)detail{
    _detail = detail;
    if (![_cell isKindOfClass:JEStaticTVCell.class]) {return;}
    _cell.La_detail.text = detail;
}

- (void)setDesc:(NSString *)desc{
    _desc = desc;
    if (![_cell isKindOfClass:JEStaticTVCell.class]) {return;}
    _cell.La_desc.text = desc;
}

- (void)setSwitchOn:(BOOL)switchOn{
    _switchOn = switchOn;
    _cell.Swi.on = switchOn;
}

- (void)setCellAlpha:(CGFloat)cellAlpha{
    _cellAlpha = cellAlpha;
    _cell.alpha = cellAlpha;
}

-(void)setDisable:(BOOL)disable{
    _disable = disable;
    _cell.userInteractionEnabled = !disable;
    _cellAlpha = !_disable ? 1 : 0.5;
    [_cell layoutSubviews];
}

- (void)setSwitchOn:(BOOL)switchOn animated:(BOOL)animated{
    _switchOn = switchOn;
    [_cell.Swi setOn:switchOn animated:animated];
}

- (void)setAccessory:(UITableViewCellAccessoryType)accessory{
    _accessory = accessory;
    _cell.accessoryType = accessory;
}

@end
