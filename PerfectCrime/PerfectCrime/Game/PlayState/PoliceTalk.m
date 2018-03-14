//
//  PoliceTalk.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/12/3.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PoliceTalk.h"
#import "PoliceCheck.h"

static NSString *Wate2Do          =@"验谁";

@interface PoliceTalk ()
//倒计时
@property (nonatomic, strong) NSTimer       *countdownTimer;
@property (nonatomic, assign) NSInteger     countdown;

@end

@implementation PoliceTalk

-(void)OnPlaying{
    PlayerInfo * myself = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    GameConfig * config = [GameInfoManager sharedGameInfoManager].gameConfig;
    self.countdown = config.policeNightSpeakTime;
    
    [[GameHandler shareInstance]policeTalk];

    [self _GCD_Countdown:(int)self.countdown];
}

-(void)_GCD_Countdown:(int)time{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        NSString *title = [NSString stringWithFormat:@"%@:%d", Wate2Do,timeout];
        
        [[GameHandler shareInstance]nightfallTicker:title];
        [[GameHandler shareInstance]daybreakTicker:AT_Nightfall];
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            [self GoNext:[PoliceCheck new]];
        }else {
            timeout--;
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
    NSString *title = [NSString stringWithFormat:@"%@:%ld", Wate2Do,self.countdown];
    
    [[GameHandler shareInstance]nightfallTicker:title];
    [[GameHandler shareInstance]daybreakTicker:AT_Nightfall];
    
    if (0==self.countdown) {
        [self _destoryCountdownTimer];
        [self GoNext:[PoliceCheck new]];
    }
    
    self.countdown--;
}

// 销毁计时器
-(void)_destoryCountdownTimer{
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

@end
