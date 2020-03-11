
#import "JESingleTextVC.h"
#import "JEKit.h"

#define TopSep  (ScreenNavBarH + 12.0)

@interface JESingleTextVC ()<UITextViewDelegate,UITextFieldDelegate>{
    UILabel *La_Lim;
    UITableView *Tv_;
}

@property (nonatomic,copy) NSString *VcTitle;
@property (nonatomic,copy) NSString *DefaultText;
@property (nonatomic,copy) NSString *PlaceText;
@property (nonatomic,assign) NSUInteger limit;
@property (nonatomic,assign) NSUInteger VHeight;
@property (nonatomic,assign) BOOL UseTextField;

@end

@implementation JESingleTextVC
@synthesize TextV_ ;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (_UseTextField) {
        [self.Tf_ becomeFirstResponder];
    }
}

+(JESingleTextVC *)Title:(NSString*)title text:(NSString*)text placeHolder:(NSString*)place limit:(NSUInteger)limit textHeight:(NSUInteger)textH call:(ResultStringBlock)call{
    JESingleTextVC *TextVc =  [[JESingleTextVC alloc]init];
    TextVc.VcTitle = title;
    TextVc.DefaultText = [text copy];
    TextVc.PlaceText = place;
    TextVc.limit = limit;
    TextVc.VHeight = textH;
    TextVc.ResCall = call;
    [TextVc showVC];
    return TextVc;
}

+(JESingleTextVC *)Title:(NSString*)title TfText:(NSString*)text placeHolder:(NSString*)place limit:(NSUInteger)limit call:(ResultStringBlock)call{
    JESingleTextVC *TextVc = [JESingleTextVC Title:title text:text placeHolder:place limit:limit textHeight:0 call:call];
    TextVc.UseTextField = YES;
    return TextVc;
}

- (JETextView *)TextV_{
    if (TextV_ == nil) {
        JETextView *_ = [[JETextView alloc]initWithFrame:CGRectMake(0,TopSep,ScreenWidth,_VHeight == 0 ? ((_limit > 20 ? _limit : 20 )*2.4) : _VHeight)];
        _.layer.borderWidth = 1;
        _.layer.borderColor = (kHexColor(0xe5e5e5)).CGColor;
        _.font = [UIFont systemFontOfSize:14];
        _.textContainerInset = UIEdgeInsetsMake(5, 8, 3, 8);
        _.textColor = (kHexColor(0x333333));
        _.text = _DefaultText;
        _.returnKeyType = UIReturnKeyDone;
        _.delegate = self;
        _.placeHolder = _PlaceText;
        //        _.JEMaxTextLength = _limit;
        [self.view addSubview:TextV_ =  _];
    }
    return TextV_;
}

- (JETextField *)Tf_{
    if (_Tf_ == nil) {
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(-1, TopSep, ScreenWidth+2, 45)];
        view.layer.borderWidth = 1;
        view.layer.borderColor = (kHexColor(0xe5e5e5)).CGColor;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        JETextField *_ = [[JETextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 5, view.height)];
        _.backgroundColor = [UIColor clearColor];
        _.font = [UIFont systemFontOfSize:14];
        _.text = _DefaultText;
        _.returnKeyType = UIReturnKeyDone;
        _.delegate = self;
        _.clearButtonMode = UITextFieldViewModeWhileEditing;
        _.JEMaxTextLength = _limit;
        _.placeholder = _PlaceText;
        _.clearButtonMode = UITextFieldViewModeWhileEditing;
        [view addSubview:_Tf_ =  _];
        
    }
    return _Tf_;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _VcTitle;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成".loc style:UIBarButtonItemStylePlain target:self action:@selector(TExtvEditimgDown)];
    [self rightNavBtn:@"完成".loc target:self act:@selector(TExtvEditimgDown)];
    
    if (_UseTextField) {
        [self Tf_];
        return;
    }
    
    self.TextV_.placeHolder = _PlaceText;
    [TextV_ becomeFirstResponder];
    
    //显示剩余字符限制的label
    UILabel *_ = [[UILabel alloc]initWithFrame:CGRectMake(TextV_.superview.width - 33, TextV_.bottom - 24, 30, 15)];
    _.textColor = [UIColor grayColor];
    _.font = [UIFont systemFontOfSize:15.5];
    [self.view addSubview:La_Lim = _];
    [self textViewDidChange:TextV_];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextFieldTextDidChangeNotification object:TextV_];
}

#pragma mark - 完成

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self EditEnd:_Tf_ textLength:[_Tf_.text length] text:_Tf_.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [(JETextField*)textField textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)TExtvEditimgDown{
    if (TextV_) {
        [self EditEnd:TextV_ textLength:[TextV_.text length] text:TextV_.text];
    }else{
        [self EditEnd:_Tf_ textLength:[_Tf_.text length] text:_Tf_.text];
    }
}

- (void)EditEnd:(UIView*)view textLength:(NSInteger)textL text:(NSString*)text{
    if (textL > _limit) {
        [self showHUD:[NSString stringWithFormat:@"限制%d个字符",(int)_limit]];
        [view.layer je_Shake];
        return;
    }
    [view resignFirstResponder];
    !_ResCall ?: _ResCall(text);
    [self.Nav popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self TExtvEditimgDown];
        return NO;
    }
    if (range.length >= 1) {
        return YES;
    }
    if (textView.text.length >_limit) {
        return NO;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] > _limit && textView.markedTextRange == nil  ) {
        //        textView.text = [textView.text je_limitTo:_limit];
        textView.text = [textView.text substringToIndex:_limit];
    }
    if (textView.markedTextRange == nil) {
        La_Lim.text = [NSString stringWithFormat:@"%d",(int)(_limit - [TextV_.text length])];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}


@end
