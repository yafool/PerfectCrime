//
//  PlayersTalk.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/12/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayersTalk.h"
#import "PlayersVote.h"

static NSString *Wate2Do          =@"%ld号发言:%ld";

@interface PlayersTalk ()
//倒计时
@property (nonatomic, strong) NSTimer       *countdownTimer;
@property (nonatomic, assign) NSInteger     countdown;

// 满足发言条件的玩家
@property (nonatomic, strong) NSMutableArray *canSpeakArry;
@end

@implementation PlayersTalk
-(void)OnPlaying{
    
    if ([self initSpeakers]) {
        GameConfig * config = [GameInfoManager sharedGameInfoManager].gameConfig;
        self.countdown = config.daySpeakTime;
        
        [[GameHandler shareInstance]atDaybreak];
        
        PlayerInfo *player = [self.canSpeakArry firstObject];
        for (int i=0; i<self.canSpeakArry.count; i++) {
            if (player.trusteeship) {
                [[GameHandler shareInstance]trusteeshipPlayer:player];
                [self.canSpeakArry removeObjectAtIndex:0];
            } else {
                break;
            }
        }
        
        [self _GCD_Countdown:(int)self.countdown];
    }
    
}

-(void)_GCD_Countdown:(int)time{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        PlayerInfo *player = [self.canSpeakArry firstObject];
        
        if (!player) {
            dispatch_source_cancel(_timer);
            [self GoNext:[PlayersVote new]];
        } else {
            
            NSString *title = [NSString stringWithFormat:Wate2Do, [player.num integerValue] , timeout];
            
            [[GameHandler shareInstance]nightfallTicker:AT_Daybreak];
            [[GameHandler shareInstance]daybreakTicker:title];
            
            if (self.countdown == timeout) {// 通知这个玩家发言
                [[GameHandler shareInstance]speakByPlayer:player];
            }
            
            if (0 >= timeout) {
                timeout = (int)self.countdown;
                [self.canSpeakArry removeObjectAtIndex:0];
                
                PlayerInfo *player = [self.canSpeakArry firstObject];
                for (int i=0; i<self.canSpeakArry.count; i++) {
                    if (player.trusteeship) {
                        [[GameHandler shareInstance]trusteeshipPlayer:player];
                        [self.canSpeakArry removeObjectAtIndex:0];
                        player = [self.canSpeakArry firstObject];
                    } else {
                        break;
                    }
                }
            } else {
                timeout --;
            }
        }
    });
    dispatch_resume(_timer);
}

-(void)_startCountdownTimer{
    /**
     *在子线程中只能用 timerWithTimeInterval 来启动timer
     *如果是在View的ondestory释放timer： tag可以用用弱引用*/
    self.countdownTimer = [NSTimer timerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(_countdownFunction)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countdownTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

-(void)_countdownFunction{
    PlayerInfo *player = [self.canSpeakArry firstObject];
    
    if (!player) {
        [self _destoryCountdownTimer];
        [self GoNext:[PlayersVote new]];
    } else {
    
        NSString *title = [NSString stringWithFormat:Wate2Do, [player.num integerValue] , self.countdown];
        
        [[GameHandler shareInstance]nightfallTicker:AT_Daybreak];
        [[GameHandler shareInstance]daybreakTicker:title];
        
        if (0==self.countdown) {
            GameConfig * config = [GameInfoManager sharedGameInfoManager].gameConfig;
            self.countdown = config.daySpeakTime;
            [self.canSpeakArry removeObjectAtIndex:0];
            
            PlayerInfo *player = [self.canSpeakArry firstObject];
            for (int i=0; i<self.canSpeakArry.count; i++) {
                if (player.trusteeship) {
                    [[GameHandler shareInstance]trusteeshipPlayer:player];
                    [self.canSpeakArry removeObjectAtIndex:0];
                    player = [self.canSpeakArry firstObject];
                } else {
                    break;
                }
            }
        }
        
        self.countdown--;
    }
}

// 销毁计时器
-(void)_destoryCountdownTimer{
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

-(BOOL)findSpeaker:(NSInteger)num
{
    NSArray *players = [GameInfoManager sharedGameInfoManager].players;
    for (PlayerInfo *player in players) {
        if (num == [player.num integerValue]) {
            if (!player.trusteeship && !player.killed && PlayerReady_sitdown==player.ready) {
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)initSpeakers{
    
    NSArray *tmpArry = [[GameInfoManager sharedGameInfoManager].players sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerInfo *player1 = (PlayerInfo*)obj1;
        PlayerInfo *player2 = (PlayerInfo*)obj2;
        
        NSInteger num1 = [player1.num integerValue];
        NSInteger num2 = [player2.num integerValue];
        
        if (num1 > num2) {
            return NSOrderedDescending;
        }else if (num1 == num2){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    self.canSpeakArry = [[NSMutableArray alloc]init];
    for (PlayerInfo *player in tmpArry) {
        if (PlayerReady_sitdown == player.ready
            && !player.killed) {
            [self.canSpeakArry addObject:player];
        }
    }
    
    if (self.canSpeakArry.count <=0) {
        NSLog(@"no player ready, or all player deaded!");
        return NO;
    }
    
    return YES;
}
@end
