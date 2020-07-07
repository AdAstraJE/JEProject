
#import "JEIntroducView.h"
#import "JEKit.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   @interface JEIntroducCell : UICollectionViewCell   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEIntroducCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *Img;///< 就图片咯
@property (nonatomic,strong) UILabel *La_title;///< title
@property (nonatomic,strong) UILabel *La_desc;///< desc
@end

@implementation JEIntroducCell

- (UIImageView *)Img{
    if (_Img == nil) {_Img = JEImg(JR(0, 0, self.contentView.width, self.contentView.height),nil,self.contentView);}
    return _Img;
}

- (UILabel *)La_title{
    if (_La_title == nil) {
        _La_title = JELab(JR(0, self.contentView.height - 225, self.contentView.width, 30),nil,fontM(25),nil,(1),self.contentView);
    }return _La_title;
}

- (UILabel *)La_desc{
    if (_La_desc == nil) {
        _La_desc = JELab(JR(12, _La_title.bottom + 15, self.contentView.width - 12*2, 50),nil,font(16),Clr_white,(1),self.contentView);;
    }return _La_desc;
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   @interface JEIntroducView   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JEIntroducView () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation JEIntroducView{
    UICollectionView *_Col;
    NSArray <UIImage *> *_Arr_images;
    UIColor *_tintColor,*_descColor;
    NSArray <NSString *> *_Arr_title,*_Arr_desc;
    UIImageView *_Img_back,*_Img_front;///< 有文本描述 用另一种体现方式
}

- (void)dealloc{jkDeallocLog}

+ (instancetype)Introduc:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor{
    return [self Introduc:images tint:tintColor titleDesc:nil descColor:UIColor.je_txt];
}

+ (instancetype)Introduc:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor titleDesc:(NSArray <NSArray <NSString *> *> *)titleDesc descColor:(UIColor *)descColor{
    JEIntroducView *view = [[self alloc] initWithFrame:CGRectMake(0,0, ScreenWidth,ScreenHeight) images:images tint:tintColor titleDesc:titleDesc descColor:descColor];
    [JEApp.window addSubview:view];
    [JEApp.window.layer je_fade];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor titleDesc:(NSArray <NSArray <NSString *> *> *)titleDesc descColor:(UIColor *)descColor{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    _Arr_images = images;
    _tintColor = tintColor;
    _titleColor = tintColor;
    _Arr_title = titleDesc.firstObject;
    _Arr_desc = titleDesc.lastObject;
    _descColor = descColor;
    
    if (titleDesc.count) {
        _Img_back = JEImg(JR(0,0, self.width,self.height),_Arr_images[0],self);
        _Img_front = JEImg(JR(0,0, self.width,self.height),nil,self);
        _Img_front.alpha = 0;
    }
    
    [self addSubview:_Col = ({
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing =  0;
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *_ = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, self.width,self.height) collectionViewLayout:flow];
        _.showsVerticalScrollIndicator = NO;
        _.showsHorizontalScrollIndicator = NO;
        _.backgroundColor = [UIColor clearColor];
        _.dataSource = self; _.delegate = self;
        _.pagingEnabled = YES;
        _.bounces = NO;
        [_ registerClass:JEIntroducCell.class forCellWithReuseIdentifier:[JEIntroducCell className]];
        _;
    })];

    if (tintColor) {
        [self addSubview:_Page = ({
            UIPageControl *_ = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - ScreenSafeArea - 40, self.width, 40)];
            _.numberOfPages = _Arr_images.count;
            _.pageIndicatorTintColor = [UIColor lightGrayColor];
            _.currentPageIndicatorTintColor = tintColor;
            _.userInteractionEnabled = NO;
            _;
        })];
    }

    return self;
}

- (void)resetDescImgFrame:(CGRect)frame{
    _Img_back.frame = frame;
    _Img_front.frame = frame;
}

#pragma mark -

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {return _Arr_images.count;}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth, ScreenHeight);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JEIntroducCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[JEIntroducCell className] forIndexPath:indexPath];
    if (_Img_back) {
        cell.La_title.text = _Arr_title[indexPath.row];
        cell.La_title.textColor = _titleColor;
        [cell.La_desc paragraph:8 str:_Arr_desc[indexPath.row]];
        cell.La_desc.textColor = _descColor;
        [cell.La_desc sizeThatHeight];
    }else{
        cell.Img.image = _Arr_images[indexPath.row];
    }
    return cell;
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > (MAX(0, (_Arr_images.count - 2)) * scrollView.width)) {
        _Btn_finish.alpha = 0;
    }
    if (scrollView.contentOffset.x == (_Arr_images.count - 1) * scrollView.width) {
        [self changeCurrentPage:scrollView];
    }
    
    if (_Img_back) {
        NSInteger nextShow = (int)(scrollView.contentOffset.x/scrollView.frame.size.width);
        CGFloat number = (((int)scrollView.contentOffset.x)%((int)_Img_back.width));
        CGFloat alpha = number/_Img_back.width;
        if (number == 0) {return;}
        BOOL forward = NO;
        if (nextShow == _Page.currentPage) { nextShow += 1; forward = YES;}
        if (nextShow >= _Arr_images.count) { nextShow = _Arr_images.count - 1;}
        
        _Img_back.alpha = forward ? (1 - alpha) : alpha;
        _Img_front.alpha = forward ? alpha : (1 - alpha);
        _Img_front.image = _Arr_images[nextShow];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self changeCurrentPage:scrollView];
}

- (void)changeCurrentPage:(UIScrollView *)scrollView{
    _Page.currentPage = (int)(scrollView.contentOffset.x/scrollView.frame.size.width);
    if (_Page.currentPage == (_Arr_images.count - 1)) {
        [self Btn_finish];
        [UIView animateWithDuration:0.25 animations:^{
            self.Btn_finish.alpha = 1;
        }];
    }
    if (_Img_back) {
        _Img_back.image = _Arr_images[_Page.currentPage];
        _Img_back.alpha = 1;
        _Img_front.alpha = 0;
    }
}

- (UIButton *)Btn_finish{
    if (_Btn_finish == nil) {
        CGFloat width = self.width *0.618,height = 40;
        _Btn_finish = JEBtn(JR((self.width - width)/2, _Page.y - height - 13, width, height),@"立即体验".loc,fontM(16),[UIColor whiteColor],self,@selector(dismiss),_tintColor,height/2,self);
        _Btn_finish.alpha = 0;
    }
    return _Btn_finish;
}

@end
