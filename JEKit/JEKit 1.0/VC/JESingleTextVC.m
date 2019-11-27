
#import "JESingleTextVC.h"
#import "JEKit.h"

#define TopSep  (ScreenNavBarH + 12.0)

@interface JESingleTextVC ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel *La_Lim;
    UITableView *Tv_;
}

@property (nonatomic,copy) NSString *VcTitle;
@property (nonatomic,copy) NSString *DefaultText;
@property (nonatomic,copy) NSString *PlaceText;
@property (nonatomic,assign) NSUInteger limit;
@property (nonatomic,assign) NSUInteger VHeight;
@property (nonatomic,assign) BOOL UseTextField;
@property (nonatomic,copy)   NSString *UseTableSex;/**< tableview 选性别 */

@end

@implementation JESingleTextVC
@synthesize TextV_ ;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (_UseTextField) {
        [self.Tf_ becomeFirstResponder];
    }
}

/** Push一个编辑的TextView */
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

/** Push一个编辑的 TextField */
+(JESingleTextVC *)Title:(NSString*)title TfText:(NSString*)text placeHolder:(NSString*)place limit:(NSUInteger)limit call:(ResultStringBlock)call{
    JESingleTextVC *TextVc = [JESingleTextVC Title:title text:text placeHolder:place limit:limit textHeight:0 call:call];
    TextVc.UseTextField = YES;
    return TextVc;
}

/** Push一个选择性别的 */
+(JESingleTextVC *)Title:(NSString*)title sex:(NSString*)sex call:(ResultStringBlock)call{
    JESingleTextVC *TextVc =  [[JESingleTextVC alloc]init];
    TextVc.VcTitle = title;
    TextVc.ResCall = call;
    TextVc.UseTableSex = sex;
    [TextVc showVC];
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
        _.placeholder = _PlaceText;
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
        _.textColor = kColorText33;
        _.text = _DefaultText;
        _.returnKeyType = UIReturnKeyDone;
        _.delegate = self;
        _.clearButtonMode = UITextFieldViewModeWhileEditing;
        _.JEMaxTextLength = _limit;
        _.placeholder = _PlaceText;
        _.clearButtonMode = UITextFieldViewModeWhileEditing;
        [view addSubview:_Tf_ =  _];
        
//        if ([_VcTitle isEqualToString:@"名片"]) {
//            _Tf_.x = 40;
//            _Tf_.width -= 40;
//            
//            UILabel *la = [UILabel Frame:CGRectMake(12, 0, 30, 20) text:@"备注".loc font:@14 color:kColorText33];
//            la.centerY = _Tf_.centerY;
//            [view addSubview:la];
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存".loc style:UIBarButtonItemStylePlain target:self action:@selector(TExtvEditimgDown)];
//        }
    }
    return _Tf_;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _VcTitle;
    
    if (_UseTableSex) {
        [self SetupTableview];
        return;
    }
    
    _Btn_done = [self je_rightBarBtn:@"确定".loc act:@selector(TExtvEditimgDown)];
    
    if (_UseTextField) {
        [self Tf_];
        return;
    }
    
    self.TextV_.placeholder = _PlaceText;
    [TextV_ becomeFirstResponder];
    
    //显示剩余字符限制的label
    UILabel *_ = [[UILabel alloc]initWithFrame:CGRectMake(TextV_.superview.width - 33, TextV_.bottom - 24, 30, 15)];
    _.textColor = [UIColor grayColor];
    _.font = [UIFont systemFontOfSize:15.5];
    [self.view addSubview:La_Lim = _];
    [self textViewDidChange:TextV_];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextFieldTextDidChangeNotification object:TextV_];
}

#pragma mark - 选性别的

- (void)SetupTableview{
    UITableView *_ = [[UITableView alloc]initWithFrame:CGRectMake(0, TopSep, ScreenWidth, 88) style:UITableViewStyleGrouped];
    _.delegate = (id<UITableViewDelegate>)self;
    _.dataSource = (id<UITableViewDataSource>)self;
    _.scrollEnabled = NO;
    [_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    if (@available(iOS 11.0, *)) {
        _.estimatedRowHeight = 0;
        _.estimatedSectionHeaderHeight = 0;
        _.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview: Tv_ = _];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{ return  0.1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ return 2;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.textColor = kColorText33;
    cell.textLabel.text = indexPath.row ? @"女".loc : @"男".loc;
    cell.accessoryType =  [cell.textLabel.text isEqualToString:_UseTableSex] ?   UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    !_ResCall ?: _ResCall(indexPath.row ? @"女".loc : @"男".loc);
    [self.Nav popViewControllerAnimated:YES];
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
        //        textView.text = [textView.text LimitMaxTextShow:_limit];
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
