//
//  GameInfoManager.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/27.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStructure.h"

@interface GameInfoManager : NSObject
@property (nonatomic, copy) RoomInfo                        *roomInfo;
@property (nonatomic, copy) NSMutableArray <PlayerInfo*>    *players;
@property (nonatomic, copy) GameProgress                    *gameProgress;
@property (nonatomic, copy) GameConfig                      *gameConfig;


+ (GameInfoManager *)sharedGameInfoManager;

-(void)updateRoomInfo:(NSDictionary*)m_dict;
-(void)updatePlayers:(NSArray *)ary_play;
-(void)updateGameProgress:(NSInteger)days andDayState:(DayState)state;
-(void)updateGameConfig:(NSDictionary*)m_dict;
-(PlayerInfo*)getPlayerSelf;
-(void)resetGameInfo;
@end
