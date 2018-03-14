//
//  GameInfoManager.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/27.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "GameInfoManager.h"

@implementation GameInfoManager

@synthesize  roomInfo;
@synthesize  players;
@synthesize  gameProgress;
@synthesize  gameConfig;

+ (GameInfoManager *)sharedGameInfoManager{
    static GameInfoManager* gameInfoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameInfoManager = [[GameInfoManager alloc] _initGameInfoManager];
    });
    
    return gameInfoManager;
}

-(GameInfoManager*)_initGameInfoManager{
    if(self=[super init]){
        roomInfo = [[RoomInfo alloc]initRoomInfo];
        players = [[NSMutableArray alloc]init];
        gameProgress = [[GameProgress alloc]initGameProgress];
        gameConfig = [[GameConfig alloc]init];
    }
    
    return self;
}
-(void)updateRoomInfo:(NSDictionary*)m_dict{
    [m_dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *formatStr = [NSString stringWithFormat:@"%@", obj];
        if ([@"roomId" isEqualToString:key]) {
            roomInfo.roomId = formatStr;
        }else if ([@"hoster" isEqualToString:key]){
            roomInfo.hoster = formatStr;
        }else if ([@"name" isEqualToString:key] || [@"roomName" isEqualToString:key]){
            roomInfo.roomName = formatStr;
        }else if ([@"grade" isEqualToString:key]){
            roomInfo.grade = formatStr;
        }else if ([@"speed" isEqualToString:key]){
            roomInfo.speed = formatStr;
        }else if ([@"limit" isEqualToString:key]){
            roomInfo.limit = formatStr;
        }else if ([@"nickName" isEqualToString:key]){
            roomInfo.passwd = formatStr;
        }else if ([@"num" isEqualToString:key]){
            roomInfo.startGame = [formatStr integerValue];
        }
    }];
}


-(void)updatePlayers:(NSArray *)ary_play{
    
    [players removeAllObjects];
    
    [ary_play enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * dict = (NSDictionary*)obj;
        PlayerInfo *playerInfo = [PlayerInfo initPlayerWithDictionary:dict];
        [players addObject:playerInfo];
    }];
    
}

-(void)updateGameProgress:(NSInteger)days andDayState:(DayState)state{
    gameProgress.days = days;
    gameProgress.dayState = state;
}

-(void)updateGameConfig:(NSDictionary*)m_dict{    
    gameConfig.murderNightSpeakTime = [[m_dict valueForKey:@"murderNightSpeakTime"] integerValue];
    gameConfig.murderNightKillTime = [[m_dict valueForKey:@"murderNightKillTime"] integerValue];
    gameConfig.policeNightSpeakTime = [[m_dict valueForKey:@"policeNightSpeakTime"] integerValue];
    gameConfig.policeNightCheckTime = [[m_dict valueForKey:@"policeNightCheckTime"] integerValue];
    gameConfig.daySpeakTime = [[m_dict valueForKey:@"daySpeakTime"] integerValue];
    gameConfig.dayVoteTime = [[m_dict valueForKey:@"dayVoteTime"] integerValue];
}

-(PlayerInfo*)getPlayerSelf{
    NSString *mySelfId = [SettingsManager sharedSettingsManager].userId;
    for (PlayerInfo *player in players) {
        if ([mySelfId isEqualToString:player.userId]) {
            return player;
        }
    }
    return nil;
}

-(void)resetGameInfo{
    
    if (nil!=roomInfo) {
        roomInfo.roomId = @"";
        roomInfo.hoster = @"";
        roomInfo.roomName = @"";
        roomInfo.grade = @"";
        roomInfo.speed = @"";
        roomInfo.limit = @"8";
        roomInfo.passwd = @"";
        roomInfo.startGame = ReadyForGame_notReady;
    }
    
    if (nil!=players) {
        [players removeAllObjects];
    }
    
    if (nil!=gameProgress) {
        gameProgress.dayState = DayState_dawn;
        gameProgress.days = 1;
    }
    
    if (nil!=gameConfig) {
        gameConfig.murderNightSpeakTime = 0;
        gameConfig.murderNightKillTime = 0;
        gameConfig.policeNightSpeakTime = 0;
        gameConfig.policeNightCheckTime = 0;
        gameConfig.daySpeakTime = 0;
        gameConfig.dayVoteTime = 0;
    }
}
@end
