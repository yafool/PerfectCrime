//
//  GameHandler.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/12/3.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "GameHandler.h"
#import "PlayBegin.h"

@interface GameHandler ()
//所有的代理
@property (nonatomic, strong) NSMutableArray *delegates;
@end

@implementation GameHandler
#pragma mark - 初始化游戏handler单例
+ (instancetype)shareInstance
{
    static GameHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[GameHandler alloc]init];
    });
    return handler;
}

#pragma mark - 代理数组
- (NSMutableArray *)delegates
{
    
    if (!_delegates) {
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

#pragma mark - 添加代理
- (void)addDelegate:(id<GameHandlerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue
{
    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

#pragma mark - 移除代理
- (void)removeDelegate:(id<GameHandlerDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}

#pragma mark - 移除所有代理
- (void)removeAllDelegate
{
    [self.delegates removeAllObjects];
}

// 游戏开始
- (void)gameBegin{
    dispatch_async(dispatch_get_main_queue(), ^{
        PlayBegin *beginState = [[PlayBegin alloc]init];
        [beginState OnPlaying];
    });
}
// 游戏结束
- (void)gameEnd{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(gameOver)]) {
                [self.delegates[i] gameOver];
            }
        }
    });
}

// 天黑请闭眼
- (void)atNightfall{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(atNightfall)]) {
                [self.delegates[i] atNightfall];
            }
        }
    });
}
// 警察交流
- (void)policeTalk{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(policeTalk)]) {
                [self.delegates[i] policeTalk];
            }
        }
    });
}
// 警察开始验人
- (void)policeCheck{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(policeCheck)]) {
                [self.delegates[i] policeCheck];
            }
        }
    });
}

// 验人
- (void)vote2Check:(PlayerInfo*)player{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(vote2Check:)]) {
                [self.delegates[i] vote2Check:player];
            }
        }
    });
}
// 匪徒交流
- (void)terroristTalk{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(terroristTalk)]) {
                [self.delegates[i] terroristTalk];
            }
        }
    });
}
// 匪徒开始杀人
- (void)terroristKill{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(terroristKill)]) {
                [self.delegates[i] terroristKill];
            }
        }
    });
}
// 杀人
- (void)vote2Kill:(PlayerInfo*)player{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(vote2Kill:)]) {
                [self.delegates[i] vote2Kill:player];
            }
        }
    });
}
// 投票结束
- (void)voteEnd{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(voteEnd)]) {
                [self.delegates[i] voteEnd];
            }
        }
    });
}
// 天亮了
- (void)atDaybreak{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(atDaybreak)]) {
                [self.delegates[i] atDaybreak];
            }
        }
    });
}
// 天亮后依次发言
- (void)speakByPlayer:(PlayerInfo*)player{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(speakByPlayer:)]) {
                [self.delegates[i] speakByPlayer:player];
            }
        }
    });
}
// 玩家托管
- (void)trusteeshipPlayer:(PlayerInfo*)player{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(trusteeshipPlayer:)]) {
                [self.delegates[i] trusteeshipPlayer:player];
            }
        }
    });
}
// 开始曝匪
- (void)killTerrorist{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(killTerrorist)]) {
                [self.delegates[i] killTerrorist];
            }
        }
    });
}
// 白天的投票
- (void)voteAtDay:(PlayerInfo*)player{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(voteAtDay:)]) {
                [self.delegates[i] voteAtDay:player];
            }
        }
    });
}
// 天黑倒计时
- (void)nightfallTicker:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(nightfallTicker:)]) {
                [self.delegates[i] nightfallTicker:title];
            }
        }
    });
}
// 天亮倒计时
- (void)daybreakTicker:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<self.delegates.count; i++) {
            if ([self.delegates[i] respondsToSelector:@selector(daybreakTicker:)]) {
                [self.delegates[i] daybreakTicker:title];
            }
        }
    });
}
@end
