
#import "JEStaticTableView.h"
#import "JEKit.h"

static NSInteger const jkHeadFootLabelMargin = 15;///<

@implementation JEStaticTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if(JEShare.stc.backgroundColor){self.backgroundColor = JEShare.stc.backgroundColor;};
    self.sectionHeaderHeight = JEShare.stc.sectionHeaderHeight;
    self.sectionFooterHeight = JEShare.stc.sectionFooterHeight;

    self.delegate = (id<UITableViewDelegate>)self;
    self.dataSource = (id<UITableViewDataSource>)self;
    self.contentInsetBottom = (self.sectionHeaderHeight + self.sectionFooterHeight)*2;
    
    return self;
}

- (void)setArr_item:(NSArray <NSArray <JEStvIt *> *> *)Arr_item{
    _Arr_item = Arr_item;
    [self reloadData];
}

- (void)setArr_headerTitle:(NSArray<NSString *> *)Arr_headerTitle{
    _Arr_headerTitle = Arr_headerTitle;
    if(_adjustHeaderHeight == 0){_adjustHeaderHeight = 14;}
}

- (void)setArr_footerTitle:(NSArray<NSString *> *)Arr_footerTitle{
    _Arr_footerTitle = Arr_footerTitle;
    if(_adjustFooterHeight == 0){_adjustFooterHeight = 14;}
}

- (CGFloat)adjustHeadFoot:(NSArray <NSString *> *)arr value:(NSInteger)value section:(NSInteger)section{
    if (section < arr.count) {
        if (arr[section].length == 0) {
            return 0;
        }
        return [arr[section] sizeWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] maxSize:CGSizeMake(self.width - jkHeadFootLabelMargin*2, 0)].height + value;
    }
    return value;
}

#pragma mark - UITableView Delegate DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _Arr_item[indexPath.section][indexPath.row].cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _Arr_item[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _Arr_item.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return (section < _Arr_headerTitle.count) ? _Arr_headerTitle[section] : nil;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return (section < _Arr_footerTitle.count) ? _Arr_footerTitle[section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section >= _Arr_headerTitle.count) {return self.sectionHeaderHeight;}
    if (_adjustHeaderHeight != 0 && _Arr_headerTitle[section].length != 0) {
        return [self adjustHeadFoot:_Arr_headerTitle value:_adjustHeaderHeight section:section] + jkHeadFootLabelMargin;
    }
    return self.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_adjustFooterHeight != 0) {
        return [self adjustHeadFoot:_Arr_footerTitle value:_adjustFooterHeight section:section];
    }
    return self.sectionFooterHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JEStvIt *item = _Arr_item[indexPath.section][indexPath.row];//静态cell不复用
    [item.cell je_loadCell:item];
    return item.cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JEStvIt *item = _Arr_item[indexPath.section][indexPath.row];
    !item.selectBlock ? : item.selectBlock(item);
}

@end
