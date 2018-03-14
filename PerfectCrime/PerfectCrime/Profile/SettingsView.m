//
//  SettingsView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/21.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "SettingsView.h"

@interface SettingsView ()
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UIButton    *remidBut;
@property (nonatomic, strong) UIButton    *skinBut;

@property (nonatomic, strong) UIImageView *line_remid;
@property (nonatomic, strong) UIImageView *line_skin;

@property (nonatomic, strong) UIImageView *go_remid;
@property (nonatomic, strong) UIImageView *go_skin;

@property (nonatomic, strong) UILabel     *lb_subject_remid;
@property (nonatomic, strong) UILabel     *lb_remid;

@property (nonatomic, strong) UILabel     *lb_subject_skin;
@property (nonatomic, strong) UILabel     *lb_skin;

@end

@implementation SettingsView

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
        imv_back.backgroundColor = [UIColor whiteColor];
        imv_back.userInteractionEnabled = YES;
        imv_back;
    });
    self.remidBut = ({
        UIButton*remidBut = [UIButton buttonWithType:UIButtonTypeSystem];
        [remidBut addTarget:self action:@selector(remidButton:) forControlEvents:UIControlEventTouchUpInside];
        remidBut;
    });
    self.skinBut = ({
        UIButton*skinBut = [UIButton buttonWithType:UIButtonTypeSystem];
        [skinBut addTarget:self action:@selector(skinButton:) forControlEvents:UIControlEventTouchUpInside];
        skinBut;
    });
    
    self.line_remid = ({
        UIImageView*line_remid     = [[UIImageView alloc] init];
        line_remid.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        line_remid;
    });
    self.line_skin = ({
        UIImageView*line_skin     = [[UIImageView alloc] init];
        line_skin.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        line_skin;
    });
 
    self.go_remid = ({
        UIImageView*go_remid     = [[UIImageView alloc] init];
        go_remid.backgroundColor = [UIColor clearColor];
        go_remid.image           = [UIImage imageNamed:@"rightArrow"];
        go_remid;
    });
    self.go_skin = ({
        UIImageView*go_skin     = [[UIImageView alloc] init];
        go_skin.backgroundColor = [UIColor clearColor];
        go_skin.image           = [UIImage imageNamed:@"rightArrow"];
        go_skin;
    });
    
    self.lb_subject_remid = ({
        UILabel* lb_subject_remid = [[UILabel alloc] init];
        lb_subject_remid.font = Text_Helvetica(13.0f);
        lb_subject_remid.textColor = [UIColor blackColor];
        lb_subject_remid.backgroundColor = [UIColor clearColor];
        lb_subject_remid.textAlignment = NSTextAlignmentRight;
        lb_subject_remid.text = CustomLocalizedString(@"提醒", nil);
        lb_subject_remid;
    });
    self.lb_remid = ({
        UILabel* lb_remid = [[UILabel alloc] init];
        lb_remid.font = Text_Helvetica(12.0f);
        lb_remid.textColor = [UIColor orangeColor];
        lb_remid.backgroundColor = [UIColor clearColor];
        lb_remid.textAlignment = NSTextAlignmentRight;
        lb_remid.text = CustomLocalizedString(@"铃声", nil);;
        lb_remid;
    });
    
    self.lb_subject_skin = ({
        UILabel* lb_subject_skin = [[UILabel alloc] init];
        lb_subject_skin.font = Text_Helvetica(13.0f);
        lb_subject_skin.textColor = [UIColor blackColor];
        lb_subject_skin.backgroundColor = [UIColor clearColor];
        lb_subject_skin.textAlignment = NSTextAlignmentRight;
        lb_subject_skin.text = CustomLocalizedString(@"皮肤", nil);
        lb_subject_skin;
    });
    self.lb_skin = ({
        UILabel* lb_skin = [[UILabel alloc] init];
        lb_skin.font = Text_Helvetica(12.0f);
        lb_skin.textColor = [UIColor orangeColor];
        lb_skin.backgroundColor = [UIColor clearColor];
        lb_skin.textAlignment = NSTextAlignmentRight;
        lb_skin.text = CustomLocalizedString(@"白色", nil);;
        lb_skin;
    });
    
    [self addSubview:self.imv_back];
    
    [self.imv_back addSubview:self.line_remid];
    [self.imv_back addSubview:self.line_skin];
    
    [self.imv_back addSubview:self.remidBut];
    [self.imv_back addSubview:self.skinBut];
    
    [self.remidBut addSubview:self.go_remid];
    [self.remidBut addSubview:self.lb_subject_remid];
    [self.remidBut addSubview:self.lb_remid];
    
    [self.skinBut addSubview:self.go_skin];
    [self.skinBut addSubview:self.lb_subject_skin];
    [self.skinBut addSubview:self.lb_skin];
    
}

- (void)setAutoLayout{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.line_remid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.imv_back.centerY).with.offset(0);
        make.left.right.equalTo(ws.imv_back).with.offset(0);
        make.height.equalTo(lineH);
    }];
    [self.line_skin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_back.bottom).with.offset(-lineH);
        make.left.right.equalTo(ws.imv_back).with.offset(0);
        make.height.equalTo(lineH);
    }];
    
    [self.remidBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(ws.imv_back).with.offset(0);
        make.bottom.equalTo(ws.line_remid.top).with.offset(-1);
    }];
    [self.skinBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(ws.imv_back).with.offset(0);
        make.top.equalTo(ws.line_remid.bottom).with.offset(1);
    }];
    
    [self.lb_subject_remid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.remidBut).with.offset(15);
        make.centerY.equalTo(ws.remidBut.centerY).with.offset(0);
        make.height.equalTo(20);
    }];
    [self.go_remid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.remidBut).with.offset(-15);
        make.centerY.equalTo(ws.remidBut.centerY).with.offset(0);
        make.size.equalTo(CGSizeMake(11/2, 18/2));
    }];
    [self.lb_remid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.go_remid.left).with.offset(-5);
        make.centerY.equalTo(ws.remidBut.centerY).with.offset(0);
        make.height.equalTo(16);
    }];
    
    [self.lb_subject_skin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.skinBut).with.offset(15);
        make.centerY.equalTo(ws.skinBut.centerY).with.offset(0);
        make.height.equalTo(20);
    }];
    [self.go_skin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.skinBut).with.offset(-15);
        make.centerY.equalTo(ws.skinBut.centerY).with.offset(0);
        make.size.equalTo(CGSizeMake(11/2, 18/2));
    }];
    [self.lb_skin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.go_skin.left).with.offset(-5);
        make.centerY.equalTo(ws.skinBut.centerY).with.offset(0);
        make.height.equalTo(16);
    }];
}

#pragma mark --- delegate
-(void)remidButton:(UIButton*)but{
    if (_delegate && [_delegate respondsToSelector:@selector(OnClickRemindSetting)])
    {
        [_delegate OnClickRemindSetting];
    }
}

-(void)skinButton:(UIButton*)but{
    if (_delegate && [_delegate respondsToSelector:@selector(OnClickSkinSetting)])
    {
        [_delegate OnClickSkinSetting];
    }
}

#pragma mark --- setSettings
-(void)setRemided:(NSString*)m_str{
    self.lb_remid.text = m_str;
}

-(void)setSkin:(NSString*)m_str{
    self.lb_skin.text = m_str;
}
@end
