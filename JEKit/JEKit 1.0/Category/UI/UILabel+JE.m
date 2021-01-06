//
//  UILabel+JE.m
//
//  Created by JE on 15/10/15.
//  Copyright © 2015年 JE. All rights reserved.
//

#import "UILabel+JE.h"

@implementation UILabel (JE)
@dynamic loc;

UILabel * JELa(CGRect rect,NSString *txt,id fnt,UIColor *clr,NSTextAlignment align,__kindof UIView *addTo){
    UILabel *la = [UILabel Frame:rect text:txt font:fnt color:clr align:align];
    if (addTo) { [addTo addSubview:la];}
    return la;
}

UILabel * JELab(CGRect rect,NSString *txt,id fnt,UIColor *clr,NSTextAlignment align,__kindof UIView *addTo){
    UILabel *la = [UILabel Frame:rect text:txt font:fnt color:clr align:align];
    if (addTo) { [addTo addSubview:la];}
    return la;
}

UILabel * JELa_(NSString *txt,id fnt,UIColor *clr){
    return [UILabel Frame:CGRectZero text:txt font:fnt color:clr align:0];
}

- (void)setLoc:(NSString *)loc{
    self.text = NSLocalizedString(loc, nil);
    [self layoutIfNeeded];
}

+ (instancetype)Frame:(CGRect)frame text:(NSString*)text font:(id)font color:(UIColor*)color{
    return [self Frame:frame text:text font:font color:color align:NSTextAlignmentLeft];
}

+ (instancetype)Frame:(CGRect)frame text:(NSString*)text font:(id)font color:(UIColor*)color align:(NSTextAlignment)ment{
    UILabel *La = [[self alloc] initWithFrame:frame];
    [La setText:text font:font];
    if (color) {
        La.textColor = color;
    }
    La.textAlignment = ment;
    La.numberOfLines = 0;
    return La;
}

+ (instancetype)Copy:(UILabel *)la{
//    UILabel *La = [[self alloc] initWithFrame:la.frame];
    return nil;
}

/** 设置文本 和 字体 */
- (void)setText:(NSString *)text font:(id)font{
    self.text = text;
    if ([font isKindOfClass:[NSNumber class]]) {
        self.font = [UIFont systemFontOfSize:((NSNumber*)font).floatValue];
    }else if ([font isKindOfClass:[UIFont class]]){
        self.font = font;
    }
}

/** 设置文本 和 字体颜色 */
- (void)setText:(NSString *)text color:(UIColor*)color{
    self.text = text;
    if ([color isKindOfClass:[UIColor class]]) {
        self.textColor = color;
    }
}

/** 适应当前宽 */
- (instancetype)sizeThatWidth{
    CGRect old = self.frame;
    old.size.width = [self sizeThatFits:CGSizeZero].width;
    self.frame = old;
    return self;
}

/** 适应当前高 */
- (instancetype)sizeThatHeight{
    CGRect old = self.frame;
    old.size.height = [self sizeThatFits:CGSizeMake(old.size.width, CGFLOAT_MAX)].height;
    self.frame = old;
    return self;
}

/** 全部有行间距的 */
- (instancetype)paragraph:(CGFloat)para{
    [self paragraph:para str:self.text];
    return self;
}

- (instancetype)paragraph:(CGFloat)para str:(NSString*)str{
    if (str == nil) {
        return nil;
    }
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:para];
    paragraphStyle.alignment = self.textAlignment;
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attribute.length)];
    [self setAttributedText:attribute];
    return self;
}

/** 部分字符串 添加删除线 */
- (void)delLineStr:(NSString*)editStr{
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) editStr:editStr];
    [self addAttribute:NSBaselineOffsetAttributeName value:@0 editStr:editStr];
}

/** 修改 部分字符串 字体大小  */
- (void)editFont:(UIFont*)font str:(NSString*)editStr{
    [self editFont:font color:nil str:@[editStr]];
}

- (void)editFont:(UIFont*)font range:(NSRange)range{
    [self je_addAttribute:NSFontAttributeName value:font range:range];
}

/** 修改 部分字符串 字体颜色  */
- (void)editColor:(UIColor*)color str:(NSString*)editStr{
    [self editFont:nil color:color str:@[editStr]];
}

- (void)editColor:(UIColor*)color range:(NSRange)range{
    [self je_addAttribute:NSForegroundColorAttributeName value:color range:range];
}

/** 修改 部分字符串 属性  */
- (void)je_addAttribute:(NSString *)name value:(id)value range:(NSRange)range{
    if (range.location + range.length > self.text.length) {
        return;
    }
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    [attribute addAttribute:name value:value range:range];
    [self setAttributedText:attribute];
}

/** 修改 部分字符串 属性  */
- (void)addAttribute:(NSString *)name value:(id)value editStr:(NSString*)editStr{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange range = [self.text rangeOfString:editStr];
    if (range.location == NSNotFound) {
        return;
    }
    
    [attribute addAttribute:name value:value range:range];
    [self setAttributedText:attribute];
}

/** 修改 部分字符串 字体大小 颜色 */
- (void)editFont:(UIFont*)font color:(UIColor*)color str:(NSArray <NSString *> *)strs{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [strs enumerateObjectsUsingBlock:^(NSString * _Nonnull editStr, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [self.text rangeOfString:editStr];
        if (range.location != NSNotFound) {
            if (font)  { [attribute addAttribute:NSFontAttributeName value:font range:range];}
            if (color) { [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];}
        }
    }];
    [self setAttributedText:attribute];
}

/** 后缀添加个图片 */
- (void)addSuffixImg:(UIImage *)image size:(CGSize)size{
    [self addImgAtPrefix:NO image:image size:size];
}

/** 前缀添加个图片 */
- (void)addPrefixImg:(UIImage *)image size:(CGSize)size{
    [self addImgAtPrefix:YES image:image size:size];
}

- (void)addImgAtPrefix:(BOOL)prefix image:(UIImage *)image size:(CGSize)size{
    [self layoutIfNeeded];
    
    NSMutableAttributedString *textAttrStr ;
    if (prefix) {
        textAttrStr = [[NSMutableAttributedString alloc] init];
    }else{
        textAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
//    attach.bounds = CGRectMake(0, - (self.frame.size.height - size.height)/2,size.width, size.height);
    attach.bounds = CGRectMake(0,roundf(self.font.capHeight - size.height)/2.f,size.width, size.height);
    
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    if (prefix) {
        [textAttrStr appendAttributedString:imgStr];
        [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [textAttrStr appendAttributedString:self.attributedText];
    }else{
        [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [textAttrStr appendAttributedString:imgStr];
    }

    self.attributedText = textAttrStr;
}

- (__kindof UILabel *(^)(void))adjust{
    return ^id (void){
        self.adjustsFontSizeToFitWidth = YES;
        return self;
    };
}

@end
