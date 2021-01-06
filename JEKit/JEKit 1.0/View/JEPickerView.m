
#import "JEPickerView.h"
#import "JEKit.h"

static NSInteger const jkPickViewHeight = 216;///<
static NSInteger const jkActionBarHeight = 48;///<

@implementation JEPickerView{
    NSArray <NSString *> *_Arr_custom;
}
//- (void)dealloc{jkDeallocLog;}

/** 自定义的数组 */
+ (void)ShowCustomArr:(NSArray <NSString *>*)arr res:(JEPVCusArrBlock)block{
    [self ShowCustomArr:arr title:nil current:nil res:block];
}

+ (void)ShowCustomArr:(NSArray <NSString *>*)arr title:(NSString *)title res:(JEPVCusArrBlock)block{
    [self ShowCustomArr:arr title:title current:nil res:block];
}

+ (void)ShowCustomArr:(NSArray <NSString *>*)arr title:(NSString *)title current:(id)current res:(JEPVCusArrBlock)block{
    JEPickerView *_ = [[JEPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)].addTo(JEApp.window);
    _->_Arr_custom = arr;
    _.cusArrBlock = block;
    [_ pickV];
    [_.pickV reloadAllComponents];
    [_ actionBarWithTitle:title];
    [_ layoutIfNeeded];
    _.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
   
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
    
    [_ show];
//    [_.pickV.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
//        if (obj.height < 1) { obj.backgroundColor = (kHexColor(0xDDDDDD)); }
//    }];
}

/** 时间选择器 */
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
    JEPickerView *_ = [[JEPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)].addTo(JEApp.window);
    [_ actionBarWithTitle:title];
    _.dateBlock = date;
    _.datePicker = [[UIDatePicker alloc] initWithFrame:JR(0, 0, 0, 0)].addTo(_.Ve_content);
    if (@available(iOS 13.4, *)) {
        _.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    if (@available(iOS 14.0, *)) {
        _.datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    }
    
    _.datePicker.datePickerMode = mode;
 
    if (@available(iOS 14.0, *)) {  
//        [_.datePicker sizeToFit];
        _.datePicker.frame = JR((kSW - _.datePicker.width)/2, jkActionBarHeight, _.datePicker.width, _.datePicker.height);
        _.Ve_content.height = _.datePicker.height + jkActionBarHeight;
    }else{
        _.datePicker.frame = CGRectMake(0, jkActionBarHeight, ScreenWidth, jkPickViewHeight);
    }
    
    _.datePicker.minimumDate = min;
    _.datePicker.maximumDate = max;
    [_.datePicker setDate:(current ? : [NSDate date]) animated:NO];
    
    [_ show];
}

/**< 地区选择 */
+ (void)ShowLocationPick:(JEPVLocationBlock)loca{
    [self ShowLocationPick:loca both:NO];
}

+ (void)ShowLocationPick:(JEPVLocationBlock)loca both:(BOOL)both{
    [self ShowLocationPick:loca both:both currentCity:nil];
}

+ (void)ShowLocationPick:(JEPVLocationBlock)loca both:(BOOL)both currentCity:(NSString *)currentCity{
    JEPickerView_City *_ = [[JEPickerView_City alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) loca:loca both:both currentCity:currentCity].addTo(JEApp.window);
    [_ pickV];
    [_ actionBarWithTitle:nil];
    [_ show];
}

#pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame contentHieht:jkActionBarHeight + jkPickViewHeight];
    self.popType = JEPopTypeBottom;
    self.tapToDismiss = YES;
//    [self show];
    return self;
}

- (UIPickerView *)pickV{
    if (!_pickV) {
        _pickV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, jkActionBarHeight, ScreenWidth, jkPickViewHeight)].addTo(self.Ve_content);
        _pickV.delegate = self;
        _pickV.dataSource = self;

    }return _pickV;
}

- (void)actionBarWithTitle:(NSString *)title{
    UIColor *btnColor = JEShare.themeColor ? : kHexColor(0x007AFF);
    UIView *_ = [UIView Frame:CGRectMake(0, 0, ScreenWidth, jkActionBarHeight) color:kRGBA(255, 255, 255, 0.8)].addTo(self.Ve_content);
    [_.layer addSublayer:[CALayer je_DrawLine:CGPointMake(0, _.height) To:CGPointMake(_.width, _.height) color:(kHexColor(0xEFEFEF))]];
    JEButton *cancel = [JEButton Frame:CGRectMake(15, 0, 60, _.height) title:NSLocalizedString(@"取消", nil) font:font(16) color:btnColor rad:0 tar:self sel:@selector(dismiss) img:nil].touchs(0, 0, 0, 20).addTo(_);
    [cancel sizeThatWidth];
    JEButton *ok = [JEButton Frame:CGRectZero title:NSLocalizedString(@"确定", nil) font:font(16) color:btnColor rad:0 tar:self sel:@selector(confirmBtnClick) img:nil].touchs(0, 20, 0, 0).addTo(_);
    [ok sizeThatWidth];
    ok.frame = CGRectMake(ScreenWidth - ok.width - 15, 0, ok.width, _.height);
    
//    [UILabel Frame:CGRectMake(9/2 + (_.width - 200)/2, 0, 200, _.height) text:title font:@14.5 color:kColorText99 align:NSTextAlignmentCenter].addTo(_);
    [UILabel Frame:CGRectMake(9, 0, ScreenWidth - 9, _.height) text:title font:@14.5 color:kColorText99 align:NSTextAlignmentCenter].addTo(_);
}

- (void)confirmBtnClick{
    if (_pickV && ([_pickV selectedRowInComponent:0] >= _Arr_custom.count || [_pickV selectedRowInComponent:0] == -1)) {
        return;
    }
    !_cusArrBlock ? : _cusArrBlock([_pickV selectedRowInComponent:0],_Arr_custom[[_pickV selectedRowInComponent:0]]);
    !_dateBlock ? : _dateBlock(_datePicker.date);
    [self dismiss];
}

#pragma mark - UIPicker Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{ return 44;}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {return 1;}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {return _Arr_custom.count;}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {return _Arr_custom[row];}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[NSAttributedString alloc] initWithString:_Arr_custom[row] attributes:@{NSForegroundColorAttributeName : kColorText}];
}

/*
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
    la.textColor = JEShare.themeColor ? : kColorText33;
    return _Arr_custom[row];
}
*/

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   JEPickerView_City   🔷 区选择
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
