//
//  PlayerViewCell.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/13.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayerViewCell.h"
#import "UIImageView+SDWebImage.h"
#import "GameInfoManager.h"

#define Player_Sitdown  @"ffeedd"

@interface PlayerViewCell ()
{
    PlayerInfo *player;
}
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UIImageView *imv_head;
@property (nonatomic, strong) UIImageView *imv_frame;
@property (nonatomic, strong) UIImageView *imv_role;
@property (nonatomic, strong) UILabel *lb_num;
@property (nonatomic, strong) UILabel *lb_nick;

@end

@implementation PlayerViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self _setup];
        [self _autolayouUI];
        
    }
    return self;
}

- (void)_setup{
    self.imv_back = ({
        UIImageView*imv_back     = [[UIImageView alloc] init];
        imv_back.userInteractionEnabled = YES;
        //圆角
        imv_back.layer.cornerRadius = 2; // 圆角的弧度
        imv_back.layer.masksToBounds = YES;
        //边框
        imv_back.layer.borderWidth = 1;
        imv_back.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        imv_back;
    });
    self.imv_head = ({
        UIImageView*imv_head     = [[UIImageView alloc] init];
        imv_head.backgroundColor = [UIColor clearColor];
        //圆角
        imv_head.layer.cornerRadius = 25; // 圆角的弧度
        imv_head.layer.masksToBounds = YES;
        imv_head;
    });
    self.imv_frame = ({
        UIImageView*imv_frame     = [[UIImageView alloc] init];
        imv_frame.backgroundColor = [UIColor clearColor];
        //圆角
        imv_frame.layer.cornerRadius = 25; // 圆角的弧度
        imv_frame.layer.masksToBounds = YES;
        imv_frame;
    });
    self.imv_role = ({
        UIImageView*imv_mark     = [[UIImageView alloc] init];
        imv_mark.backgroundColor = [UIColor clearColor];
        imv_mark;
    });
    self.lb_num = ({
        UILabel*lb_order            = [[UILabel alloc] init];
        lb_order.textAlignment      = NSTextAlignmentCenter;
        lb_order.backgroundColor    = [UIColor clearColor];
        lb_order.textColor          = [UIColor blackColor];
        lb_order.font               = Text_Helvetica(15);
        lb_order;
    });
    self.lb_nick = ({
        UILabel*lb_nick            = [[UILabel alloc] init];
        lb_nick.textAlignment      = NSTextAlignmentCenter;
        lb_nick.backgroundColor    = [UIColor clearColor];
        lb_nick.textColor          = [UIColor blackColor];
        lb_nick.font               = Text_Helvetica(13);
        lb_nick;
    });
    
    [self.contentView addSubview:self.imv_back];
    [self.imv_back addSubview:self.imv_head];
    [self.imv_head addSubview:self.imv_frame];
    [self.imv_back addSubview:self.imv_role];
    [self.imv_back addSubview:self.lb_num];
    [self.imv_back addSubview:self.lb_nick];
    
}

- (void)_autolayouUI{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.imv_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.centerY.equalTo(ws.imv_back.centerY).with.offset(0);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    [self.imv_frame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.imv_head).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.imv_role mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imv_back).with.offset(4);
        make.right.equalTo(self.imv_back).with.offset(-4);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    [self.lb_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_back).with.offset(4);
        make.top.equalTo(ws.imv_back).with.offset(4);
        make.height.equalTo(15);
    }];
    [self.lb_nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.bottom.equalTo(ws.imv_back).with.offset(-8);
        make.height.equalTo(13);
    }];
}

#pragma mark -------- 实现自定义 public 函数
-(void)initMyView:(PlayerInfo*)m_info{
    player = m_info;
    [self _updateViewCell];
}

-(void)_updateViewCell{
    [self.imv_head downloadImage:player.picUrl placeholder:@"defaultHead"];
    // 相框
    if (player.killed) {
        self.imv_frame.image = [UIImage imageNamed:@"出局"];
    } else {
        self.imv_frame.image = [UIImage imageNamed:player.picFrame];
    }
    
    self.lb_num.text = player.num;
    self.lb_nick.text = player.nickName;
    
    switch (player.role) {
        case PlayerRole_civilian:
            self.imv_role.image = [UIImage imageNamed:@"CivilianIcon"];
            break;
        case PlayerRole_police:
            self.imv_role.image = [UIImage imageNamed:@"PoliceIcon"];
            break;
        case PlayerRole_terrorist:
            self.imv_role.image = [UIImage imageNamed:@"TerroristIcon"];
            break;
        default:
            break;
    }
    
    if ([self _isBrightIdentity]) {
        // 亮明身份
        self.imv_role.hidden = NO;
    } else {
        // 隐藏身份
        self.imv_role.hidden = YES;
    }
    // 通过背景色标识是否入座
    if (PlayerReady_sitdown == player.ready) {
        self.imv_back.backgroundColor = [CustomColorRGB colorWithHexString:Player_Sitdown];
    } else {
        self.imv_back.backgroundColor = [UIColor clearColor];
    }
    // 通过边框显示自己在哪儿
    NSString *curUserId = [SettingsManager sharedSettingsManager].userId;
    if ([curUserId isEqualToString:player.userId]) {
        //设置边框线的颜色
        [self.imv_back.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    } else {
        [self.imv_back.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    
}

-(BOOL)_isBrightIdentity{
    if (ReadyForGame_notReady == [GameInfoManager sharedGameInfoManager].roomInfo.startGame) {
        return NO;
    }
    
    PlayerInfo *mySelf = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if ([mySelf.userId isEqualToString:player.userId]) {
        return YES;
    }
    
    if (PlayerRole_civilian != player.role && mySelf.role == player.role) {
        return YES;
    }
    
    return NO;
}

-(PlayerInfo*)getPlayerInfo{
    return player;
}
@end
