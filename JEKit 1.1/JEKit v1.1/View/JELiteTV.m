
#import "JELiteTV.h"
#import "JEKit.h"
#import <UITableView+FDTemplateLayoutCell.h>

@implementation JELiteTV{
    Class _cellClass;
    NSString *_cellIdentifier;
}

+ (JELiteTV *)Frame:(CGRect)frame style:(UITableViewStyle)style cellC:(nullable Class)cellClass cellH:(CGFloat)cellHeight
               cell:(nullable void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idxP,id obj))cell select:(nullable void (^)(UITableView *tv,NSIndexPath *idxP,id obj))select to:(UIView * _Nullable)to{
    JELiteTV *tv = [[self alloc] initWithFrame:frame style:style cellC:cellClass cellH:cellHeight];
    tv.cell = cell;
    tv.select = select;
    tv.addTo(to);
    return tv;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellC:(Class)cellClass cellH:(CGFloat)cellH{
    self = [super initWithFrame:frame style:style];
    self.delegate = self;
    self.dataSource = self;
    if (style == UITableViewStylePlain) { self.tableFooterView = [UIView new];}
    if (cellClass) {
        _cellClass = cellClass;
        [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
    self.rowHeight = cellH;
    self.sectionHeaderHeight = [JEKit Shared].stc.sectionHeaderHeight;
    self.sectionFooterHeight = [JEKit Shared].stc.sectionFooterHeight;
    
    self.contentInsetBottom = (self.sectionHeaderHeight + self.sectionFooterHeight)*2;
    
    return self;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    [super registerClass:cellClass forCellReuseIdentifier:identifier];
    _cellIdentifier = identifier;
}

- (NSMutableArray *)dataSourceArr{
    return (_customDataSourceArr ? _customDataSourceArr() : self.Arr);
}

#pragma mark - UITableView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections ? _sections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rows ? _rows(tableView,section) : (_sections ? 1 : self.dataSourceArr.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_useFDTemplateLayoutCell) {
        WSELF
        return [tableView fd_heightForCellWithIdentifier:_cellIdentifier cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell) {
            cell.fd_enforceFrameLayout = YES;
            if (wself.cell) {
                wself.cell(cell,tableView,indexPath,(wself.dataSourceArr[(wself.sections ? indexPath.section : indexPath.row)]));
            }else{
                [cell je_loadCell:wself.dataSourceArr[(wself.sections ? indexPath.section : indexPath.row)]];
            }
        }];
    }
    
    return  _rowH ? _rowH(tableView,indexPath) : tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.style == UITableViewStylePlain && _header == nil) { return 0;}
    return _headH ? _headH(tableView,section) : self.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.style == UITableViewStylePlain && _header == nil) { return 0;}
    return _footH ? _footH(tableView,section) : self.sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _header ? _header(tableView,section) : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footer ? _footer(tableView,section) : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _headerTitle ? _headerTitle(tableView,section) : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return _footerTitle ? _footerTitle(tableView,section) : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cell) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
        if (_cellClass == UITableViewCell.class && _select == nil) { cell.selectionStyle = UITableViewCellSelectionStyleNone;}
        _cell(cell,tableView,indexPath,(self.dataSourceArr[(_sections ? indexPath.section : indexPath.row)]));
     
        return cell;
    }
    if (_cells) { return _cells(tableView,indexPath);}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    [cell je_loadCell:self.dataSourceArr[(_sections ? indexPath.section : indexPath.row)]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    !_select ? : _select(tableView,indexPath,self.dataSourceArr[(_sections ? indexPath.section : indexPath.row)]);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _editingStyle ? _editingStyle(tableView,indexPath) : UITableViewCellEditingStyleNone;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _editActions ? _editActions(tableView,indexPath) : nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    !_commitEditingStyle ? : _commitEditingStyle(tableView,editingStyle,indexPath,self.dataSourceArr[(_sections ? indexPath.section : indexPath.row)]);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    !_accessoryButtonTap ? : _accessoryButtonTap(tableView,indexPath,self.dataSourceArr[(_sections ? indexPath.section : indexPath.row)]);
}

@end
