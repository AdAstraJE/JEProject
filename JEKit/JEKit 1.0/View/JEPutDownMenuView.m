
#import "JEPutDownMenuView.h"
#import "JEKit.h"
#import "UIImageView+WebCache.h"
#define kSelColor            (kHexColor(0xe5e5e5))//浅灰色
#define kTitleColor          (kHexColor(0x222222))//字体颜色
#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

static CGFloat jkAnimateDuration  = 0.20;/**< 动画时间 */
static CGFloat jkTableRowHeight   = 44;/**< 行高 */
static CGFloat jkLineW = 0.8;/**< 边框宽 */
static CGFloat jkRadius = 3;/**< 倒角 */

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @interface JEPutDownMenuCell   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEPutDownMenuCell : UITableViewCell
@property (nonatomic,strong) UILabel *La_;
@end

@implementation JEPutDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = UIColor.whiteColor;
    return self;
}

- (UILabel *)La_{
    if (!_La_) { _La_ = [UILabel Frame:CGRectMake(12, 0, self.width, self.height) text:nil font:@13 color:kTitleColor].addTo(self.contentView); }
    return _La_;
}

@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @interface JEPutDownMenuView   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEPutDownMenuView  (){
@public;
    UIView *_backView;
    UITableView *_Tv;
    CGSize _arrowSize;/**< 箭头大小 */
    
    NSArray  <NSString *> *_Arr;
    BOOL _positionUp;/**< 展开方向 YES 为向上 */
    CGFloat _arrowX;///< 箭头位置百分比
}

@end

@implementation JEPutDownMenuView

- (void)dealloc{
    jkDeallocLog
}

+ (void)ShowIn:(UIView *)view Point:(CGPoint)point List:(NSArray <NSString *> *)list Click:(SelectBlock)block{
    [self ShowIn:view Point:point List:list Click:block PositionUp:NO];
}

+ (void)ShowIn:(UIView *)view Point:(CGPoint)point List:(NSArray <NSString *> *)list Click:(SelectBlock)block PositionUp:(BOOL)PosUP{
    [self ShowIn:view Point:point List:list Click:block PositionUp:PosUP arrowX:0.5];
}

+ (void)ShowIn:(UIView *)view Point:(CGPoint)point List:(NSArray <NSString *>*)list Click:(SelectBlock)block PositionUp:(BOOL)PosUP arrowX:(CGFloat)arrowX{
    CGFloat MaxW = 40;
    for (NSString *Str  in list) {
        MaxW = MAX(MaxW, [Str widthWithFont:font(13) height:20]);
    }
    MaxW += 65;
    CGFloat X = (point.x + MaxW > ScreenWidth) ? (ScreenWidth -  MaxW) : point.x;
    MaxW = MIN(MaxW,ScreenWidth);
    
    JEPutDownMenuView *MenuView = [[self alloc]initWithFrame:CGRectMake(X, point.y, MaxW, ScreenHeight - ScreenNavBarH - 49) inView:view List:list Click:block PositionUp:PosUP arrowX:arrowX];
    [view addSubview:MenuView];
}

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView*)inview List:(NSArray <NSString *> *)list Click:(SelectBlock)block PositionUp:(BOOL)PosUP arrowX:(CGFloat)arrowX{
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame),0)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _selectBlock = block;
        _Arr = list;
        _arrowX = arrowX;
        
        if (_arrowSize.width!= -1 && _arrowSize.height != -1) {
            _arrowSize = CGSizeMake(15, 8);//箭头大小
        }
        
        _positionUp = PosUP;
        
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3;
        
        //隐藏的点击背景
        self->_backView = [[UIView alloc]initWithFrame:inview.bounds];
        [inview addSubview:self->_backView];
        [self->_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideView)]];
        
        [self addSubview:_Tv =({
            UITableView  *table = [[UITableView alloc] initWithFrame:CGRectMake(jkLineW,(_positionUp ? 0 : _arrowSize.height), self.width - jkLineW*2,0)];
            table.delegate = (id<UITableViewDelegate>)self;
            table.dataSource = (id<UITableViewDataSource>)self;
            table.layer.masksToBounds = YES;
            table.layer.cornerRadius = jkRadius;
            table.tableFooterView = [UIView new];
            [table registerClass:[JEPutDownMenuCell class] forCellReuseIdentifier:[JEPutDownMenuCell ClassName]];
            table.scrollEnabled = _Arr.count*jkTableRowHeight > CGRectGetHeight(frame);
            table;
        })];
        
        [self ShowView:MIN(_Arr.count * jkTableRowHeight + _arrowSize.height, CGRectGetHeight(frame))];
    }
    return self;
}
#pragma  mark - 显示 隐藏

- (void)ChangeNavPopGestureEnable:(BOOL)enable{
    UINavigationController *Nav = (UINavigationController*)JEApp.window.rootViewController;
    if ([Nav isKindOfClass:[UINavigationController class]]) {
        Nav.interactivePopGestureRecognizer.enabled = enable;
    }
}

/** 显示 */
- (void)ShowView:(CGFloat)height{
    [self ChangeNavPopGestureEnable:NO];
    self.layer.anchorPoint = CGPointMake(0.5,_positionUp ? 0.5 : 0);
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:jkAnimateDuration animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.frame = CGRectMake(self.x, self.y - (self->_positionUp ? height : 0), self.width, height);
        self->_Tv.frame = CGRectMake(self->_Tv.x,self->_Tv.y, self->_Tv.width,(height - self->_arrowSize.height*1.5));
    }];
}

/** 隐藏 销毁 */
- (void)HideView{
    [self ChangeNavPopGestureEnable:YES];
    [UIView animateWithDuration:jkAnimateDuration animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(self.x,self.y + (self->_positionUp ? self.height : 0),self.width, 0);
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _Arr.count;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JEPutDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[JEPutDownMenuCell ClassName] forIndexPath:indexPath];
    cell.La_.text = [_Arr objectAtIndex:indexPath.row];
    UIView *Selv = [[UIView alloc]initWithFrame:cell.bounds];
    Selv.backgroundColor = kSelColor;
    cell.selectedBackgroundView = Selv;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_selectBlock) {
        _selectBlock(_Arr[indexPath.row],indexPath.row);
    }
    [self HideView];
}

/** 显示完整的CellSeparator线 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 画图
- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGRect OldFrame = self.frame;
    self.width -= 2*jkLineW;self.height -= 2*jkLineW;
    CGFloat pointX = self.width/2;/** 箭头在中间位置 */
    if (self.x <= 8) {
        pointX = 20;
    }
    
    if (_arrowX != 0) {pointX = self.width*_arrowX;}
    
    if (_positionUp) {
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
    [kSelColor setStroke]; //设置边框颜色
    [[UIColor whiteColor] setFill];
    [path stroke];
    [path fill];
}



@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @interface JEPutDownMenuViewType1   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEPutDownMenuViewType1 (){
    NSString *Str_current;/**< 当前显示蓝色文本 */
}
@end

@implementation JEPutDownMenuViewType1

+ (void)ShowIn:(UIView*)view Point:(CGPoint)point List:(NSArray*)list Click:(SelectBlock)block curStr:(NSString*)curStr{
    CGFloat MaxW = 40;
    for (NSString *Str  in list) {
        MaxW = MAX(MaxW, [Str widthWithFont:font(13) height:20]);
    }
    
    CGFloat X = (point.x + MaxW + 30 > ScreenWidth) ? (ScreenWidth -  MaxW - 30) : point.x;
    
    JEPutDownMenuView *MenuView = [[self alloc]initWithFrame:CGRectMake(X, point.y, MaxW + 30, ScreenHeight - ScreenNavBarH - 49) inView:view List:list Click:block PositionUp:NO curStr:curStr];
    [view addSubview:MenuView];
}

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView*)inview List:(NSArray*)list Click:(SelectBlock)block PositionUp:(BOOL)PosUP curStr:(NSString*)curStr{
    _arrowSize = CGSizeMake(-1, -1);
    jkTableRowHeight = 44;
    jkLineW = 0;
    jkRadius = 0;
    Str_current = curStr;
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), ScreenWidth,ScreenHeight - CGRectGetMinY(frame)) inView:inview List:list Click:block PositionUp:PosUP arrowX:0.5];
    
    [self.layer addSublayer:[CALayer je_DrawLine:CGPointMake(0, 0) To:CGPointMake(ScreenWidth, 0) color:(kHexColor(0xDDDDDD))]];
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0,frame.origin.y + _Tv.height, ScreenWidth, self->_backView.height - _Tv.bottom)];
    bottom.backgroundColor = kRGBA(0, 0, 0, 0.6);
    [self->_backView addSubview:bottom];
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JEPutDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JEPutDownMenuView_Cell" forIndexPath:indexPath];
    NSString *str = [_Arr objectAtIndex:indexPath.row];
    cell.La_.text = str;
    cell.La_.textColor = ([Str_current rangeOfString:str].length) ? (kRGB(25, 99, 255)) : kColorText33;
    
    UIView *Selv = [[UIView alloc]initWithFrame:cell.bounds];
    Selv.backgroundColor = kSelColor;
    cell.selectedBackgroundView = Selv;
    
    return cell;
}

/** 显示 */
- (void)ShowView:(CGFloat)height{
    [self ChangeNavPopGestureEnable:NO];
    self.frame = CGRectMake(self.x, self.y - (_positionUp ? height : 0), self.width, height);
    _Tv.frame = CGRectMake(_Tv.x,_Tv.y, _Tv.width,(height - _arrowSize.height*1.5));
    self.alpha = self->_backView.alpha = 0;
    [UIView animateWithDuration:jkAnimateDuration animations:^{
        self.alpha = self->_backView.alpha = 1;
        self->_backView.alpha = 1;
    }];
}

/** 隐藏 销毁 */
- (void)HideView{
    [self ChangeNavPopGestureEnable:YES];
    [UIView animateWithDuration:jkAnimateDuration animations:^{
        self.alpha = self->_backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self->_backView removeFromSuperview];
        self.selectBlock = nil;
    }];
}

@end

