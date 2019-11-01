
#import "UIViewController+JENavBar.h"
#import "JEKit.h"
#import <objc/runtime.h>
#import "JEBaseNavtion.h"

static CGFloat const JKPresentingNavH = 58.0f;///<

@implementation UIViewController (JENavBar)

#pragma mark -

- (void)setJe_navBarClr:(UIColor *)je_navBarColor{ objc_setAssociatedObject(self, @selector(je_navBarClr), je_navBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_navBarClr{ return objc_getAssociatedObject(self, _cmd) ? : [UIColor whiteColor];}

- (void)setJe_navBarImage:(UIImage *)je_navBarImage{ objc_setAssociatedObject(self, @selector(je_navBarImage), je_navBarImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIImage *)je_navBarImage{ return objc_getAssociatedObject(self, _cmd);}

- (void)setJe_navBarLineClr:(UIColor *)je_navBarLineColor{objc_setAssociatedObject(self, @selector(je_navBarLineClr), je_navBarLineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_navBarLineClr{return objc_getAssociatedObject(self, _cmd) ? : kHexColorA(0xCCCCCC,0.6);}

- (void)setJe_navBarItemClr:(UIColor *)je_navBarItemColor{ objc_setAssociatedObject(self, @selector(je_navBarItemClr), je_navBarItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_navBarItemClr{return objc_getAssociatedObject(self, _cmd) ? : Clr_blue;}

- (void)setJe_navTitleClr:(UIColor *)je_titleColor{ objc_setAssociatedObject(self, @selector(je_navTitleClr), je_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIColor *)je_navTitleClr{return objc_getAssociatedObject(self, _cmd) ? : JEShare.textClr;}

#pragma mark -

static const void *jeLa_TitleKey;
- (void)setJe_La_title:(UILabel *)La_title{ objc_setAssociatedObject(self, &jeLa_TitleKey, La_title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UILabel *)je_La_title{ return objc_getAssociatedObject(self, &jeLa_TitleKey);}

- (void)setJe_navBar:(UIView *)Ve_jeNavBar{ objc_setAssociatedObject(self, @selector(je_navBar), Ve_jeNavBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIImageView *)je_navBar{return objc_getAssociatedObject(self, _cmd);}

- (void)setJe_navBarline:(UIView *)Ve_navBarline{   objc_setAssociatedObject(self, @selector(je_navBarline), Ve_navBarline, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (UIView *)je_navBarline{return objc_getAssociatedObject(self, _cmd);}

- (void)setJe_Btn_back:(UIButton *)Btn_back{objc_setAssociatedObject(self, @selector(je_Btn_back), Btn_back, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (JEButton *)je_Btn_back{ return objc_getAssociatedObject(self, _cmd);}

- (void)setJe_disableNavBar:(BOOL)disabel_je_NavBar{ objc_setAssociatedObject(self, @selector(je_disableNavBar), @(disabel_je_NavBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (BOOL)je_disableNavBar{ return [objc_getAssociatedObject(self, _cmd) boolValue];}

- (void)setJe_ctrlBySelf:(BOOL)ctrlBySelf{objc_setAssociatedObject(self, @selector(je_ctrlBySelf), @(ctrlBySelf), OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (BOOL)je_ctrlBySelf{ return [objc_getAssociatedObject(self, _cmd) boolValue];}

- (void)setTitle:(NSString *)title{
    UILabel *la = objc_getAssociatedObject(self, &jeLa_TitleKey);
    la.text = title;
    if (la == nil) {
        CGFloat x = self.presentingViewController ? 14 : (ScreenStatusBarH + 6);
        UIColor *clr = self.je_ctrlVC.je_navTitleClr ? : self.je_ctrlVC.je_navBarItemClr;
        la = JELab(JR(50,x, ScreenWidth - 50*2, 30),title,fontM(18),clr,(1),nil);
        la.adjustsFontSizeToFitWidth = YES;
        la.backgroundColor = [UIColor clearColor];
        self.je_La_title = la;
    }
    if (la.superview == nil) {
        [self.je_navBar addSubview:la];
    }
}

- (NSString *)title{
    return self.je_La_title.text;
}

/// 控制属性的VC
- (UIViewController *)je_ctrlVC{
    if (self.je_ctrlBySelf) {return self;}
    if ([self isKindOfClass:UITabBarController.class]) { return (UITabBarController *)self;}
    if ([self.tabBarController isKindOfClass:UITabBarController.class]) { return self.tabBarController;}
    UIViewController *vc = self.Nav.viewControllers.firstObject;
    if ([vc isKindOfClass:UITabBarController.class]) { return vc;}
    return self.Nav ? : self;
}

- (void)je_useCustomNavBar{
    if (objc_getAssociatedObject(self, @selector(je_navBar)) == nil) {
        CGFloat height = self.presentingViewController ? JKPresentingNavH : ScreenNavBarH;
        UIImageView *_ = JEImg(JR(0, 0, ScreenWidth, height),self.je_ctrlVC.je_navBarImage,self.view);
        _.backgroundColor = self.je_ctrlVC.je_navBarClr;
        _.userInteractionEnabled = YES;
        
        if (self.je_ctrlVC.je_navBarImage == nil && self.je_ctrlVC.je_navBarClr == [UIColor whiteColor]) {
            self.je_navBarline = JEVe(JR(0, _.height - 0.5, _.width, 0.5), self.je_ctrlVC.je_navBarLineClr, _);
        }
        
        //不是首页 加添返回键
        if (self.Nav.viewControllers.count > 1) {
            UIImage *image = JEBundleImg(@"ic_navBack").clr(self.je_ctrlVC.je_navBarItemClr);
            self.je_Btn_back = JEBtn(JR(3, ScreenStatusBarH + (44 - 26)/2, 26, 26),nil,self.je_La_title.font ? : font(17),self.je_ctrlVC.je_navBarItemClr,self,@selector(je_navPopBtnClick),image,0,_).touchs(ScreenStatusBarH,3,20,40);
        }
        self.je_navBar = _;
    }
}

- (void)je_navPopBtnClick{
    (self.presentingViewController) ? [self dismissViewControllerAnimated:YES completion:nil] : [self.Nav popViewControllerAnimated:YES];
}

#pragma mark -

- (JEButton *)je_leftNavBtn:(id)item{
    NSString *title = [item isKindOfClass:NSString.class] ? item : nil;
    UIImage *img = [item isKindOfClass:UIImage.class] ? item : nil;
    if (self.je_Btn_back == nil) {
        self.je_Btn_back = [self createBtn:item target:self act:@selector(je_navPopBtnClick)];
    }else{
        if (img) { [self.je_Btn_back je_resetImg:img];}
        if (title) {[self.je_Btn_back setTitle:title forState:UIControlStateNormal]; }
    }

    [self.je_Btn_back sizeThatWidth];
    self.je_Btn_back.x = 12;
    return self.je_Btn_back;
}

- (JEButton *)je_rightNavBtn:(id)item target:(id)target act:(SEL)selector{
    JEButton *_ = [self createBtn:item target:target act:selector];
    _.x = ScreenWidth - _.width - 16;
    return _;
}

- (JEButton *)createBtn:(id)item target:(id)target act:(SEL)selector{
    NSString *title = [item isKindOfClass:NSString.class] ? item : nil;
    UIImage *img = [item isKindOfClass:UIImage.class] ? item : nil;
    CGFloat x = self.presentingViewController ? 0 : ScreenStatusBarH;
    CGFloat h = self.presentingViewController ? JKPresentingNavH : kNavBarH44;
    UIFont *font = self.presentingViewController ? fontM(17) : font(17);
    
    JEButton *_ = JEBtn(JR(-1,x, -1, h),title,font,self.je_ctrlVC.je_navBarItemClr,target,selector,img,0,self.je_navBar).touchs(10,20,0,16);
    [_ sizeThatWidth];
    return _;
}

@end
