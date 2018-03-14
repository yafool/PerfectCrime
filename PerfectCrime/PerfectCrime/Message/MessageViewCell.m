//
//  MessageViewCell.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/2.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "MessageViewCell.h"

@interface MessageViewCell ()
@property (nonatomic, strong) UIImageView *imv_bg;

@property (nonatomic, strong) UIImageView *imv_icon;

@property (nonatomic, strong) UILabel     *lb_nick;
@property (nonatomic, strong) UILabel     *lb_message;

@property (nonatomic, strong) UILabel     *lb_time;

@property (nonatomic, strong) UIImageView *imv_lineX;

@end

@implementation MessageViewCell

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
    self.imv_icon = ({
        UIImageView*imv_icon     = [[UIImageView alloc] init];
        imv_icon.backgroundColor = [UIColor clearColor];
        imv_icon.image           = [UIImage imageNamed:@"[甲]"];
        imv_icon.clipsToBounds   = YES;
        //圆角设置
        imv_icon.layer.cornerRadius= 135/2/2;//(值越大，角就越圆)
        imv_icon.layer.masksToBounds= YES;
        //边框宽度及颜色设置
        [imv_icon.layer setBorderWidth:lineH];
        [imv_icon.layer setBorderColor:[UIColor clearColor].CGColor];  //设置边框为蓝色
        imv_icon;
    });
    
    self.lb_nick = ({
        UILabel*lb_nick            = [[UILabel alloc] init];
        lb_nick.textAlignment      = NSTextAlignmentLeft;
        lb_nick.backgroundColor    = [UIColor clearColor];
        lb_nick.textColor          = [UIColor blackColor];
        lb_nick.font               = Text_Helvetica(14);
        lb_nick;
    });
    self.lb_message = ({
        UILabel*lb_message             = [[UILabel alloc] init];
        lb_message.font                = Text_Helvetica(12);
        lb_message.backgroundColor     = [UIColor clearColor];
        lb_message.textAlignment        = NSTextAlignmentRight;
        lb_message.textColor          = [UIColor grayColor];
        lb_message;
    });
    
    self.lb_time = ({
        UILabel*lb_time             = [[UILabel alloc] init];
        lb_time.font                = Text_Helvetica(12);
        lb_time.backgroundColor     = [UIColor clearColor];
        lb_time.textAlignment        = NSTextAlignmentRight;
        lb_time.textColor          = [UIColor orangeColor];
        lb_time;
    });
    
    self.imv_lineX = ({
        UIImageView*imv_LineX     = [[UIImageView alloc] init];
        imv_LineX.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_LineX;
    });
    [self.contentView addSubview:self.imv_bg];
    [self.imv_bg addSubview:self.imv_icon];
    [self.imv_bg addSubview:self.lb_nick];
    [self.imv_bg addSubview:self.lb_message];
    [self.imv_bg addSubview:self.lb_time];
    [self.imv_bg addSubview:self.imv_lineX];
}

- (void)_autolayouUI{
    WS(ws);
    [self.imv_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.imv_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_bg).with.offset(8);
        make.centerY.equalTo(ws.imv_bg.centerY).with.offset(0);
        make.height.equalTo(32);
    }];
    [self.lb_nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_icon.right).with.offset(4);
        make.bottom.equalTo(self.imv_bg.centerY).with.offset(-2);
        make.height.equalTo(16);
    }];
    [self.lb_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_icon.right).with.offset(4);
        make.top.equalTo(self.imv_bg.centerY).with.offset(2);
        make.height.equalTo(16);
    }];
    
    [self.lb_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_bg).with.offset(-8);
        make.bottom.equalTo(self.imv_bg.centerY).with.offset(-2);
        make.height.equalTo(16);
    }];
    
    [self.imv_lineX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws.imv_bg).with.offset(0);
        make.height.equalTo(lineH);
    }];
}

-(void)showUI:(NSDictionary*)m_dict{
    
    NSString *messageIcon = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"messageIcon"]];
    self.imv_icon.image           = [UIImage imageNamed:messageIcon];
    
    NSString * userName = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"userName"]];
    self.lb_nick.text = userName;
    
    NSString * message = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"message"]];
    self.lb_message.text = message;
    
    NSString * time = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"timeStamp"]];
    self.lb_time.text = time;
}


@end
