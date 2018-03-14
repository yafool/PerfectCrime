//
//  RoomCollectionViewCell.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/19.
//  Copyright © 2017年 com.agency. All rights reserved.
//  房间Cell: 显示房间名称、房间等级(新手、高手)、房速（普通、快速）、当前人数/容纳上限人数、有无密码、天数进度
//

#import "RoomCollectionViewCell.h"
#import "CreateHomeView.h"


@interface RoomCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UIImageView *imv_top;
@property (nonatomic, strong) UIImageView *imv_passwd;
@property (nonatomic, strong) UILabel *lb_title;
@property (nonatomic, strong) UILabel *lb_name;
@property (nonatomic, strong) UILabel *lb_player;
@end

@implementation RoomCollectionViewCell

@synthesize  roomDict;

@synthesize  roomId;
@synthesize  passwd;
@synthesize  grade;
@synthesize  roomName;
@synthesize  speed;
@synthesize  userId;
@synthesize  limit;

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
        imv_back.backgroundColor = [UIColor clearColor];
        [imv_back.layer setMasksToBounds:YES];
        [imv_back.layer setCornerRadius:5.0];
        [imv_back.layer setBorderWidth:1];
        [imv_back.layer setBorderColor:[[UIColor grayColor] CGColor]];
        imv_back.userInteractionEnabled = YES;
        imv_back;
    });
    self.imv_top = ({
        UIImageView*imv_top     = [[UIImageView alloc] init];
        imv_top.backgroundColor = [UIColor blueColor];
        imv_top;
    });
    self.imv_passwd = ({
        UIImageView*imv_passwd     = [[UIImageView alloc] init];
        imv_passwd.backgroundColor = [UIColor clearColor];
        imv_passwd;
    });
    self.lb_title = ({
        UILabel*lb_name            = [[UILabel alloc] init];
        lb_name.textAlignment      = NSTextAlignmentCenter;
        lb_name.backgroundColor    = [UIColor clearColor];
        lb_name.textColor          = [UIColor whiteColor];
        lb_name.font               = Text_Helvetica(12);
        lb_name;
    });
    self.lb_name = ({
        UILabel*lb_name            = [[UILabel alloc] init];
        lb_name.textAlignment      = NSTextAlignmentCenter;
        lb_name.backgroundColor    = [UIColor clearColor];
        lb_name.textColor          = [UIColor blackColor];
        lb_name.font               = Text_Helvetica(13);
        lb_name;
    });
    self.lb_player = ({
        UILabel*lb_name            = [[UILabel alloc] init];
        lb_name.textAlignment      = NSTextAlignmentCenter;
        lb_name.backgroundColor    = [UIColor clearColor];
        lb_name.textColor          = [UIColor orangeColor];
        lb_name.font               = Text_Helvetica(12);
        lb_name;
    });
    
    [self.contentView addSubview:self.imv_back];
    [self.imv_back addSubview:self.imv_top];
    [self.imv_back addSubview:self.imv_passwd];
    [self.imv_back addSubview:self.lb_title];
    [self.imv_back addSubview:self.lb_name];
    [self.imv_back addSubview:self.lb_player];

}

- (void)_autolayouUI{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.imv_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_back).with.offset(0);
        make.left.equalTo(ws.imv_back).with.offset(0);
        make.right.equalTo(ws.imv_back).with.offset(0);
        make.height.equalTo(24);
    }];
    [self.lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imv_top.centerX).with.offset(0);
        make.centerY.equalTo(self.imv_top.centerY).with.offset(0);
    }];
    [self.lb_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.centerY.equalTo(ws.imv_back.centerY).with.offset(0);
    }];
    [self.lb_player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_back).with.offset(4);
        make.bottom.equalTo(ws.imv_back.bottom).with.offset(-2);
    }];
    [self.imv_passwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.imv_back.right).with.offset(-4);
        make.bottom.equalTo(ws.imv_back.bottom).with.offset(-2);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
}


-(void)initCellwithDictionary:(NSDictionary*)m_dict{
    roomDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    
    roomId = [roomDict valueForKey:@"roomId"];
    passwd = [roomDict valueForKey:@"passwd"];
    grade = [[CreateHomeView appearances]gradeKeyWithValue:[roomDict valueForKey:@"grade"]];
    roomName = [roomDict valueForKey:@"roomName"];
    speed = [[CreateHomeView appearances]speedKeyWithValue:[roomDict valueForKey:@"speed"]];
    userId = [roomDict valueForKey:@"userId"];
    if ([roomDict  objectForKey: @"limit"] ) {
        limit = [roomDict valueForKey:@"limit"];
    }else{
        limit = [roomDict valueForKey:@"userLimit"];
    }
    
    // title = 房间级别 ／ 房间速度
    ;
    self.lb_title.text = [NSString stringWithFormat:@"%@ / %@", grade, speed];
    // 房间名称
    self.lb_name.text = roomName;
    // 当前人数/容纳上限人数
    self.lb_player.text = [NSString stringWithFormat:@"%@人房间", limit];
    
    // 是否加密房间
    if([CustomStringFunc isBlankString:passwd]){
        self.imv_passwd.image = nil;
    } else {
        self.imv_passwd.image = [UIImage imageNamed:@"passWord"];
    }

}
@end
