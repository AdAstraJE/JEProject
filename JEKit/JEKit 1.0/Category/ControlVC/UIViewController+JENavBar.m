
#import "UIViewController+JENavBar.h"
#import "JEKit.h"
#import <objc/runtime.h>
#import "JEBaseNavtion.h"

@implementation UIViewController (JENavBar)

#pragma mark -

/** 自定义导航栏-背景颜色 */
- (void)setJe_navBarColor:(UIColor *)je_navBarColor{ objc_setAssociatedObject(self, @selector(je_navBarColor), je_navBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_navBarColor{ return objc_getAssociatedObject(self, _cmd) ? : [UIColor whiteColor];}
/** 自定义导航栏-背景图片 */
- (void)setJe_navBarImage:(UIImage *)je_navBarImage{ objc_setAssociatedObject(self, @selector(je_navBarImage), je_navBarImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIImage *)je_navBarImage{ return objc_getAssociatedObject(self, _cmd);}
/** 导航栏底部线条颜色 ### 默认 kHexColorA(0xCCCCCC,0.6) */
- (void)setJe_navBarLineColor:(UIColor *)je_navBarLineColor{objc_setAssociatedObject(self, @selector(je_navBarLineColor), je_navBarLineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_navBarLineColor{return objc_getAssociatedObject(self, _cmd) ? : kHexColorA(0xCCCCCC,0.6);}
/** 自定义导航栏-返回键按钮&标题颜色 */
- (void)setJe_navBarItemColor:(UIColor *)je_navBarItemColor{ objc_setAssociatedObject(self, @selector(je_navBarItemColor), je_navBarItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_navBarItemColor{return objc_getAssociatedObject(self, _cmd) ? : JEShare.titleColor;}
/** 标题颜色  */
- (void)setJe_titleColor:(UIColor *)je_titleColor{ objc_setAssociatedObject(self, @selector(je_titleColor), je_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_titleColor{return objc_getAssociatedObject(self, _cmd);}

#pragma mark -

/** title Label */
- (void)setLa_title:(UILabel *)La_title{ objc_setAssociatedObject(self, &jeLa_TitleKey, La_title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UILabel *)La_title{ return objc_getAssociatedObject(self, &jeLa_TitleKey);}
/** 自定义导航栏 */
- (void)setVe_jeNavBar:(UIView *)Ve_jeNavBar{ objc_setAssociatedObject(self, @selector(Ve_jeNavBar), Ve_jeNavBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIImageView *)Ve_jeNavBar{return objc_getAssociatedObject(self, _cmd);}
/** 导航栏底部线条 */
- (void)setVe_navBarline:(UIView *)Ve_navBarline{   objc_setAssociatedObject(self, @selector(Ve_navBarline), Ve_navBarline, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIView *)Ve_navBarline{return objc_getAssociatedObject(self, _cmd);}
/** 导航栏返回键 */
- (void)setBtn_back:(UIButton *)Btn_back{objc_setAssociatedObject(self, @selector(Btn_back), Btn_back, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIButton *)Btn_back{ return objc_getAssociatedObject(self, _cmd);}
/** 不使用自定义Bar ###默认使用 */
- (void)setDisabel_je_NavBar:(BOOL)disabel_je_NavBar{ objc_setAssociatedObject(self, @selector(disabel_je_NavBar), @(disabel_je_NavBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (BOOL)disabel_je_NavBar{ return [objc_getAssociatedObject(self, _cmd) boolValue];}
/** 用self VC控制以上属性 */
- (void)setCtrlBySelf:(BOOL)ctrlBySelf{objc_setAssociatedObject(self, @selector(ctrlBySelf), @(ctrlBySelf), OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
-(BOOL)ctrlBySelf{ return [objc_getAssociatedObject(self, _cmd) boolValue];}

static const void *jeLa_TitleKey;

- (void)setTitle:(NSString *)title{
    UILabel *la = objc_getAssociatedObject(self, &jeLa_TitleKey);
    la.text = title;
    if (la == nil) {
        UIColor *clr = self.controlVC.je_titleColor ? : self.controlVC.je_navBarItemColor;
        la = JELa(JR(ScreenWidth*0.1, ScreenStatusBarH + 11, ScreenWidth*0.8, 20),title,fontM(18.5),clr,(1),self.Ve_jeNavBar);
        la.adjustsFontSizeToFitWidth = YES;
        la.backgroundColor = [UIColor clearColor];
        self.La_title = la;
    }
}

- (NSString *)title{
    return self.La_title.text;
}

/** 控制自定义样式的VC */
- (UIViewController *)controlVC{
    if (self.ctrlBySelf) {return self;}
    if ([self isKindOfClass:UITabBarController.class]) { return (UITabBarController *)self;}
    if ([self.tabBarController isKindOfClass:UITabBarController.class]) { return self.tabBarController;}
    UIViewController *vc = self.Nav.viewControllers.firstObject;
    if ([vc isKindOfClass:UITabBarController.class]) { return vc;}
    return self.Nav ? : self;
}

/** 使用自定义导航栏 */
- (void)je_useCustomNavBar{
    if (objc_getAssociatedObject(self, @selector(Ve_jeNavBar)) == nil) {
        UIImageView *_;
        if (self.controlVC.je_navBarImage) {
            _ = [UIImageView F:CGRectMake(0, 0, ScreenWidth, ScreenNavBarH) image:self.controlVC.je_navBarImage].addTo(self.view);
        }else{
            _ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenNavBarH)].addTo(self.view);
            _.backgroundColor = self.controlVC.je_navBarColor;
        }
        _.userInteractionEnabled = YES;
        
        if (self.controlVC.je_navBarImage == nil && self.controlVC.je_navBarColor == [UIColor whiteColor]) {
            self.Ve_navBarline = [UIView Frame:CGRectMake(0, _.height - 0.5, _.width, 0.5) color:self.controlVC.je_navBarLineColor].addTo(_);
        }
        
        //不是首页 加添返回键
        if (self.Nav.viewControllers.count > 1) {
            [_ addSubview:self.Btn_back = [self je_customNavBackButton]];
            [self.Btn_back addTarget:self action:@selector(je_navPopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        self.Ve_jeNavBar = _;
    }
}

#pragma mark -

- (JEButton*)je_customNavBackButton{
    JEButton *btnBack = JEBtn(JR(3, ScreenStatusBarH + (44 - 26)/2, 26, 26),nil,nil,nil,nil,nil,nil,0,nil).touchs(ScreenStatusBarH,3,20,40);
    [btnBack setTitleColor:self.controlVC.je_navBarItemColor forState:UIControlStateNormal];
    [btnBack setTitleColor:[self.controlVC.je_navBarItemColor je_Abe:1 Alpha:0.2] forState:UIControlStateHighlighted];
    UIImage *image = [UIImage imageNamed:JEResource(@"NavBackBtn.png")];
    [btnBack setImage:image.color(self.controlVC.je_navBarItemColor) forState:UIControlStateNormal];
    [btnBack setImage:image.color([self.controlVC.je_navBarItemColor je_Abe:1 Alpha:0.2]) forState:UIControlStateHighlighted];
    return btnBack;
}

- (void)je_setBackButtonTitle:(NSString *)title{
    [self.Btn_back setTitle:title forState:UIControlStateNormal];
    [self.Btn_back sizeThatWidth];
    self.Btn_back.height = 44;
    self.Btn_back.y = ScreenStatusBarH;
    [self.Btn_back setImage:nil forState:UIControlStateNormal];
    [self.Btn_back setImage:nil forState:UIControlStateHighlighted];
}

/** 设置已存在的返回键颜色 */
- (void)je_setBackButtonColor:(UIColor *)color{
//    UIImage *image = [UIImage imageNamed:JEResource(@"NavBackBtn.png")];
    UIImage *image = [self.Btn_back imageForState:(UIControlStateNormal)];
    [self.Btn_back setImage:[image imageWithColor:color] forState:UIControlStateNormal];
    [self.Btn_back setImage:[image imageWithColor:[color je_Abe:1 Alpha:0.2]] forState:UIControlStateHighlighted];
}

- (void)je_navPopBtnClick{
    [self.Nav popViewControllerAnimated:YES];
}

- (JEButton *)je_rightBarBtn:(NSString*)title act:(SEL)selector{
    return [self je_rightBarBtn:title target:self act:selector];
}

- (JEButton *)je_rightBarBtn:(NSString*)title target:(id)target act:(SEL)selector{
    return [self createCustomRightBarBtn:title target:target act:selector].addTo(self.Ve_jeNavBar);
}

- (JEButton *)je_rightBarBtnImgN:(id)imageN act:(SEL)selector{
    return [self je_rightBarBtnImgN:imageN target:self act:selector];
}

- (JEButton *)je_rightBarBtnImgN:(id)imageN target:(id)target act:(SEL)selector{
    JEButton *btn = [self createCustomRightBarBtn:nil target:target act:selector].addTo(self.Ve_jeNavBar);
    UIImage *image = imageN;
    if ([imageN isKindOfClass:[NSString class]]) { image = [UIImage imageNamed:imageN];}
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:[image imageWithColor:kRGBA(0, 0, 0, 0.2)] forState:UIControlStateHighlighted];
    return btn;
}

- (JEButton *)createCustomRightBarBtn:(NSString*)title target:(id)target act:(SEL)selector{
    for (UIView *view in self.Ve_jeNavBar.subviews) {
        if ([view isKindOfClass:[JEButton class]] && view.x > 8) {
            [view removeFromSuperview];
        }
    }

    JEButton *btnBack = JEBtn(JR(-1, ScreenStatusBarH, -1, 44),title,@18,self.controlVC.je_navBarItemColor,target,selector,nil,0,nil).touchs(20,30,0,12);
    btnBack.width = [btnBack sizeThatFits:CGSizeMake(ScreenWidth*0.4, 44)].width;
    btnBack.x = ScreenWidth - btnBack.width - 10;
    return btnBack;
}

@end
