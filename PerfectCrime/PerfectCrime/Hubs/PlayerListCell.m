//
//  PlayerListCell.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/1.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayerListCell.h"

@interface PlayerListCell ()
@property (nonatomic, strong) UIImageView *imv_bg;

@property (nonatomic, strong) UIImageView *imv_head;

@property (nonatomic, strong) UILabel     *lb_nick;
@property (nonatomic, strong) UILabel     *lb_addr;

@property (nonatomic, strong) UILabel     *lb_value;
@property (nonatomic, strong) UIButton    *btn_add;

@property (nonatomic, strong) UIImageView *imv_lineX;

#pragma mark 榜单玩家信息
@property (nonatomic,copy) NSMutableDictionary *dic_playerInfo;

@end

@implementation PlayerListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _setup];
        [self _autolayouUI];
        
    }
    return self;
}

- (void)_setup{
    
    self.imv_bg = ({
        UIImageView *imv_bg     = [[UIImageView alloc] init];
        imv_bg.backgroundColor = [UIColor whiteColor];
        imv_bg.userInteractionEnabled = YES;
        imv_bg;
    });
    self.imv_head = ({
        UIImageView*imv_head     = [[UIImageView alloc] init];
        imv_head.backgroundColor = [UIColor clearColor];
        imv_head.image           = [UIImage imageNamed:@"[甲]"];
        imv_head.clipsToBounds   = YES;
        //圆角设置
        imv_head.layer.cornerRadius= 135/2/2;//(值越大，角就越圆)
        imv_head.layer.masksToBounds= YES;
        //边框宽度及颜色设置
        [imv_head.layer setBorderWidth:lineH];
        [imv_head.layer setBorderColor:[UIColor clearColor].CGColor];  //设置边框为蓝色
        imv_head;
    });
    
    self.lb_nick = ({
        UILabel*lb_nick            = [[UILabel alloc] init];
        lb_nick.textAlignment      = NSTextAlignmentLeft;
        lb_nick.backgroundColor    = [UIColor clearColor];
        lb_nick.textColor          = [UIColor blackColor];
        lb_nick.font               = Text_Helvetica(14);
        lb_nick;
    });
    self.lb_addr = ({
        UILabel*lb_addr             = [[UILabel alloc] init];
        lb_addr.font                = Text_Helvetica(12);
        lb_addr.backgroundColor     = [UIColor clearColor];
        lb_addr.textAlignment        = NSTextAlignmentRight;
        lb_addr.textColor          = [UIColor grayColor];
        lb_addr;
    });
    
    self.lb_value = ({
        UILabel*lb_value             = [[UILabel alloc] init];
        lb_value.font                = Text_Helvetica(12);
        lb_value.backgroundColor     = [UIColor clearColor];
        lb_value.textAlignment        = NSTextAlignmentRight;
        lb_value.textColor          = [UIColor orangeColor];
        lb_value;
    });
    self.btn_add = ({
        UIButton*btn_add             = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_add.backgroundColor      = [UIColor orangeColor];
        btn_add.layer.cornerRadius = 3.0;
        btn_add.layer.borderWidth = 1.0;
        btn_add.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(),(CGFloat[]){ 0, 0, 0, 1 });
        [btn_add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_add setTitle:CustomLocalizedString(@"加好友", nil) forState:UIControlStateNormal];
        btn_add.titleLabel.font = Text_Helvetica(12);
        btn_add.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn_add addTarget:self action:@selector(addBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn_add;
        
    });
    
    self.imv_lineX = ({
        UIImageView*imv_LineX     = [[UIImageView alloc] init];
        imv_LineX.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_LineX;
    });
    [self.contentView addSubview:self.imv_bg];
    [self.imv_bg addSubview:self.imv_head];
    [self.imv_bg addSubview:self.lb_nick];
    [self.imv_bg addSubview:self.lb_addr];
    [self.imv_bg addSubview:self.lb_value];
    [self.imv_bg addSubview:self.btn_add];
    [self.imv_bg addSubview:self.imv_lineX];
}

- (void)_autolayouUI{
    WS(ws);
    [self.imv_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.imv_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_bg).with.offset(8);
        make.centerY.equalTo(ws.imv_bg.centerY).with.offset(0);
        make.size.equalTo(CGSizeMake(40,40));
    }];
    [self.lb_nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_head.right).with.offset(4);
        make.bottom.equalTo(self.imv_bg.centerY).with.offset(-2);
        make.height.equalTo(16);
    }];
    [self.lb_addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_head.right).with.offset(4);
        make.top.equalTo(self.imv_bg.centerY).with.offset(2);
        make.height.equalTo(16);
    }];
    
    [self.lb_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_bg).with.offset(-8);
        make.bottom.equalTo(self.imv_bg.centerY).with.offset(-2);
        make.height.equalTo(16);
    }];
    [self.btn_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_bg).with.offset(-8);
        make.top.equalTo(self.imv_bg.centerY).with.offset(2);
        make.height.equalTo(16);
    }];
    
    [self.imv_lineX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws.imv_bg).with.offset(0);
        make.height.equalTo(lineH);
    }];
}

-(void)showUI:(NSDictionary*)m_dict{
    self.dic_playerInfo = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    
    NSString *headIcon = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"headIcon"]];
    self.imv_head.image           = [UIImage imageNamed:headIcon];
    
    NSString * userName = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"userName"]];
    self.lb_nick.text = userName;
    
    NSString * userAddr = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"userAddr"]];
    self.lb_addr.text = userAddr;
    
    NSString * value = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"rankingValue"]];
    self.lb_value.text = value;
}

- (void)addBtnOnClick:(UIButton*)but{
    if (_delegate && [_delegate respondsToSelector:@selector(OnAddClickWithPlayer:)])
    {
        [_delegate OnAddClickWithPlayer:self.dic_playerInfo];
    }
}
@end
