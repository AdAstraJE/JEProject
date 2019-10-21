
#import "JEStarRateView.h"
#import "JEKit.h"

@interface JEStarRateView ()
{
    NSInteger NumberStar;
}
@property (nonatomic,strong) UILabel *La_starDes;
@property (nonatomic, strong) UIView *starForView;
@end

#define  Img_W      (18/2)          //星星的宽
#define  Img_H      (18/2)          //星星的高
#define  Img_Sep    (2)            //星星之间的间距
#define  Img_LRSep  (0)         //预留手势的左右间距

@implementation JEStarRateView
@synthesize starForView;

- (void)dealloc{
    jkDeallocLog
}

+ (instancetype)Point:(CGPoint)point addTo:(UIView*)addview numberOfStar:(int)number Block:(StarBlock)block{
    JEStarRateView *rate = [[JEStarRateView alloc]initWithFrame:CGRectMake(point.x, point.y,(Img_W + Img_Sep)*number - Img_Sep + Img_LRSep*2, 50) numberOfStar:number];
    rate.starBlock = block;
    [addview addSubview:rate];
    return rate;
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewStar:5];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self layoutIfNeeded];
    [self setupViewStar:5];
    return self;
}

- (void)setupViewStar:(int)number{
    self.backgroundColor = [UIColor clearColor];
    starForView = [self buidlStarViewWithImageName:@"starpj_1" numOfStar:NumberStar = number];
    [self addSubview:[self buidlStarViewWithImageName:@"starpj_2" numOfStar:number]];
    [self addSubview:starForView];
    [self changeStarForegroundViewWithPoint:CGPointMake(self.frame.size.width*0.6 + Img_Sep, 1)];
}

//重复创建星星
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName numOfStar:(NSInteger)numStar{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    for (int i = 0; i < numStar; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * (Img_W + Img_Sep) + Img_LRSep,(self.frame.size.height - Img_H)/2, Img_W ,Img_H);
        imageView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:imageView];
    }
    return view;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if(CGRectContainsPoint(self.bounds,point)){
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView transitionWithView:starForView duration:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self changeStarForegroundViewWithPoint:[[touches anyObject] locationInView:self]];
    } completion:nil];
}


- (void)ChangeCurrentStar:(CGFloat)star block:(BOOL)block{
    [self changeStarForegroundViewWithPoint:CGPointMake((star*(Img_W + Img_Sep)) + Img_Sep, 1) ];
}

- (void)setCurrentStar:(CGFloat)currentStar{
    _currentStar = currentStar;
    [self changeStarForegroundViewWithPoint:CGPointMake(currentStar == 0 ? 0 : (currentStar*(Img_W + Img_Sep)) + Img_Sep, 1)];
}

- (UILabel *)La_starDes{
    if (_La_starDes == nil) {
        [self addSubview:_La_starDes = [UILabel Frame:CGRectMake((5*(Img_W + Img_Sep)) + Img_Sep, 0, 35, self.height) text:[NSString stringWithFormat:@"%d%@",(int)_currentStar,@".0分"] font:@12 color:(kHexColor(0xFCC45C))]];
    }
    return _La_starDes;
}

- (void)setSuffixTitle:(BOOL)suffixTitle{
    _suffixTitle = suffixTitle;
    self.La_starDes.text = [NSString stringWithFormat:@"%.1f分",_currentStar];
}


- (void)changeStarForegroundViewWithPoint:(CGPoint)p{
    CGFloat X = p.x;
    if (X < 0 || X > self.frame.size.width) {
        X = (X < 0) ? 0 : self.frame.size.width;
    }
    /*
     NSInteger Star = _currentStar;
     for (int i = 0; i < NumberStar; i++) {//整形星星
     if (X > Img_LRSep + i*(Img_W + Img_Sep) && X < Img_LRSep + (i + 1)*(Img_W + Img_Sep)) {
     X = Img_LRSep + (i + 1)*(Img_W + Img_Sep);
     Star = i + 1;break;
     }
     }
     */
    
    starForView.frame = CGRectMake(0, 0,X, self.frame.size.height);
    //    JELog(@"Star :  %d",(int)Star);
    if (_starBlock) {
        _starBlock(_currentStar);
    }
    if (_suffixTitle) {
        self.La_starDes.text = [NSString stringWithFormat:@"%.1f分",_currentStar];
    }
}



@end

