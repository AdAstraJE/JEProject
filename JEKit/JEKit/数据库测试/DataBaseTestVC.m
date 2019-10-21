
#import "DataBaseTestVC.h"
#import "JEKit.h"
#import "JEDBModel.h"
#import "H3DetailVC.h"
#import "H3GameModel.h"

@implementation DataBaseTestVC{
    JESTCItem *_item_addHero,*_item_addArm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据库测试".loc;
    
    [H3GameModel CreateTable];
    [H3HeroModel CreateTable];
    [H3ArmModel CreateTable];
    
    NSArray <NSString *> *allArms = @[@"枪兵",@"弓箭手",@"狮鹫",@"十字军",@"僧侣",@"骑士",@"大天使",@"半人马",@"矮人",@"木精灵",@"飞马",@"枯木卫士",@"独角兽",@"绿龙",@"小妖精",@"石像鬼",@"石人",@"法师",@"神怪",@"蛇女",@"泰坦巨人",@"小怪物",@"歌革",@"地狱猎犬",@"恶鬼",@"邪神",@"火精灵",@"恶魔",@"骷髅兵",@"行尸",@"幽灵",@"吸血鬼",@"尸巫",@"暗黑骑士",@"骨龙"];
    
    NSArray <NSString *> *allHeros = @[@"罗德-哈特",@"凯琳",@"耿纳",@"山德鲁"];
    
    NSMutableArray <JESTCItem *> *section1 = [NSMutableArray array];
    section1.add([JESTCItem Title:@"更新表" select:^(JESTCItem *item) {
        [H3GameModel UpdateTable];
        [H3HeroModel UpdateTable];
        [H3ArmModel UpdateTable];
    }]);
    
    _item_addArm = [JESTCItem Title:Format(@"覆盖兵种(%@个)",@(allArms.count)) select:^(JESTCItem *item) {
        NSMutableArray <H3ArmModel *> *arr = [NSMutableArray array];
        [allArms enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            H3ArmModel *arm = [H3ArmModel new];
            arm.name = obj;//唯一健
            arm.lv = arc4random_uniform(7) + 1;
            [arr addObject:arm];
        }];
        
        [H3ArmModel dbSave:arr done:^(BOOL success) {
            [self refreshCount];
        }];
        
    }];
    section1.add(_item_addArm);
    
 
    _item_addHero = [JESTCItem Title:Format(@"随机覆盖一个英雄(%@个)",@(allHeros.count)) select:^(JESTCItem *item) {
        NSInteger arms = [H3ArmModel TableCount];
        if (arms == 0) {
            [self showHUD:@"加兵种先"];
            return ;
        }
        
        H3HeroModel *hero = [H3HeroModel new];
        hero.name = allHeros[arc4random_uniform((int)allHeros.count)];//唯一健
        JELog(@"%@",hero.name);
        [H3HeroModel Select:Format(@"where name = \"%@\"",hero.name) done:^(NSMutableArray <H3HeroModel *> *models) {
            if (models.count) {
                [self showHUD:Format(@"⚠️⚠️⚠️ 有这个英雄了%@，重新分配兵",hero.name)];
            }
            
            hero.race = arc4random_uniform(H3RaceType_necroTown + 1);
            hero.career = (H3HeroCareer)hero.race;
            hero.combatPower = @(arc4random_uniform(1000));
            //拿所有兵种随机分配最多7种给他
            [H3ArmModel AllModel:^(NSMutableArray <H3ArmModel *> *models) {
                
                NSInteger randArms = arc4random_uniform(7) + 1;
                while (hero.arms.count < randArms) {
                    H3ArmModel *thisArm = models[arc4random_uniform((int)models.count)];
                    thisArm.number = arc4random_uniform(500) + 1;
                    [hero.arms addObject:thisArm];
                }
                hero.tagArm = models[arc4random_uniform((int)models.count)];
                
                [hero dbSave:^(BOOL success) {
                    [self refreshCount];
                }];
  
            } desc:YES];
            
        }];
    }];
    section1.add(_item_addHero);
    
    section1.add([JESTCItem Title:@"覆盖一个游戏基本介绍" select:^(JESTCItem *item) {
        NSInteger hero = [H3HeroModel TableCount];
        if (hero == 0) {
            [self showHUD:@"i need hero"];
            return ;
        }
        
        H3GameModel *game = [H3GameModel modelWithJSON:@{@"name" : @"英雄无敌"}];
        game.id = 0;
        game.desc = @"《魔法门之英雄无敌Ⅲ》（通称“英雄无敌3”，英文缩写HoMM3），是1999年由New World Computing在Windows平台上开发的回合制策略魔幻游戏，其出版商是3DO。在PC版发布之后，3DO和Loki Software分别推出了可在苹果机和Linux系统上运行的版本。";
        game.price = 42;
        game.mark = @[@"魔幻",@"回合制",@"策略"];
        game.race = @[@(H3RaceType_CstleTown),@(H3RaceType_StrongHold),@(H3RaceType_Rampart),@(H3RaceType_necroTown)].mutableCopy;
        
        [H3HeroModel AllModel:^(NSMutableArray <H3HeroModel *> *models) {
            game.heros = models;
            [game dbSave:^(BOOL success) {
                [self showHUD:nil type:(HUDMarkTypeSuccess)];
            }];
        } desc:YES];
    }]);
    
    NSMutableArray <JESTCItem *> *section2 = [NSMutableArray array];
    section2.add([JESTCItem Title:@"游戏介绍" select:^(JESTCItem *item) {
        H3GameModel *game = [H3GameModel LastModel];
        JELog(@"%@",[game modelDescription]);
    }]);
    
    section2.add([JESTCItem Title:@"看兵" select:^(JESTCItem *item) {
        [H3DetailVC ShowVC:H3ArmModel.class];
    }]);
    
    section2.add([JESTCItem Title:@"看英雄" select:^(JESTCItem *item) {
        [H3DetailVC ShowVC:H3HeroModel.class];
    }]);
    
    section2.add([JESTCItem Title:@"清空" select:^(JESTCItem *item) {
        [H3GameModel DeleteAll];
        [H3HeroModel DeleteAll];
        [H3ArmModel DeleteAll:^(BOOL success) {
            [self refreshCount];
        }];
    }]);
    
    self.staticTv.Arr_item = @[section1,section2];
    [self refreshCount];
}

- (void)refreshCount{
    _item_addHero.desc = @([H3HeroModel TableCount]).stringValue;
    _item_addArm.desc = @([H3ArmModel TableCount]).stringValue;
}

@end
