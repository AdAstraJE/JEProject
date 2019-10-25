
#import "JEPutDownMenuView.h"
#import "JEKit.h"

#define kCellSelectColor            (kHexColor(0xe5e5e5))//浅灰色
#define kTitleColor                 (kHexColor(0x222222))//字体颜色
#define DEGREES_TO_RADIANS(degrees) ((3.14159265359 * degrees)/ 180)

static CGFloat jkAnimateDuration  = 0.20;/**< 动画时间 */
static CGFloat jkTableRowHeight   = 44;/**< 行高 */
static CGFloat jkLineW = 0.8;/**< 边框宽 */
static CGFloat jkRadius = 3;/**< 倒角 */

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEPutDownMenuCell   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEPutDownMenuCell : UITableViewCell
@property (nonatomic,strong) UILabel *La_title;
@end

@implementation JEPutDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.textLabel.font = font(14);self.textLabel.textColor = Clr_txt;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UIView *_ = [[UIView alloc]initWithFrame:self.bounds];
    _.backgroundColor = kCellSelectColor;
    self.selectedBackgroundView = _;
    return self;
}

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEPutDownMenuView   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEPutDownMenuView  (){
@public;
    UIView *_backView;
    UITableView *_Tv;
    CGSize _arrowSize;///< 箭头大小
    
    NSArray  <NSString *> *_Arr_list;
    BOOL _upward;///< 展开方向 YES 为向上
    CGFloat _arrowX;///< 箭头位置百分比
}

@end

@implementation JEPutDownMenuView

- (void)dealloc{
    jkDeallocLog
}

+ (void)ShowIn:(UIView *)view point:(CGPoint)point list:(NSArray <NSString *> *)list select:(selectBlock)block{
    [self ShowIn:view point:point list:list select:block upward:NO arrowX:0.5];
}

+ (void)ShowIn:(UIView *)view point:(CGPoint)point list:(NSArray <NSString *> *)list select:(selectBlock)block upward:(BOOL)upward arrowX:(CGFloat)arrowX{
    CGFloat MaxW = 40;
    for (NSString *Str  in list) {
        MaxW = MAX(MaxW, [Str widthWithFont:font(13) height:20]);
    }
    MaxW += 65;
    CGFloat X = (point.x + MaxW > ScreenWidth) ? (ScreenWidth -  MaxW) : point.x;
    MaxW = MIN(MaxW,ScreenWidth);
    
    JEPutDownMenuView *MenuView = [[self alloc] initWithFrame:CGRectMake(X, point.y, MaxW, ScreenHeight - ScreenNavBarH - 49) inView:view list:list select:block upward:upward arrowX:arrowX];
    [view addSubview:MenuView];
}

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)inview list:(NSArray <NSString *> *)list select:(selectBlock)block upward:(BOOL)upward arrowX:(CGFloat)arrowX{
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame),0)];
    self.backgroundColor = [UIColor clearColor];
    _selectBlock = block;
    _Arr_list = list;
    _arrowX = arrowX;
    _arrowSize = CGSizeMake(15, 8);//箭头大小
    
    
    _upward = upward;
    
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 0.3;
    
    //隐藏的点击背景
    _backView = JEVe(inview.bounds, nil, inview);
    [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideView)]];
    
    [self addSubview:_Tv =({
        UITableView  *table = [[UITableView alloc] initWithFrame:CGRectMake(jkLineW,(_upward ? 0 : _arrowSize.height), self.width - jkLineW*2,0)];
        table.delegate = (id<UITableViewDelegate>)self;
        table.dataSource = (id<UITableViewDataSource>)self;
        table.layer.masksToBounds = YES;
        table.layer.cornerRadius = jkRadius;
        table.tableFooterView = [UIView new];
        [table registerClass:[JEPutDownMenuCell class] forCellReuseIdentifier:[JEPutDownMenuCell className]];
        table.scrollEnabled = _Arr_list.count*jkTableRowHeight > CGRectGetHeight(frame);
        table;
    })];
    
    [self ShowView:MIN(_Arr_list.count * jkTableRowHeight + _arrowSize.height, CGRectGetHeight(frame))];
    
    return self;
}
#pragma  mark - 显示 隐藏

- (void)ChangeNavPopGestureEnable:(BOOL)enable{
    UINavigationController *nav = (UINavigationController*)JEApp.window.rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        nav.viewControllers.lastObject.fd_interactivePopDisabled = !enable;
    }
}

/** 显示 */
- (void)ShowView:(CGFloat)height{
    [self ChangeNavPopGestureEnable:NO];
    self.layer.anchorPoint = CGPointMake(0.5,_upward ? 0.5 : 0);
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:jkAnimateDuration animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.frame = CGRectMake(self.x, self.y - (self->_upward ? height : 0), self.width, height);
        self->_Tv.frame = CGRectMake(self->_Tv.x,self->_Tv.y, self->_Tv.width,(height - self->_arrowSize.height*1.5));
    }];
}

/** 隐藏 销毁 */
- (void)HideView{
    [self ChangeNavPopGestureEnable:YES];
    [UIView animateWithDuration:jkAnimateDuration animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(self.x,self.y + (self->_upward ? self.height : 0),self.width, 0);
        self->_Tv.frame = CGRectMake(self->_Tv.x,0, self->_Tv.width,0);
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self->_backView removeFromSuperview];
        self.selectBlock = nil;
    }];
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return jkTableRowHeight;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _Arr_list.count;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JEPutDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[JEPutDownMenuCell className] forIndexPath:indexPath];
    cell.textLabel.text = [_Arr_list objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    !_selectBlock ? : _selectBlock(_Arr_list[indexPath.row],indexPath.row);
    [self HideView];
}

#pragma mark -
- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGRect OldFrame = self.frame;
    self.width -= 2*jkLineW;
    self.height -= 2*jkLineW;
    CGFloat pointX = self.width*_arrowX;
    
    if (_upward) {
        [path moveToPoint:CGPointMake(pointX, self.height)];
        [path addLineToPoint:CGPointMake(pointX-_arrowSize.width*0.5, self.height-_arrowSize.height)];
        [path addLineToPoint:CGPointMake(jkRadius, self.height-_arrowSize.height)];
        [path addArcWithCenter:CGPointMake(jkRadius, self.height- _arrowSize.height-jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(90.0) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
        [path addLineToPoint:CGPointMake(0, jkRadius)];
        [path addArcWithCenter:CGPointMake(jkRadius, jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270.0) clockwise:YES];
        [path addLineToPoint:CGPointMake(self.width-jkRadius, 0)];
        [path addArcWithCenter:CGPointMake(self.width-jkRadius, jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
        [path addLineToPoint:CGPointMake(self.width, self.height-_arrowSize.height-jkRadius)];
        [path addArcWithCenter:CGPointMake(self.width-jkRadius, self.height-_arrowSize.height-jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
        [path addLineToPoint:CGPointMake(pointX+_arrowSize.width*0.5 , self.height-_arrowSize.height)];
    }else{
        [path moveToPoint:CGPointMake(pointX, 0)];
        [path addLineToPoint:CGPointMake(pointX+_arrowSize.width*0.5, _arrowSize.height)];
        [path addLineToPoint:CGPointMake(self.width-jkRadius, _arrowSize.height)];
        [path addArcWithCenter:CGPointMake(self.width-jkRadius, _arrowSize.height+jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
        [path addLineToPoint:CGPointMake(self.width, self.height-jkRadius)];
        [path addArcWithCenter:CGPointMake(self.width-jkRadius, self.height-jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
        [path addLineToPoint:CGPointMake(jkRadius, self.height)];
        [path addArcWithCenter:CGPointMake(jkRadius + jkLineW, self.height-jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
        [path addLineToPoint:CGPointMake(jkLineW, _arrowSize.height+jkRadius)];
        [path addArcWithCenter:CGPointMake(jkRadius + jkLineW, _arrowSize.height+jkRadius) radius:jkRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
        [path addLineToPoint:CGPointMake(pointX-_arrowSize.width*0.5, _arrowSize.height)];
        [path addLineToPoint:CGPointMake(pointX, 0)];
    }
    self.width = OldFrame.size.width;
    [path setLineWidth:jkLineW];
    [kCellSelectColor setStroke]; //设置边框颜色
    [[UIColor whiteColor] setFill];
    [path stroke];
    [path fill];
}

@end
