
#import "JEBaseTVC.h"
#import "JEKit.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEBaseTVC   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JEBaseTVC

- (void)dealloc{
    jkDeallocLog
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = JEShare.VCBackgroundColor;
  
    if (!self.disabel_je_NavBar) {
        [self je_useCustomNavBar];
    }
    [self.view bringSubviewToFront:self.Ve_jeNavBar];
    
    self.tableView.contentInset = UIEdgeInsetsMake(ScreenStatusBarH + 20, 0, 0, 0);

    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        
        self.tableView.contentInset = UIEdgeInsetsMake(ScreenStatusBarH + 24, 0, 0, 0);
        if (ScreenSafeArea != 0) {
            self.tableView.contentInset = UIEdgeInsetsMake(ScreenStatusBarH, 0, 0, 0);
        }
    }
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    self.tableView.separatorColor = JEShare.tableSeparatorColor;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        self.Ve_jeNavBar.y = self.tableView.bounds.origin.y;
    }
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.style == UITableViewStylePlain) {
        return section == 0 ? 0.1 : 12;
    }
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{ return 0.1;}

- (void)tapToEndEditing{
    WSELF
    [self.tableView tapGesture:^(UIGestureRecognizer *Ges) {
        [wself.tableView endEditing:YES];
    }];
}

- (void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell1   🔷🔷🔷🔷🔷🔷🔷🔷
/** UITableViewCellStyleValue1 */
@implementation JETableViewCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    return self;
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷 JETableView  🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JETableView{
    __weak UIImageView *_Img_expand;
    CGFloat _expandOrginHeight;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    [self defaultConfigure];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self defaultConfigure];
    return self;
}

/** 修改有点击效果 */
- (void)defaultConfigure{
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _headExpandEffect = NO;
    
    if (@available(iOS 11.0, *)) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    
    self.delaysContentTouches = NO;
    if (JEShare.tableBackgroundColor) { self.backgroundColor = JEShare.tableBackgroundColor; }
    if (JEShare.tableSeparatorColor) { self.separatorColor = JEShare.tableSeparatorColor; }
    
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    if (self.separatorColor == nil && JEShare.tableSeparatorColor) {
        self.separatorColor = JEShare.tableSeparatorColor;
    }
}

/** 手指点在按钮上 依然可以滑动 */
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (void)setHeadExpandEffect:(BOOL)headExpandEffect{
    _headExpandEffect = headExpandEffect;
    if (headExpandEffect) {
        [self.tableHeaderView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]] && CGRectEqualToRect(obj.bounds, self.tableHeaderView.bounds)) {
                self->_Img_expand = obj;self->_expandOrginHeight = self.tableHeaderView.height;*stop = YES;
            }
        }];
    }
}

/** 跟随滑动拉伸效果的view */
- (void)expandEffectView:(UIImageView *)imgv{
    _headExpandEffect = YES;
    _expandOrginHeight = imgv.height;
    _Img_expand = imgv;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_headExpandEffect && _Img_expand) {
        CGFloat y = scrollView.contentOffset.y + self.contentInset.top;
        CGRect orginRect = CGRectMake(0, 0, ScreenWidth, _expandOrginHeight);
        if (y < 0) {
            _Img_expand.frame = CGRectMake((ScreenWidth - (orginRect.size.width - y))/2,y, orginRect.size.width - y, orginRect.size.height - y);
        }else{
            _Img_expand.frame = orginRect;
        }
    }
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷 JELiteTV  🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JELiteTV{
    Class _cellClass;
}

+ (JELiteTV *)F:(CGRect)frame style:(UITableViewStyle)style cellC:(Class)cellClass cellH:(CGFloat)cellHeight cell:(void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idx,id obj))cell select:(void (^)(UITableView *tv,NSIndexPath *idx,id obj))select{
    JELiteTV *tv = [[self alloc] initWithFrame:frame style:style cellC:cellClass cellH:cellHeight];
    tv.cell = cell;
    tv.select = select;
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
    
    self.contentInset = UIEdgeInsetsMake(0, 0, (self.sectionHeaderHeight + self.sectionFooterHeight)*2, 0);
    
    return self;
}

#pragma mark - UITableView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections ? _sections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rows ? _rows(tableView,section) : (_sections ? 1 : tableView.Arr.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  _rowH ? _rowH(tableView,indexPath) : tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.style == UITableViewStylePlain) { return 0;}
    return _headH ? _headH(tableView,section) : self.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.style == UITableViewStylePlain) { return 0;}
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[_cellClass ClassName] forIndexPath:indexPath];
        if (_cellClass == UITableViewCell.class && _select == nil) { cell.selectionStyle = UITableViewCellSelectionStyleNone;}
        _cell(cell,tableView,indexPath,(tableView.Arr[(_sections ? indexPath.section : indexPath.row)]));
     
        return cell;
    }
    if (_cells) { return _cells(tableView,indexPath);}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[_cellClass ClassName] forIndexPath:indexPath];
    [cell je_loadCell:tableView.Arr[(_sections ? indexPath.section : indexPath.row)]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    !_select ? : _select(tableView,indexPath,tableView.Arr[(_sections ? indexPath.section : indexPath.row)]);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _editingStyle ? _editingStyle(tableView,indexPath) : UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    !_commitEditingStyle ? : _commitEditingStyle(tableView,editingStyle,indexPath,tableView.Arr[(_sections ? indexPath.section : indexPath.row)]);
}

@end

