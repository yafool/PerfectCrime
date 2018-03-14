//
//  GameServer.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "GameServer.h"

@implementation GameServer

@synthesize delegate = _delegate;


-(void)onResponsServer:(GameServerResponseID)enum_id andResponse:(NSDictionary *) response{
    if (_delegate && [_delegate respondsToSelector:@selector(onGameServerResponseWithID: andResponse:)])
    {
        [_delegate onGameServerResponseWithID:enum_id andResponse:response];
    }
}
/**
 * @Parameter postDict
 * userId: "用户id"
 * roomId: "房间id"
 * type:   "用户状态"
 */
-(void)requestUserSit:(NSDictionary*)m_dict{
    NSString * url = @"/murder/game/userSit";
    GameServerResponseID enum_id = GameServerResponseID_userSit;
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}
/**
 * @Parameter postDict
 * userId: "用户id"
 * roomId: "房间id"
 */
-(void)requestStartGame:(NSDictionary*)m_dict{
    NSString * url = @"murder/game/startGame";
    GameServerResponseID enum_id = GameServerResponseID_startGame;
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}
/**
 * @Parameter postDict
 * userId:       "用户id"
 * roomId:       "房间id"
 * killEdUserId: "被杀玩家id"
 */
-(void)requestKillPeople:(NSDictionary*)m_dict{
    NSString * url = @"murder/game/killPeople";
    GameServerResponseID enum_id = GameServerResponseID_killPeople;
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}
/**
 * @Parameter postDict
 * userId:       "用户id"
 * roomId:       "房间id"
 * content:      "讨论内容"
 */
-(void)requestMurderSpeak:(NSDictionary*)m_dict{
    NSString * url = @"murder/game/murderspeak";
    GameServerResponseID enum_id = GameServerResponseID_murderSpeak;
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}

/**
 * @Parameter postDict
 * userId:       "用户id"
 * roomId:       "房间id"
 * checkUserId:  "警察验人id"
 */
-(void)requestPoliceCheck:(NSDictionary*)m_dict{
    NSString * url = @"murder/game/";
    GameServerResponseID enum_id = GameServerResponseID_policeCheck;
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}
/**
 * @Parameter postDict
 * userId:       "用户id"
 * roomId:       "房间id"
 * selectedUserId: "投票选择人"
 */
-(void)requestVoteExecute:(NSDictionary*)m_dict{
    NSString * url = @"murder/game/";
    GameServerResponseID enum_id = GameServerResponseID_voteExecute;
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}

/**
 * @Parameter postDict
 * userId:       "用户id"
 * roomId:       "房间id"
 * mvp:          "选取人"
 */
-(void)requestVoteMVP:(NSDictionary*)m_dict{
    NSString * url = @"murder/game/";
    GameServerResponseID enum_id = GameServerResponseID_voteMVP;
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}

/**
 * @Parameter postDict
 * userId:       "用户id"
 */
-(void)requestGetConfig:(NSDictionary *)m_dict{
    NSString * url = @"/murder/game/config";
    GameServerResponseID enum_id = GameServerResponseID_config;
    NSMutableDictionary * postDict = nil;
    if (!m_dict) {
        postDict = [[NSMutableDictionary alloc]init];
        [postDict setValue:[SettingsManager sharedSettingsManager].userId forKey:@"userId"];
    } else{
        postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    }
    
    [self requestWithUrl:url andRequest:postDict andServerID:enum_id];
}

-(void)requestWithUrl:(NSString*)url andRequest:(NSDictionary*)postDict andServerID:(GameServerResponseID)enum_id{
    if (!url || !postDict) {
        PCLog(@"input parameter error!");
        return;
    }
    [MBProgressHUD showInfoMessage:@"加载中..."];
    // 游戏服务地址
    [HYBNetworking updateBaseUrl:GameUrl];
    
    [HYBNetworking postWithUrl:url refreshCache:NO params:postDict success:^(id response) {
        [self onResponsServer:enum_id andResponse:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}
@end
