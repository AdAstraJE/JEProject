
#import "JEStaticTVCell.h"
#import "JEKit.h"

@implementation JEStaticTVCell{
    __weak JEStvIt  *_item;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (JEShare.stc.cellColor) {
        self.backgroundColor = self.contentView.backgroundColor = JEShare.stc.cellColor;
        self.selectedBackgroundView = JEVe(JR(0, 0, self.width, self.height), JEShare.stc.cellColor.abe(1,0.1), nil);
    }
    return self;
}

- (UIImageView *)Img_icon{
    if (_Img_icon == nil) { _Img_icon = [[UIImageView alloc] init].addTo(self.contentView);_Img_icon.contentMode = UIViewContentModeScaleAspectFit;}
    return _Img_icon;
}

- (UILabel *)La_title{
    if (_La_title == nil) {
        _La_title = JELab(CGRectZero,nil,JEShare.stc.titleFont,JEShare.stc.titleColor,(0),self.contentView);
    }
    return _La_title;
}

- (UILabel *)La_detail{
    if (_La_detail == nil) {
        _La_detail = JELab(CGRectZero,nil,JEShare.stc.detailFont,JEShare.stc.detailColor,(0),self.contentView); }
    return _La_detail;
}

- (UILabel *)La_desc{
    if (_La_desc == nil) {_La_desc = JELab(CGRectZero,nil,JEShare.stc.descFont,JEShare.stc.descColor,(2),self.contentView);}
    return _La_desc;
}

- (UISwitch *)Swi{
    if (_Swi == nil) {
        _Swi = [[UISwitch alloc] init].addTo(self.contentView);
        [_Swi addTarget:self action:@selector(swiValueChange) forControlEvents:UIControlEventValueChanged];
        if (JEShare.stc.swiColor) { _Swi.tintColor =  _Swi.onTintColor = JEShare.stc.swiColor; }
    }
    return _Swi;
}

- (void)swiValueChange{
    _item.switchOn = _Swi.on;
    !_item.switchBlock ? : _item.switchBlock(_item,_Swi.on);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_item) {self.alpha = _item.cellAlpha;}
   
    CGFloat viewH = JEShare.stc.iconWH,margin = JEShare.stc.margin,descW = ScreenWidth*0.5,descMargin = self.accessoryType == 1 ? 4 : JEShare.stc.margin;
    if (viewH > self.height) {
        viewH = self.height/2;
    }
    _Img_icon.frame = CGRectMake(margin, (self.height - viewH)/2, viewH, viewH);
    _La_title.frame = CGRectMake(_Img_icon.right + margin, (self.height - viewH)/2, ScreenWidth - 40, viewH);
    if (_item.desc.length) {
        _La_title.frame = CGRectMake(_Img_icon.right + margin, (self.height - viewH)/2, ScreenWidth*0.6, viewH);
    }
    _La_desc.frame = CGRectMake(self.contentView.width - descW - descMargin, (self.height - viewH)/2, descW, viewH);
    _item.middleView.origin = CGPointMake((self.width - _item.middleView.width)/2, (self.height - _item.middleView.height)/2);
    if (_La_detail) {
        viewH = viewH*0.8;
        CGFloat topBottomMargin = (_item.cellHeight - viewH*2)/2;
        _La_title.frame = CGRectMake(_La_title.x, topBottomMargin, ScreenWidth - 40, viewH);
        _La_detail.frame = CGRectMake(_La_title.x, _La_title.bottom + viewH*0.1, ScreenWidth*0.7, viewH);
    }
    self.separatorInset = UIEdgeInsetsMake(0, _La_title.x, 0, 0);
    [self resetTitleDescFrame];
}

- (instancetype)je_loadCell:(JEStvIt *)item{
    _item = item;
    if (item.middleView) {
        item.middleView.addTo(self.contentView);
        return self;
    }
    if (item.icon) { self.Img_icon.image = item.icon;}
    if (item.title) { self.La_title.text = item.title;}
    if (item.detail) { self.La_detail.text = item.detail;}
    if (item.desc) { self.La_desc.text = item.desc;}
    
    if ([self isKindOfClass:JEStaticTVCell.class]) {
        self.accessoryType = item.accessory;
        self.selectionStyle = (item.accessory == UITableViewCellAccessoryDisclosureIndicator ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone);
    }
    
    if (item.switchBlock) {
        self.accessoryView = self.Swi;
        _Swi.on = item.switchOn;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)resetTitleDescFrame{
    [_La_title sizeThatWidth];
    CGFloat descMargin = self.accessoryType == 1 ? 4 : JEShare.stc.margin;
    CGFloat w = self.contentView.width - _La_title.right - descMargin;
    _La_desc.frame = JR(_La_title.right, _La_desc.y, w, _La_desc.height);
}

@end
