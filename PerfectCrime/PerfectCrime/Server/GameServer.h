//
//  GameServer.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GameServerResponseID) {
    // 玩家入座
    GameServerResponseID_userSit = 0,
    // 开始游戏
    GameServerResponseID_startGame,
    // 杀手杀人
    GameServerResponseID_killPeople,
    // 杀手发言
    GameServerResponseID_murderSpeak,
    // 杀手发言结束
    GameServerResponseID_murderSpeakEnd,
    // 警察验人
    GameServerResponseID_policeCheck,
    // 警察发言
    GameServerResponseID_policeSpeak,
    // 投票
    GameServerResponseID_voteExecute,
    // 玩家依次发言
    GameServerResponseID_pleyerSpeak,
    // 选举MVP
    GameServerResponseID_voteMVP,
    // 配置游戏属性
    GameServerResponseID_config
};

@protocol GameServerDelegate<NSObject>
-(void)onGameServerResponseWithID:(GameServerResponseID)enum_id andResponse:(NSDictionary*)m_dict;
@end

@interface GameServer : NSObject
{
    __unsafe_unretained id <GameServerDelegate> _delegate;
}
@property (nonatomic,assign)id <GameServerDelegate> delegate;

-(void)requestUserSit:(NSDictionary*)m_dict;
-(void)requestStartGame:(NSDictionary*)m_dict;
-(void)requestKillPeople:(NSDictionary*)m_dict;
-(void)requestMurderSpeak:(NSDictionary*)m_dict;
-(void)requestMurderSpeakEnd:(NSDictionary*)m_dict;
-(void)requestPoliceCheck:(NSDictionary*)m_dict;
-(void)requestPoliceSpeak:(NSDictionary*)m_dict;
-(void)requestVoteExecute:(NSDictionary*)m_dict;
-(void)requestPleyerSpeak:(NSDictionary*)m_dict;
-(void)requestVoteMVP:(NSDictionary*)m_dict;
-(void)requestGetUserSort:(NSDictionary*)m_dict;
-(void)requestGetConfig:(NSDictionary*)m_dict;
@end
