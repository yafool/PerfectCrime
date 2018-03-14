//
//  VoteViewCell.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/11/7.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "VoteViewCell.h"
#import "UIImageView+SDWebImage.h"
#import "VoteBoxView.h"

#define Head_Size       (VoterSize/2)
#define Label_High      (VoterSize/4/3*2)

@interface VoteViewCell ()
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UILabel *lb_nick;
@property (nonatomic, strong) UIImageView *imv_head;
@property (nonatomic, strong) UIImageView *imv_frame;
@property (nonatomic, strong) UILabel *lb_votes;
@end

@implementation VoteViewCell

@synthesize player;
@synthesize votes;

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
    self.lb_nick = ({
        UILabel*lb_nick            = [[UILabel alloc] init];
        lb_nick.textAlignment      = NSTextAlignmentCenter;
        lb_nick.backgroundColor    = [UIColor clearColor];
        lb_nick.textColor          = [UIColor blackColor];
        lb_nick.font               = Text_Helvetica(Label_High);
        lb_nick;
    });
    self.imv_head = ({
        UIImageView*imv_head     = [[UIImageView alloc] init];
        imv_head.backgroundColor = [UIColor clearColor];
        //圆角
        imv_head.layer.cornerRadius = (Head_Size/2); // 圆角的弧度
        imv_head.layer.masksToBounds = YES;
        imv_head;
    });
    self.imv_frame = ({
        UIImageView*imv_frame     = [[UIImageView alloc] init];
        imv_frame.backgroundColor = [UIColor clearColor];
        //圆角
        imv_frame.layer.cornerRadius = 24; // 圆角的弧度
        imv_frame.layer.masksToBounds = YES;
        imv_frame;
    });
    self.lb_votes = ({
        UILabel*lb            = [[UILabel alloc] init];
        lb.textAlignment      = NSTextAlignmentCenter;
        lb.backgroundColor    = [UIColor clearColor];
        lb.textColor          = [UIColor blackColor];
        lb.font               = Text_Helvetica(Label_High);
        lb;
    });
    
    
    [self.contentView addSubview:self.imv_back];
    [self.imv_back addSubview:self.lb_nick];
    [self.imv_back addSubview:self.imv_head];
    [self.imv_head addSubview:self.imv_frame];
    [self.imv_back addSubview:self.lb_votes];
}

- (void)_autolayouUI{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.imv_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.centerY.equalTo(ws.imv_back.centerY).with.offset(0);
        make.size.equalTo(CGSizeMake(Head_Size, Head_Size));
    }];
    [self.imv_frame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.imv_head).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.lb_nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.bottom.equalTo(ws.imv_head.top).with.offset(-1);
        make.height.equalTo(Label_High);
    }];
    
    [self.lb_votes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.top.equalTo(ws.imv_head.bottom).with.offset(1);
        make.height.equalTo(Label_High);
    }];
}

-(void)initVoterView:(PlayerInfo*)m_info{
    player = m_info;
    votes = 0;
    
    self.lb_nick.text = player.nickName;
    self.lb_votes.text = [NSString stringWithFormat:@"%ld", votes];
    
    [self.imv_head downloadImage:player.picUrl placeholder:@"defaultHead"];
    self.imv_frame.image = [UIImage imageNamed:player.picFrame];
}
// player info 有变化时刷新 view
-(void)onVoteChange{
    votes++;
    self.lb_votes.text = [NSString stringWithFormat:@"%ld", votes];
}
@end
