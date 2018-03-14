//
//  GameHandler.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/12/3.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataStructure.h"

@protocol GameHandlerDelegate <NSObject>

@optional
// 天黑请闭眼
- (void)atNightfall;
// 警察交流
- (void)policeTalk;
// 警察开始验人
- (void)policeCheck;
// 验人
- (void)vote2Check:(PlayerInfo*)player;
// 匪徒交流
- (void)terroristTalk;
// 匪徒开始杀人
- (void)terroristKill;
// 杀人
- (void)vote2Kill:(PlayerInfo*)player;
// 投票结束
- (void)voteEnd;
// 天亮了
- (void)atDaybreak;
// 天亮后依次发言
- (void)speakByPlayer:(PlayerInfo*)player;
// 玩家托管了
- (void)trusteeshipPlayer:(PlayerInfo*)player;
// 开始曝匪
- (void)killTerrorist;
// 白天的投票
- (void)voteAtDay:(PlayerInfo*)player;
// 游戏结束
- (void)gameOver;
// 天黑倒计时
- (void)nightfallTicker:(NSString*)title;
// 天亮倒计时
- (void)daybreakTicker:(NSString*)title;

@end

@interface GameHandler : NSObject
// 游戏进度管理单例
+ (instancetype)shareInstance;
//添加代理
- (void)addDelegate:(id<GameHandlerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;
//移除代理
- (void)removeDelegate:(id<GameHandlerDelegate>)delegate;
- (void)removeAllDelegate;
// 游戏开始
- (void)gameBegin;
// 游戏结束
- (void)gameEnd;

// 天黑请闭眼
- (void)atNightfall;
// 警察交流
- (void)policeTalk;
// 警察开始验人
- (void)policeCheck;
// 验人
- (void)vote2Check:(PlayerInfo*)player;
// 匪徒交流
- (void)terroristTalk;
// 匪徒开始杀人
- (void)terroristKill;
// 杀人
- (void)vote2Kill:(PlayerInfo*)player;
// 投票结束
- (void)voteEnd;
// 天亮了
- (void)atDaybreak;
// 天亮后依次发言
- (void)speakByPlayer:(PlayerInfo*)player;
// 玩家托管了
- (void)trusteeshipPlayer:(PlayerInfo*)player;
// 开始曝匪
- (void)killTerrorist;
// 白天的投票
- (void)voteAtDay:(PlayerInfo*)player;
// 天黑倒计时
- (void)nightfallTicker:(NSString*)title;
// 天亮倒计时
- (void)daybreakTicker:(NSString*)title;
@end
