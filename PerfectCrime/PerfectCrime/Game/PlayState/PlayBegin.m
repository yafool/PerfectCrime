//
//  PlayBegin.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/12/3.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayBegin.h"
#import "PoliceTalk.h"
#import "TerroristTalk.h"
#import "CivilianCloseEye.h"


@implementation PlayBegin

-(void)OnPlaying{
    PlayerInfo * myself = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if (PlayerRole_police == myself.role) {
        [self GoNext:[PoliceTalk new]];
    } else if (PlayerRole_terrorist == myself.role) {
        [self GoNext:[TerroristTalk new]];
    } else if (PlayerRole_civilian == myself.role) {
        [self GoNext:[CivilianCloseEye new]];
    }
}
@end
