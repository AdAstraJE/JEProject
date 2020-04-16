
#import "H3DetailVC.h"
#import "JEKit.h"
#import "H3GameModel.h"

@implementation H3DetailVC{
    Class _class;
}
- (instancetype)sendInfo:(Class)info{ _class = info;return self;}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"H3".loc;
    
    if (_class == H3ArmModel.class) {[self lookArm];}
    else if (_class == H3HeroModel.class) {[self lookHero];}
    
}

#pragma mark -
- (void)lookArm{
    JELiteTV *_ = [self liteTv:(UITableViewStylePlain) cellC:UITableViewCell.class cellH:50 cell:^(__kindof UITableViewCell *cell, UITableView *tv, NSIndexPath *idx, H3ArmModel *obj) {
        cell.textLabel.text = obj.name;
        
    } select:nil];
    
    [H3ArmModel AllModel:^(NSMutableArray<JEDBModel *> *models) {
        _.Arr = models;
        [_ reloadData];
    } desc:YES];
}


#pragma mark -
- (void)lookHero{
    JELiteTV *_ = [self liteTv:UITableViewStyleGrouped cellC:UITableViewCell.class cellH:50 cell:^(__kindof UITableViewCell *cell, UITableView *tv, NSIndexPath *idx, H3HeroModel *obj) {
        cell.textLabel.text = Format(@"%@ - %@",obj.arms[idx.row].name,@(obj.arms[idx.row].number));
        
    } select:nil];
    
    [H3HeroModel AllModel:^(NSMutableArray <JEDBModel *> *models) {
        _.Arr = models;
        [_ reloadData];
    } desc:YES];
    
    _.sections = ^NSInteger(UITableView *tv) {
        return tv.Arr.count;
    };
    _.rows = ^NSInteger(UITableView *tv, NSInteger section) {
        return ((H3HeroModel *)tv.Arr[section]).arms.count;
    };
    _.headerTitle = ^NSString *(UITableView *tv, NSInteger section) {
        return Format(@"%@     -特长%@",((H3HeroModel *)tv.Arr[section]).name,((H3HeroModel *)tv.Arr[section]).tagArm.name);
    };
    _.headH = ^CGFloat(UITableView *tv, NSInteger section) {
        return 50;
    };
}

@end
