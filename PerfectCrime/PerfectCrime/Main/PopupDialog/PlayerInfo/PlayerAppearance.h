//
//  PlayerAppearance.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgAppearance.h"

@interface PlayerAppearance : DlgAppearance

#pragma mark ---  个人信息
/** 玩家id*/
@property (nonatomic ,copy) NSString *myUserID;
/** 头像*/
@property (nonatomic,strong) NSString * portrait;
/** 昵称*/
@property (nonatomic, copy) NSString *nick;
/** 性别*/
@property (nonatomic ,strong) NSString *sex;
/** 年龄*/
@property (nonatomic ,strong) NSNumber *age;
/** 地区*/
@property (nonatomic ,copy) NSString *addr;
#pragma mark ---  游戏信息
/** 总局数*/
@property (nonatomic ,copy) NSString *gamesNum;
/** 总胜场*/
@property (nonatomic ,copy) NSString *winsNum;
/** 胜率*/
@property (nonatomic ,copy) NSString *winsRate;
/** 总得分*/
@property (nonatomic ,copy) NSString *gameScore;
/** MVP次数*/
@property (nonatomic ,copy) NSString *mvpNum;

- (void)setViewInfo:(NSDictionary*)m_dict;

@end
