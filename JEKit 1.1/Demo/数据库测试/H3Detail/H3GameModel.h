//
//  H3GameModel.h
//  JEKit
//
//  Created by JE on 2019/4/26.
//  Copyright © 2019 JE. All rights reserved.
//

#import "JEDBModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, H3HeroCareer) {
    H3HeroCareer_knight,///< 骑士
    H3HeroCareer_barbarian,///< 野蛮人
    H3HeroCareer_patrol,///< 巡逻兵
    H3HeroCareer_undead,///< 亡灵
};

typedef NS_ENUM(NSUInteger, H3RaceType) {
    H3RaceType_CstleTown,///< 城堡
    H3RaceType_StrongHold,///< 据点
    H3RaceType_Rampart,///< 壁垒
    H3RaceType_necroTown,///< 墓园
};



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   H3ArmModel   🔷 兵种
@interface H3ArmModel : JEDBModel

@property NSString  *name;
@property NSInteger  number;
@property NSInteger  lv;

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   H3HeroModel   🔷 英雄
@interface H3HeroModel : JEDBModel

@property NSString  *name;
@property H3RaceType  race;///< 种族
@property H3HeroCareer  career;///< 职业
@property NSNumber  *combatPower;///< 战斗力
@property (nonatomic) NSMutableArray <H3ArmModel *> *arms; ///< 带的兵种
@property H3ArmModel *tagArm;///< 特长兵种

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   H3GameModel   🔷 游戏
@interface H3GameModel : JEDBModel

@property NSString  *name;
@property NSString  *desc;
@property float price;
@property NSArray <NSString *> *mark; ///< ..
@property NSMutableArray <NSNumber *> *race; ///< ..
@property NSMutableArray <H3HeroModel *> *heros; ///< ..


@end

NS_ASSUME_NONNULL_END
