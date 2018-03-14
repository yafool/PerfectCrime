//
//  MainTopView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/17.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "MainTopView.h"
#import "VoteBoxView.h"
#import "GameInfoManager.h"

@interface MainTopView ()

@property (nonatomic, strong) UIImageView *imv_back;

@property (nonatomic, strong) UIButton          *btn_trust;
@property (nonatomic, strong) UILabel           *lb_progress;
@property (nonatomic, strong) UILabel           *lb_countDown;

@end

@implementation MainTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setAllView];
        [self _setAutoLayout];
        [self _initTitles];
    }
    return self;
}

-(void)_setAllView{
    
    self.imv_back = ({
        UIImageView*imv_back     = [[UIImageView alloc] init];
        imv_back.backgroundColor = [UIColor clearColor];
        imv_back.userInteractionEnabled = YES;
        imv_back;
    });
    self.btn_trust = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        //阴影
        btn.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        btn.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); //[水平偏移, 垂直偏移]
        btn.layer.shadowOpacity = 1.0f; //0.0 ~ 1.0 的值
        btn.layer.shadowRadius = 10.0f; // 阴影发散的程度
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(_onClickWithButton:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    self.lb_progress = ({
        UILabel* lb = [[UILabel alloc] init];
        lb.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        //阴影
        lb.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        lb.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); //[水平偏移, 垂直偏移]
        lb.layer.shadowOpacity = 1.0f; //0.0 ~ 1.0 的值
        lb.layer.shadowRadius = 10.0f; // 阴影发散的程度
        
        lb.font = [UIFont systemFontOfSize:14];
        lb.textColor = [UIColor lightGrayColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb;
    });
    
    self.lb_countDown = ({
        UILabel* lb_countDown = [[UILabel alloc] init];
        lb_countDown.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        //阴影
        lb_countDown.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        lb_countDown.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); //[水平偏移, 垂直偏移]
        lb_countDown.layer.shadowOpacity = 1.0f; //0.0 ~ 1.0 的值
        lb_countDown.layer.shadowRadius = 10.0f; // 阴影发散的程度
        
        lb_countDown.font = [UIFont systemFontOfSize:14];
        lb_countDown.textColor = [UIColor lightGrayColor];
        lb_countDown.textAlignment = NSTextAlignmentCenter;
        lb_countDown;
    });
    
    
    
    [self addSubview:self.imv_back];
    
    [self.imv_back addSubview:self.btn_trust];
    [self.imv_back addSubview:self.lb_progress];
    [self.imv_back addSubview:self.lb_countDown];
    
}

- (void)_setAutoLayout{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.btn_trust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws.imv_back).with.offset(4);
        make.size.equalTo(CGSizeMake(48, 32));
    }];
    
    [self.lb_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_back).with.offset(4);
        make.right.equalTo(ws.imv_back).with.offset(-4);
        make.size.equalTo(CGSizeMake((self.frame.size.width-80)/2, 32));
    }];
    
    [self.lb_countDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_back).with.offset(4);
        make.left.equalTo(ws.btn_trust.right).with.offset(10);
        make.right.equalTo(ws.lb_progress.left).with.offset(-10);
        make.height.equalTo(32);
    }];
    
}

#pragma mark --- delegate

-(void)_onClickWithButton:(UIButton*)but{
    NSString *title = but.titleLabel.text;
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    for (PlayerInfo *player in [GameInfoManager sharedGameInfoManager].players) {
        if ([userId isEqualToString:player.userId]) {
            if ([OptionTrustDone isEqualToString:title]) {//目的：开始托管
                [but setTitle:OptionTrustCancel forState:UIControlStateNormal];
                player.trusteeship = YES;
            } else if([OptionTrustCancel isEqualToString:title]) {//目的：撤销托管
                [but setTitle:OptionTrustDone forState:UIControlStateNormal];
                player.trusteeship = NO;
            }
            
            break;
        }
    }
    
}

-(void)_initTitles{
    PlayerInfo *player = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if (player.trusteeship) {
        [self.btn_trust setTitle:OptionTrustCancel forState:UIControlStateNormal];
    } else {
        [self.btn_trust setTitle:OptionTrustDone forState:UIControlStateNormal];
    }
    
    [self setProcessTitle];
    
    self.lb_countDown.text = @"天亮后依次发言";
}

//显示当前发言者的倒计时
-(void)setCountdownTitle:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lb_countDown setText:title];
    });
}
//显示当前进行到第几天
-(void)setProcessTitle{
    dispatch_async(dispatch_get_main_queue(), ^{
        GameProgress *gameProgress = [GameInfoManager sharedGameInfoManager].gameProgress;
        if (DayState_dawn == gameProgress.dayState) {// 白天
            self.lb_progress.text = [NSString stringWithFormat:@"第%ld天:白天", gameProgress.days];
        } else if(PlayerReady_dark == gameProgress.dayState){// 晚上
            self.lb_progress.text = [NSString stringWithFormat:@"第%ld天:晚上", gameProgress.days];
        }
    });
}
@end
