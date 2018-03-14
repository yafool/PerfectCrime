//
//  DataStructure.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DataStructure.h"

#pragma mark -------- RoomInfo [begin] ----------------/
@implementation RoomInfo

@synthesize roomId;
@synthesize hoster;
@synthesize roomName;
@synthesize grade;
@synthesize speed;
@synthesize limit;
@synthesize passwd;
@synthesize startGame;

// 带参数的构造函数
-(RoomInfo *)initRoomInfo{
    if(self=[super init]){
        roomId = @"";
        hoster = @"";
        roomName = @"";
        grade = @"";
        speed = @"";
        limit = @"8";
        passwd = @"";
        startGame = ReadyForGame_notReady;
    }
    return self;

}

@end
#pragma mark -------- RoomInfo [end] ----------------/

/*
 * 头像、昵称、序号、身份标识（警察、匪徒、平民）、出局玩家头像被统一图片取代、点选某玩家头像的点选框
 **/
#pragma mark -------- PlayerInfo [begin] ----------------/
@implementation PlayerInfo

@synthesize  userId;
@synthesize  picUrl;
@synthesize  picFrame;
@synthesize  nickName;
@synthesize  role;
@synthesize  identity;
@synthesize  ready;
@synthesize  num;
@synthesize  killed;
@synthesize  roomId;
@synthesize  trusteeship;
@synthesize  age;
@synthesize  area;
@synthesize  failNum;
@synthesize  kin;
@synthesize  sex;
@synthesize  winNum;

+(PlayerInfo *)initPlayerWithDictionary:(NSDictionary*)m_dict{
    return [[PlayerInfo alloc]initPlayerWithDictionary:m_dict];
}

-(PlayerInfo *)initPlayerWithDictionary:(NSDictionary *)m_dict{
    
    if(self=[super init]){
        userId = @"";
        picUrl = @"";
        picFrame = @"";
        nickName = @"";
        role = PlayerRole_bystander;
        identity = NO;
        ready = PlayerReady_outsider;
        num = 0;
        killed = NO;
        roomId = @"";
        trusteeship = NO;
        age = @"";
        area = @"";
        failNum = @"";
        kin = @"";
        sex = @"";
        winNum = @"";
        [m_dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *formatStr = [NSString stringWithFormat:@"%@", obj];
            if ([@"age" isEqualToString:key]) {
                age = formatStr;
            }else if ([@"failNum" isEqualToString:key]) {
                failNum = formatStr;
            }else if ([@"killed" isEqualToString:key]) {
                killed = (0==[formatStr integerValue])?NO:YES;
            }else if ([@"kin" isEqualToString:key]) {
                kin = formatStr;
            }else if ([@"roomId" isEqualToString:key]) {
                roomId = formatStr;
            }else if ([@"roomId" isEqualToString:key]) {
                roomId = formatStr;
            }else if ([@"num" isEqualToString:key] || [@"seatNo" isEqualToString:key]){
                num = formatStr;
            }else if ([@"sex" isEqualToString:key]) {
                sex = (0==[formatStr integerValue])?@"男":@"女";
            }else if ([@"winNum" isEqualToString:key]) {
                winNum = formatStr;
            }else if ([@"role" isEqualToString:key]) {
                role = [formatStr integerValue];
            }else if ([@"ready" isEqualToString:key]){
                ready = [formatStr integerValue];
            }else if ([@"userId" isEqualToString:key]){
                userId = formatStr;
            }else if ([@"picUrl" isEqualToString:key]){
                picUrl = formatStr;
            }else if ([@"picFrame" isEqualToString:key]){
                picFrame = formatStr;
            }else if ([@"nickName" isEqualToString:key]){
                nickName = formatStr;
            }
            
        }];
        
    }
    return self;
}

@end
#pragma mark -------- PlayerInfo [end] ----------------/

/*
 * 游戏属性
 **/
#pragma mark -------- GameConfig [begin] ----------------/
@implementation GameConfig

@synthesize  murderNightSpeakTime;
@synthesize  murderNightKillTime;
@synthesize  policeNightSpeakTime;
@synthesize  policeNightCheckTime;
@synthesize  daySpeakTime;
@synthesize  dayVoteTime;

-(GameConfig *)initGameConfig{
    
    if(self=[super init]){
        murderNightSpeakTime = 0;
        murderNightKillTime = 0;
        policeNightSpeakTime = 0;
        policeNightCheckTime = 0;
        daySpeakTime = 0;
        dayVoteTime = 0;
    }
    return self;
}

@end
#pragma mark -------- GameConfig [end] ----------------/

/*
 * 游戏进度 天黑／天亮、第几天
 **/
#pragma mark -------- GameProgress [begin] ----------------/
@implementation GameProgress

@synthesize  dayState;
@synthesize  days;

-(GameProgress *)initGameProgress{
    
    if(self=[super init]){
        dayState = DayState_dawn;
        days = 1;
    }
    return self;
}

@end
#pragma mark -------- GameProgress [end] ----------------/
