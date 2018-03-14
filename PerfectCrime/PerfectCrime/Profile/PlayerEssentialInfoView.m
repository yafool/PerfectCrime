//
//  PlayerEssentialInfoView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/21.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayerEssentialInfoView.h"
#import "UIImageView+SDWebImage.h"

@interface PlayerEssentialInfoView ()
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UIImageView *imv_icon;
@property (nonatomic, strong) UIImageView *imv_frame;

@property (nonatomic, strong) UILabel     *lb_user;
@property (nonatomic, strong) UIImageView *imv_jt;

@property (nonatomic, strong) UIButton    *userBut;
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *centerView;
@property (nonatomic, strong) UIImageView *rightView;

@property (nonatomic, strong) UILabel     *lb_subject_sex;
@property (nonatomic, strong) UILabel     *lb_sex;

@property (nonatomic, strong) UILabel     *lb_subject_age;
@property (nonatomic, strong) UILabel     *lb_age;

@property (nonatomic, strong) UILabel     *lb_subject_addr;
@property (nonatomic, strong) UILabel     *lb_addr;

@property (nonatomic, strong) UIImageView *imv_lineY1;
@property (nonatomic, strong) UIImageView *imv_lineY2;
@property (nonatomic, strong) UIImageView *imv_lineX;

@end

@implementation PlayerEssentialInfoView

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
    self.userBut = ({
        UIButton*userBut = [UIButton buttonWithType:UIButtonTypeSystem];
        [userBut addTarget:self action:@selector(userButton:) forControlEvents:UIControlEventTouchUpInside];
        userBut;
    });
    self.imv_icon = ({
        UIImageView*imv_icon     = [[UIImageView alloc] init];
        imv_icon.backgroundColor = [UIColor clearColor];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [imv_icon downloadImage:[[SettingsManager sharedSettingsManager]picUrl] placeholder:@"defaultHead"];
        });
        imv_icon.clipsToBounds   = YES;
        //圆角设置
        imv_icon.layer.cornerRadius= 135/2/2;//(值越大，角就越圆)
        imv_icon.layer.masksToBounds= YES;
        //边框宽度及颜色设置
        [imv_icon.layer setBorderWidth:lineH];
        [imv_icon.layer setBorderColor:[UIColor clearColor].CGColor];  //设置边框为蓝色
        imv_icon;
    });
    self.imv_frame = ({
        UIImageView*imv_frame     = [[UIImageView alloc] init];
        imv_frame.backgroundColor = [UIColor clearColor];
        imv_frame.clipsToBounds   = YES;
        //圆角设置
        imv_frame.layer.cornerRadius= 135/2/2;//(值越大，角就越圆)
        imv_frame.layer.masksToBounds= YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *picFrame = [SettingsManager sharedSettingsManager].picFrame;
            if (![CustomStringFunc isBlankString:picFrame]) {
                imv_frame.image = [UIImage imageNamed:picFrame];
            }
        });
        imv_frame;
    });
    self.imv_jt = ({
        UIImageView*imv_icon     = [[UIImageView alloc] init];
        imv_icon.backgroundColor = [UIColor clearColor];
        imv_icon.image           = [UIImage imageNamed:@"rightArrow"];
        imv_icon;
    });
    self.lb_user = ({
        UILabel* lb_user = [[UILabel alloc] init];
        lb_user.font = Text_Helvetica(12.0f);
        lb_user.textColor = [UIColor blackColor];
        lb_user.backgroundColor = [UIColor clearColor];
        lb_user.textAlignment = NSTextAlignmentRight;
        lb_user.text = [SettingsManager sharedSettingsManager].nickName;
        lb_user;
    });
   
    self.imv_lineX = ({
        UIImageView*imv_lineX     = [[UIImageView alloc] init];
        imv_lineX.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineX;
    });
    
    self.leftView = ({
        UIImageView*leftView = [[UIImageView alloc] init];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.userInteractionEnabled = YES;
        leftView;
    });
    self.centerView = ({
        UIImageView*centerView = [[UIImageView alloc] init];
        centerView.backgroundColor = [UIColor clearColor];
        centerView.userInteractionEnabled = YES;
        centerView;
    });
    self.rightView = ({
        UIImageView*rightView = [[UIImageView alloc] init];
        rightView.backgroundColor = [UIColor clearColor];
        rightView.userInteractionEnabled = YES;
        rightView;
    });
    
    self.lb_subject_sex = ({
        UILabel* lb_subject_sex = [[UILabel alloc] init];
        lb_subject_sex.font = Text_Helvetica(11.0f);
        lb_subject_sex.textColor = [UIColor blackColor];
        lb_subject_sex.backgroundColor = [UIColor clearColor];
        lb_subject_sex.textAlignment = NSTextAlignmentRight;
        lb_subject_sex.text = CustomLocalizedString(@"性别", nil);
        lb_subject_sex;
    });
    
    self.lb_sex = ({
        UILabel* lb_sex = [[UILabel alloc] init];
        lb_sex.font = Text_Helvetica(11.0f);
        lb_sex.textColor = [UIColor orangeColor];
        lb_sex.backgroundColor = [UIColor clearColor];
        lb_sex.textAlignment = NSTextAlignmentRight;
        lb_sex.text = @"男";
        lb_sex;
    });
    
    self.lb_subject_age = ({
        UILabel* lb_subject_age = [[UILabel alloc] init];
        lb_subject_age.font = Text_Helvetica(11.0f);
        lb_subject_age.textColor = [UIColor blackColor];
        lb_subject_age.backgroundColor = [UIColor clearColor];
        lb_subject_age.textAlignment = NSTextAlignmentRight;
        lb_subject_age.text = CustomLocalizedString(@"年龄", nil);
        lb_subject_age;
    });
    
    self.lb_age = ({
        UILabel* lb_age = [[UILabel alloc] init];
        lb_age.font = Text_Helvetica(11.0f);
        lb_age.textColor = [UIColor orangeColor];
        lb_age.backgroundColor = [UIColor clearColor];
        lb_age.textAlignment = NSTextAlignmentRight;
        lb_age.text = @"100";
        lb_age;
    });
    
    self.lb_subject_addr = ({
        UILabel* lb_subject_addr = [[UILabel alloc] init];
        lb_subject_addr.font = Text_Helvetica(11.0f);
        lb_subject_addr.textColor = [UIColor blackColor];
        lb_subject_addr.backgroundColor = [UIColor clearColor];
        lb_subject_addr.textAlignment = NSTextAlignmentRight;
        lb_subject_addr.text = CustomLocalizedString(@"地区", nil);
        lb_subject_addr;
    });
    
    self.lb_addr = ({
        UILabel* lb_addr = [[UILabel alloc] init];
        lb_addr.font = Text_Helvetica(11.0f);
        lb_addr.textColor = [UIColor orangeColor];
        lb_addr.backgroundColor = [UIColor clearColor];
        lb_addr.textAlignment = NSTextAlignmentRight;
        lb_addr.text = @"北京";
        lb_addr;
    });
    
    self.imv_lineY1 = ({
        UIImageView*imv_lineY1     = [[UIImageView alloc] init];
        imv_lineY1.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineY1;
    });
    
    self.imv_lineY2 = ({
        UIImageView*imv_lineY2     = [[UIImageView alloc] init];
        imv_lineY2.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineY2;
    });
    

    
    [self addSubview:self.imv_back];
    
    [self.imv_back addSubview:self.userBut];
    [self.userBut addSubview:self.imv_icon];
    [self.imv_icon addSubview:self.imv_frame];
    [self.userBut addSubview:self.lb_user];
    [self.userBut addSubview:self.imv_jt];
    
    [self.imv_back addSubview:self.imv_lineX];
    
    [self.imv_back addSubview:self.leftView];
    [self.leftView addSubview:self.lb_subject_sex];
    [self.leftView addSubview:self.lb_sex];
    [self.leftView addSubview:self.imv_lineY1];

    [self.imv_back addSubview:self.centerView];
    [self.centerView addSubview:self.lb_subject_age];
    [self.centerView addSubview:self.lb_age];
    [self.centerView addSubview:self.imv_lineY2];
    
    [self.imv_back addSubview:self.rightView];
    [self.rightView addSubview:self.lb_subject_addr];
    [self.rightView addSubview:self.lb_addr];
    
    
}

- (void)setAutoLayout{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.userBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ws.imv_back).with.offset(0);
        make.height.equalTo(120);
    }];
    
    [self.imv_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.userBut).with.offset(15);
        make.centerY.equalTo(ws.userBut.centerY).with.offset(0);
        make.size.equalTo(CGSizeMake(135/2, 135/2));
    }];
    
    [self.imv_frame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.imv_icon).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
  
    [self.imv_jt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.userBut.centerY).with.offset(0);
        make.right.equalTo(ws.userBut).with.offset(-12);
        make.size.equalTo(CGSizeMake(11/2, 18/2));
    }];
    
    [self.lb_user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_jt.left).with.offset(-5);
        make.centerY.equalTo(ws.userBut.centerY).with.offset(0);
        make.height.equalTo(20);
    }];
   
    [self.imv_lineX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_back.bottom).with.offset(-lineH);
        make.left.equalTo(ws.imv_back).with.offset(0);
        make.right.equalTo(ws.imv_back).with.offset(0);
        make.height.equalTo(lineH);
    }];

    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.userBut.bottom).with.offset(0);
        make.centerX.equalTo(ws.imv_back.centerX).with.offset(0);
        make.bottom.equalTo(ws.imv_back).with.offset(-2);
        make.width.equalTo(ViewFrame_bounds_width/3);
    }];
    [self.imv_lineY2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.centerView.top).with.offset(4);
        make.bottom.equalTo(ws.centerView.bottom).with.offset(-4);
        make.right.equalTo(ws.centerView).with.offset(-1);
        make.width.equalTo(lineH);
    }];
    [self.lb_subject_age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.centerView.centerX).with.offset(0);
        make.bottom.equalTo(ws.imv_lineY2.bottom).with.offset(-8);
        make.height.equalTo(12);
    }];
    [self.lb_age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.centerView.centerX).with.offset(0);
        make.top.equalTo(ws.imv_lineY2.top).with.offset(8);
        make.height.equalTo(12);
    }];
    
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.userBut.bottom).with.offset(0);
        make.bottom.equalTo(ws.imv_back).with.offset(-2);
        make.left.equalTo(ws.imv_back).with.offset(0);
        make.right.equalTo(ws.centerView.left).with.offset(0);
    }];
    [self.imv_lineY1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.leftView).with.offset(4);
        make.bottom.equalTo(ws.leftView).with.offset(-4);
        make.right.equalTo(ws.leftView).with.offset(-1);
        make.width.equalTo(lineH);
    }];
    [self.lb_subject_sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_lineY1.bottom).with.offset(-8);
        make.centerX.equalTo(ws.leftView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    [self.lb_sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_lineY1.top).with.offset(8);
        make.centerX.equalTo(ws.leftView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    
  
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.userBut.bottom).with.offset(0);
        make.bottom.equalTo(ws.imv_back).with.offset(-2);
        make.left.equalTo(ws.centerView.right).with.offset(0);
        make.right.equalTo(ws.imv_back).with.offset(0);
    }];
    [self.lb_subject_addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.rightView.centerX).with.offset(0);
        make.centerY.equalTo(ws.lb_subject_age.centerY).with.offset(0);
        make.height.equalTo(12);
    }];
    [self.lb_addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.rightView.centerX).with.offset(0);
        make.centerY.equalTo(ws.lb_age.centerY).with.offset(0);
        make.height.equalTo(12);
    }];
    
}

-(void)userButton:(UIButton*)but{
    if (_delegate && [_delegate respondsToSelector:@selector(OnClickEssentialInfo)])
    {
        [_delegate OnClickEssentialInfo];
    }
}

-(void)initEssentialInfo:(NSDictionary*)m_dict{

    NSString * picUrl = [m_dict valueForKey:@"picUrl"];
    NSString * picFrame = [m_dict valueForKey:@"picUrl"];
    NSString * nickname = [m_dict valueForKey:@"nickname"];
    NSString * area = [m_dict valueForKey:@"area"];
    NSString * sex = [m_dict valueForKey:@"sex"];
    NSString * age = [m_dict valueForKey:@"age"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.imv_icon downloadImage:picUrl placeholder:@"defaultHead"];
        if (![CustomStringFunc isBlankString:picFrame]) {
            self.imv_frame.image = [UIImage imageNamed:picFrame];
        }
    });
    
    self.lb_user.text = nickname;
    self.lb_sex.text = sex;
    self.lb_age.text = age;
    self.lb_addr.text = area;
}

@end
