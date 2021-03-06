
#import "JEPickerView.h"
#import "JEKit.h"

static NSInteger const jkPickViewHeight = 216;///<
static NSInteger const jkActionBarHeight = 48;///<

@implementation JEPickerView{
    NSArray <NSString *> *_Arr_custom;
}

+ (void)ShowCustomArr:(NSArray <NSString *>*)arr res:(JEPVCusArrBlock)block{
    [self ShowCustomArr:arr title:nil current:nil res:block];
}

+ (void)ShowCustomArr:(NSArray <NSString *>*)arr title:(NSString *)title res:(JEPVCusArrBlock)block{
    [self ShowCustomArr:arr title:title current:nil res:block];
}

+ (void)ShowCustomArr:(NSArray <NSString *>*)arr title:(NSString *)title current:(id)current res:(JEPVCusArrBlock)block{
    JEPickerView *_ = [[JEPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)].addTo(JEApp.window).jo.insets(0);
    _->_Arr_custom = arr;
    _.cusArrBlock = block;
    [_ pickV];
    [_.pickV reloadAllComponents];
    [_ actionBarWithTitle:title];
   
    if (current) {
        if ([current isKindOfClass:[NSString class]]) {
            [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:current]) {[_.pickV selectRow:idx inComponent:0 animated:NO]; *stop = YES; }
            }];
        }
        if ([current isKindOfClass:[NSNumber class]] && ((NSNumber *)current).integerValue < arr.count) {
            [_.pickV selectRow:((NSNumber *)current).integerValue inComponent:0 animated:NO];
        }
    }
//    [_.pickV.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
//        if (obj.height < 1) { obj.backgroundColor = (kHexColor(0xDDDDDD)); }
//    }];
}

+ (void)ShowDatePicker:(JEPVDateBlock)date{
    [self ShowDatePicker:date current:[NSDate date] min:nil max:nil title:nil mode:UIDatePickerModeDate];
}

+ (void)ShowDatePicker:(JEPVDateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max{
    [self ShowDatePicker:date current:current min:min max:max title:nil mode:UIDatePickerModeDate];
}

+ (void)ShowDatePicker:(JEPVDateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max mode:(UIDatePickerMode)mode{
     [self ShowDatePicker:date current:current min:min max:max title:nil mode:mode];
}

+ (void)ShowDatePicker:(JEPVDateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max title:(NSString *)title mode:(UIDatePickerMode)mode{
    JEPickerView *_ = [[JEPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)].addTo(JEApp.window).jo.insets(0);
    [_ actionBarWithTitle:title];
    _.dateBlock = date;
    _.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0 ,jkActionBarHeight, ScreenWidth, jkPickViewHeight)].addTo(_.Ve_content).jo.lr(0).h(jkPickViewHeight).top(jkActionBarHeight).me;
    _.datePicker.backgroundColor = UIColor.clearColor;
    _.datePicker.datePickerMode = mode;
    [_.datePicker setDate:(current ? : [NSDate date]) animated:NO];
    _.datePicker.minimumDate = min;
    _.datePicker.maximumDate = max;
}

+ (void)ShowLocationPick:(JEPVLocationBlock)loca{
    [self ShowLocationPick:loca both:NO];
}

+ (void)ShowLocationPick:(JEPVLocationBlock)loca both:(BOOL)both{
    [self ShowLocationPick:loca both:both currentCity:nil];
}

+ (void)ShowLocationPick:(JEPVLocationBlock)loca both:(BOOL)both currentCity:(NSString *)currentCity{
    JEPickerView_City *_ = [[JEPickerView_City alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) loca:loca both:both currentCity:currentCity].addTo(JEApp.window).jo.insets(0);
    [_ pickV];
    [_ actionBarWithTitle:nil];
}

#pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame contentHieht:jkActionBarHeight + jkPickViewHeight];
    self.popType = JEPopTypeBottom;
    self.tapToDismiss = YES;
    self.Ve_content.rad = 0;
    [self show];
    return self;
}

- (UIPickerView *)pickV{
    if (!_pickV) {
        _pickV = [[UIPickerView alloc]initWithFrame:JR0].addTo(self.Ve_content).jo.lr(0).h(jkPickViewHeight).top(jkActionBarHeight).me;
        _pickV.backgroundColor = UIColor.clearColor;
        _pickV.delegate = self;
        _pickV.dataSource = self;
    }return _pickV;
}

- (void)actionBarWithTitle:(NSString *)title{
    UIColor *btnColor = JEShare.themeClr ? : Clr_blue;
    UIView *_ = JEVe(JR0, UIColor.clearColor, self.Ve_content).
    jo.lr(0).top(0).h(jkActionBarHeight).me;
//    JEEFVe(JR0, UIBlurEffectStyleRegular, _).jo.insets(0);
    JEVe(JR0, UIColor.je_sep, _).jo.lr(0).bottom(0).h(0.5);

    JEButton *left = JEBtnSys(JR0,@"取消".loc,@16,btnColor,self,@selector(dismiss),nil,0,_).touchs(0,0,0,20).jo.left(15).top(0).bottom(0).me;
    left.jo.w([left sizeThatWidth].width);
    
    JEButton *right = JEBtnSys(JR0,@"确定".loc,fontM(16),btnColor,self,@selector(confirmBtnClick),nil,0,_).touchs(0,20,0,0) .jo.right(15).top(0).bottom(0).me;
    right.jo.w([right sizeThatWidth].width);
    
    JELab(JR(9, 0, ScreenWidth - 9, _.height),title,@14.5,Tgray1,(NSTextAlignmentCenter),_).jo.left_(left,8).right_(right, 8).top(0).bottom(0);
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    [self.Ve_content je_corner:(UIRectCornerTopLeft | UIRectCornerTopRight) rad:12];
//}

- (void)confirmBtnClick{
    !_cusArrBlock ? : _cusArrBlock([_pickV selectedRowInComponent:0],_Arr_custom[[_pickV selectedRowInComponent:0]]);
    !_dateBlock ? : _dateBlock(_datePicker.date);
    [self dismiss];
}

#pragma mark - UIPicker Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{ return 44;}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {return 1;}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {return _Arr_custom.count;}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {return _Arr_custom[row];}
/*
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[NSAttributedString alloc] initWithString:_Arr_custom[row] attributes:@{NSForegroundColorAttributeName : c}];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* label = (UILabel*)view;
    if (label == nil){
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font(20);
    }

    label.text = [self titleFromPickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (NSString *)titleFromPickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    UILabel *la = (UILabel*)[pickerView viewForRow:row forComponent:component];
    la.textColor = JEShare.themeClr ? : nil;
    return _Arr_custom[row];
}
*/

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEPickerView_City   🔷 区选择
@implementation JEPickerView_City{
    NSDictionary <NSString *,NSArray <NSDictionary <NSString *,NSArray <NSString *> *> *> *> *_plist;
    NSArray <NSString *> *_Arr_province,*_Arr_city,*_Arr_town;
    NSArray <NSDictionary *> *_Arr_select;
    NSArray <NSArray <NSString *> *> *_Arr_mix;
    BOOL _both;
}

- (instancetype)initWithFrame:(CGRect)frame loca:(JEPVLocationBlock)loca both:(BOOL)both currentCity:(NSString *)currentCity{
    self = [super initWithFrame:frame];
    _both = both;
    _locationBlock = loca;
    
    _plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JEResource" ofType:@"bundle"]] pathForResource:@"JEAddress" ofType:@"plist"]];
    
    _Arr_province = [[_plist allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 isEqualToString:@"广东省"] ? NSOrderedAscending : NSOrderedDescending;
    }];

    _Arr_select = _plist[_Arr_province[0]];
    if (_Arr_select.count > 0) {_Arr_city = [_Arr_select[0] allKeys];}
    if (_Arr_city.count > 0) {_Arr_town = _Arr_select[0][(_Arr_city[0])];}
    _Arr_mix = @[_Arr_province,_Arr_city,_Arr_town];

    if (currentCity) {
        __block NSString *fromProKey = nil;
        [_Arr_province enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *province = self->_plist[obj].firstObject;
            if ([province.allKeys containsObject:currentCity]) { fromProKey = obj;*stop = YES;}
        }];
        if (fromProKey) {
            [self pickerView:self.pickV didSelectRow:[_Arr_province indexOfObject:fromProKey] inComponent:0];
            [self.pickV selectRow:[_Arr_province indexOfObject:fromProKey] inComponent:0 animated:NO];
            
            [self pickerView:self.pickV didSelectRow:[_Arr_city indexOfObject:currentCity] inComponent:1];
            [self.pickV selectRow:[_Arr_city indexOfObject:currentCity] inComponent:1 animated:NO];
        }
    }
    
    [self.pickV reloadAllComponents];
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return _both ? 2 : 3;}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {return _Arr_mix[component].count;}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {return _Arr_mix[component][row];}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _Arr_select = _plist[[_Arr_province objectAtIndex:row]];
        _Arr_city = (_Arr_select.count > 0 ? [_Arr_select[0] allKeys] : nil);
        _Arr_town = (_Arr_city.count > 0 ? _Arr_select[0][(_Arr_city[0])] : nil);
    }
    
    if (_Arr_province == nil | _Arr_city == nil | _Arr_town == nil) { return;}
    
    _Arr_mix = @[_Arr_province,_Arr_city,_Arr_town];
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    if (!_both) {[pickerView selectedRowInComponent:2];}
    
    if (component == 1) {
        _Arr_town = (_Arr_select.count > 0 && _Arr_city.count > 0) ? (_Arr_select[0][(_Arr_city[row])]) : (nil);
        if (!_both) {[pickerView selectRow:0 inComponent:2 animated:YES];}
    }
    if (_Arr_province == nil | _Arr_city == nil | _Arr_town == nil) { return;}
    
    _Arr_mix = @[_Arr_province,_Arr_city,_Arr_town];
    if (!_both) {[pickerView reloadComponent:2];}
}

- (void)confirmBtnClick{
    NSString *province = _Arr_province[[self.pickV selectedRowInComponent:0]];
    NSString *city = _Arr_city[[self.pickV selectedRowInComponent:1]];
    NSString *town = _both ? city : _Arr_town[[self.pickV selectedRowInComponent:2]];

    NSString *mixStr = Format(@"%@ %@ %@",province,city,town);
    if ([province isEqualToString:town]) { mixStr = province;}//香港 台湾 澳门
    else if ([province isEqualToString:city]) { mixStr = Format(@"%@ %@",province,town);}//北京市
    
    _locationBlock(@[province,city,town],mixStr);
    
    [self dismiss];
}

@end
