
#import "JEStaticTableView.h"
#import "JEKit.h"

@implementation JEStaticTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    self.sectionHeaderHeight = JEShare.stc.sectionHeaderHeight;
    self.sectionFooterHeight = JEShare.stc.sectionFooterHeight;
    if (JEShare.stc.backgroundColor) { self.backgroundColor = JEShare.stc.backgroundColor;}

    self.delegate = (id<UITableViewDelegate>)self;
    self.dataSource = (id<UITableViewDataSource>)self;
    self.contentInset = UIEdgeInsetsMake(0, 0, (self.sectionHeaderHeight + self.sectionFooterHeight)*2, 0);
    return self;
}

- (void)setArr_item:(NSArray <NSArray <JESTCItem *> *> *)Arr_item{
    _Arr_item = Arr_item;
    [self reloadData];
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
    return self.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.sectionFooterHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JESTCItem *item = _Arr_item[indexPath.section][indexPath.row];//静态cell不复用
    [item.cell loadCell:item];
    return item.cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JESTCItem *item = _Arr_item[indexPath.section][indexPath.row];
    !item.selectBlock ? : item.selectBlock(item);
}

@end
