//
//  LeftMenuTopView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/13.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "LeftMenuTopView.h"
#import "DataStructure.h"
#import "GameInfoManager.h"


@interface LeftMenuTopView ()

@property (nonatomic, strong) UIImageView   *imv_back;
@property (nonatomic, strong) UIButton      *btn_seatingCategory;
@property (nonatomic, strong) UIButton      *btn_seatingOption;

@property (nonatomic, strong) UILabel       *lb_countDown;
@property (nonatomic, strong) NSTimer       *countdownTimer;
@property (nonatomic, assign) NSInteger     countdown;
@end

@implementation LeftMenuTopView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setAllView];
        [self setAutoLayout];
    }
    return self;
}

-(void)setAllView{
    
    self.imv_back = ({
        UIImageView*imv_back     = [[UIImageView alloc] init];
        imv_back.backgroundColor = [UIColor clearColor];
        imv_back.userInteractionEnabled = YES;
        imv_back;
    });
    self.btn_seatingCategory = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        //阴影
        btn.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        btn.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); //[水平偏移, 垂直偏移]
        btn.layer.shadowOpacity = 1.0f; //0.0 ~ 1.0 的值
        btn.layer.shadowRadius = 10.0f; // 阴影发散的程度
        
        [btn setTitle:PlayersSitDown forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(onClickCategory) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.btn_seatingOption = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        //阴影
        btn.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        btn.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); //[水平偏移, 垂直偏移]
        btn.layer.shadowOpacity = 1.0f; //0.0 ~ 1.0 的值
        btn.layer.shadowRadius = 10.0f; // 阴影发散的程度
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(onClickOption) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    self.lb_countDown = ({
        UILabel* lb_countDown = [[UILabel alloc] init];
        lb_countDown.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        //阴影
        lb_countDown.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        lb_countDown.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); //[水平偏移, 垂直偏移]
        lb_countDown.layer.shadowOpacity = 1.0f; //0.0 ~ 1.0 的值
        lb_countDown.layer.shadowRadius = 10.0f; // 阴影发散的程度
        
        lb_countDown.font = [UIFont systemFontOfSize:14];;
        lb_countDown.textColor = [UIColor lightGrayColor];
        lb_countDown.textAlignment = NSTextAlignmentCenter;
        lb_countDown;
    });
    
    [self addSubview:self.imv_back];
    
    [self.imv_back addSubview:self.btn_seatingCategory];
    [self.imv_back addSubview:self.btn_seatingOption];
    [self.imv_back addSubview:self.lb_countDown];
    
}

- (void)setAutoLayout{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.btn_seatingCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws.imv_back).with.offset(4);
        make.size.equalTo(CGSizeMake((self.frame.size.width-40)/3, 32));
    }];
    
    [self.btn_seatingOption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_back).with.offset(4);
        make.right.equalTo(ws.imv_back).with.offset(-4);
        make.size.equalTo(CGSizeMake((self.frame.size.width-40)/3, 32));
    }];
    
    [self.lb_countDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_back).with.offset(4);
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.size.equalTo(CGSizeMake((self.frame.size.width-40)/3, 32));
    }];
}

#pragma mark --- delegate
-(void)onClickCategory{
    NSString *curCategory = self.btn_seatingCategory.titleLabel.text;
    if ([PlayersSitDown isEqualToString:curCategory]) {// 当前展示入席玩家
        [self.btn_seatingCategory setTitle:PlayersInRoom forState:UIControlStateNormal];
        // TO-DO:切换到 展示旁观玩家
        if (_delegate && [_delegate respondsToSelector:@selector(OnShowSitDownList)])
        {
            [_delegate OnShowSitDownList];
        }
    } else if ([PlayersInRoom isEqualToString:curCategory]) {// 当前展示旁观玩家
        [self.btn_seatingCategory setTitle:PlayersSitDown forState:UIControlStateNormal];
        // TO-DO:切换到 展示入席玩家
        if (_delegate && [_delegate respondsToSelector:@selector(OnShowAllPlayerList)])
        {
            [_delegate OnShowAllPlayerList];
        }
    }
}

-(void)onClickOption{
    // 开始游戏、入席、离席
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    RoomInfo * roomInfo = [GameInfoManager sharedGameInfoManager].roomInfo;
    NSString *hoster = roomInfo.hoster;
    if ([userId isEqualToString:hoster]) {//开始游戏
        if (_delegate && [_delegate respondsToSelector:@selector(OnOptionPlaying)])
        {
            [_delegate OnOptionPlaying];
        }
    } else {
        NSString *curOption = self.btn_seatingOption.titleLabel.text;
        if ([OptionSit isEqualToString:curOption]) {// 当前玩家尚未入席
            
            // TO-DO:切换到 展示旁观玩家
            if (_delegate && [_delegate respondsToSelector:@selector(OnOptionSit)])
            {
                [_delegate OnOptionSit];
            }
        } else if ([OptionLeave isEqualToString:curOption]) {// 当前玩家已经入席
            
            // TO-DO:切换到 展示入席玩家
            if (_delegate && [_delegate respondsToSelector:@selector(OnOptionLeave)])
            {
                [_delegate OnOptionLeave];
            }
        }
    }
}

-(void)changeToPlayers{
    [self.btn_seatingCategory setTitle:PlayersInRoom forState:UIControlStateNormal];
}

-(void)changeForUserSit{
    RoomInfo *roomInfo = [GameInfoManager sharedGameInfoManager].roomInfo;
    NSString *hoster = roomInfo.hoster;
    PlayerInfo *playerSelf = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    
    if ([playerSelf.userId isEqualToString:hoster]) {
        [self.btn_seatingOption setTitle:OptionPlay forState:UIControlStateNormal];
        [self.btn_seatingOption setEnabled:(ReadyForGame_beReady==roomInfo.startGame)?YES:NO];
    } else if (PlayerReady_outsider == playerSelf.ready) {
        [self.btn_seatingOption setTitle:OptionSit forState:UIControlStateNormal];
    } else if(PlayerReady_sitdown == playerSelf.ready) {
        [self.btn_seatingOption setTitle:OptionLeave forState:UIControlStateNormal];
    }
}

-(void)changeForCountdown:(NSString*)title{
    [self.lb_countDown setText:title];
}

#pragma mark --- init
-(void)initMyView:(NSDictionary*)m_dict{
    self.btn_seatingCategory.titleLabel.text = PlayersSitDown;
    self.lb_countDown.text = GameReday;
    
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    RoomInfo * roomInfo = [GameInfoManager sharedGameInfoManager].roomInfo;
    NSString *hoster = roomInfo.hoster;
    if ([userId isEqualToString:hoster]) {//开始游戏
        [self.btn_seatingOption setEnabled:NO];
        [self.btn_seatingOption setTitle:OptionPlay forState:UIControlStateDisabled];
    } else {
        // self.btn_seatingOption.titleLabel.text = OptionSit;
        [self.btn_seatingOption setTitle:OptionSit forState:UIControlStateNormal];
    }
    
}

@end
