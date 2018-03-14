//
//  LoginView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UIImageView *imv_halfup;
@property (nonatomic, strong) UIImageView *imv_halfdown;

@property (nonatomic, strong) UIImageView *imv_icon;
@property (nonatomic, strong) UIButton    *loginButton;
@property (nonatomic, strong) UILabel     *lb_verson;
@end

@implementation LoginView

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
    
    self.imv_halfup = ({
        UIImageView*imv_halfup     = [[UIImageView alloc] init];
        imv_halfup.backgroundColor = [UIColor clearColor];
        imv_halfup.userInteractionEnabled = YES;
        imv_halfup;
    });
    
    self.imv_halfdown = ({
        UIImageView*imv_halfdown     = [[UIImageView alloc] init];
        imv_halfdown.backgroundColor = [UIColor clearColor];
        imv_halfdown.userInteractionEnabled = YES;
        imv_halfdown;
    });
    
    self.imv_icon = ({
        UIImageView*imv_icon     = [[UIImageView alloc] init];
        imv_icon.backgroundColor = [UIColor clearColor];
        imv_icon.contentMode     = UIViewContentModeScaleAspectFit;
        imv_icon.image           = [UIImage imageNamed:@"themeIcon"];
        imv_icon;
    });
    
    self.loginButton = ({
        UIButton*growingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [growingButton setBackgroundColor:[CustomColorRGB colorWithHexString:@"#00a0e9"]];
        growingButton.titleLabel.font = Text_Helvetica(16.0f);
        [growingButton setTitle:CustomLocalizedString(@"微信登录", nil) forState:UIControlStateNormal];
        [growingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [growingButton addTarget:self action:@selector(didLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        growingButton;
    });
    
    self.lb_verson = ({
        UILabel* lb_verson = [[UILabel alloc] init];
        lb_verson.font = Text_Helvetica(15.0f);
        lb_verson.textColor = [CustomColorRGB colorWithHexString:kSubTitleColor];
        lb_verson.backgroundColor = [UIColor clearColor];
        lb_verson.textAlignment = NSTextAlignmentLeft;
        lb_verson.text = [NSString stringWithFormat:@"%@：V%@", CustomLocalizedString(@"版本号", nil),[CustomSoftwareFunc getSoftwareVersion]];
        lb_verson;
    });
    
    [self addSubview:self.imv_back];
    [self.imv_back addSubview:self.imv_halfup];
    [self.imv_back addSubview:self.imv_halfdown];
    
    [self.imv_halfup addSubview:self.imv_icon];
    [self.imv_halfdown addSubview:self.loginButton];
    [self.imv_halfdown addSubview:self.lb_verson];
}

- (void)setAutoLayout{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.imv_halfup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ws.imv_back).with.offset(0);
        make.top.equalTo(ws.imv_back).with.offset(0);
        make.bottom.equalTo(ws.imv_back.centerY).with.offset(0);
    }];
    
    [self.imv_halfdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ws.imv_back).with.offset(0);
        make.bottom.equalTo(ws.imv_back).with.offset(0);
        make.top.equalTo(ws.imv_back.centerY).with.offset(0);
    }];
    
    [self.imv_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.imv_halfup).with.offset(0);
        make.centerY.equalTo(ws.imv_halfup).with.offset(0);
        make.size.equalTo(CGSizeMake(isSizeScaleWith(128), isSizeScaleHeight(128)));
    }];
    
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_halfdown).with.offset(12);
        make.right.equalTo(ws.imv_halfdown).with.offset(-12);
        make.top.equalTo(ws.imv_halfdown).with.offset(isSizeScaleHeight(48));
        make.height.equalTo(isSizeScaleHeight(40));
    }];
    
    [self.lb_verson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_halfdown).with.offset(12);
        make.top.equalTo(ws.loginButton.bottom).with.offset(isSizeScaleHeight(40));
        make.height.equalTo(isSizeScaleHeight(20));
    }];
}

-(void)didLoginButton:(UIButton*)but{
    [self endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(onClickWeChatCologin)])
    {
        [_delegate onClickWeChatCologin];
    }
}



@end
