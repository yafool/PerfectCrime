//
//  LoginViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "LoginViewController.h"
#import "WeChatManager.h"
#import "AccountServer.h"


@interface LoginViewController ()<AccountServerDelegate>
@property (nonatomic, strong) AccountServer *accountServer;
@end

@implementation LoginViewController

@synthesize delegate = _delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    
    [self.navigationItem setItemWithTitle:CustomLocalizedString(@"登录", nil) textColor:[CustomColorRGB colorWithHexString:kNavColor] fontSize:18 itemType:center];
    
    LoginView * loginView = [[LoginView alloc]initWithFrame:self.view.bounds];
    loginView.delegate = self;
    loginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loginView];

}

- (AccountServer*)accountServer{
    if (!_accountServer) {
        _accountServer = [[AccountServer alloc]init];
        _accountServer.delegate = self;
    }
    
    return _accountServer;
}

-(void)onClickWeChatCologin{
    BOOL isTest = YES;
    if (isTest) {
        //测试桩
        // NSString *uuid = [[KeychainItemMode sharedInstance]getKeyChainUUID];
        NSString *model = [[UIDevice currentDevice]model];
        NSString *uuid =  [[KeychainItemMode sharedInstance]getKeyChainUUID];
        NSString *udid = [NSString stringWithFormat:@"test_%@_%@",model, uuid];;
        NSString *name = [[UIDevice currentDevice]name];
        
        NSMutableDictionary * testDict = [[NSMutableDictionary alloc]init];
        NSString *headurl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505667819335&di=eacaaeeaf2d340364c8295b38fecf88c&imgtype=0&src=http%3A%2F%2Fimglf1.ph.126.net%2FlEOKBaIo_8L4W7o6xaSjLQ%3D%3D%2F6608936795654832919.jpg";
        [testDict setValue:name forKey:@"nickName"];
        [testDict setValue:udid forKey:@"openId"];
        [testDict setValue:headurl forKey:@"headimgurl"];
        [testDict setValue:@"0" forKey:@"sex"];
        [testDict setValue:@"100" forKey:@"age"];
        [testDict setValue:@"北京" forKey:@"province"];
        [testDict setValue:@"北京" forKey:@"city"];
        [self.accountServer requestCologin:testDict];
    } else {
        [[WeChatManager getInstance]sendAuthReq:self andBlock:^(ReturnCode code, NSDictionary* m_dict){
            
            if (ReturnCode_failed == code) {
                PCLog(@"login weixin failed!  ==== %@",m_dict);
            } else {
                [self.accountServer requestCologin:m_dict];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------- AccountServerDelegate  ----------------/
-(void)responseCologin:(NSDictionary*)m_dict{
    if (!m_dict) {
        PCLog(@"没获取到玩家信息");
        return;
    }
    
    NSString *nickName = [m_dict valueForKey:@"nickName"];
    [[SettingsManager sharedSettingsManager]setNickName:nickName];
    
    NSString *userId = [m_dict valueForKey:@"userId"];
    [[SettingsManager sharedSettingsManager]setUserId:userId];
    
    NSString *picUrl = [m_dict valueForKey:@"picUrl"];
    [[SettingsManager sharedSettingsManager]setPicUrl:picUrl];
    
    NSString *picFrame = [m_dict valueForKey:@"picFrame"];
    [[SettingsManager sharedSettingsManager]setPicFrame:picFrame];
    
    NSString *firstUpdate = [m_dict valueForKey:@"firstUpdate"];
    [[SettingsManager sharedSettingsManager]setFirstUpdate:firstUpdate];
    
    NSString *sex = [m_dict valueForKey:@"sex"];
    [[SettingsManager sharedSettingsManager]setSex:sex];
    NSString *age = [m_dict valueForKey:@"age"];
    [[SettingsManager sharedSettingsManager]setAge:age];
    NSString *area = [m_dict valueForKey:@"area"];
    [[SettingsManager sharedSettingsManager]setArea:area];
    NSString *skin = [m_dict valueForKey:@"skin"];
    [[SettingsManager sharedSettingsManager]setSkin:skin];
    
    [MBProgressHUD hideHUD];
    // 登陆成功
    if (_delegate && [_delegate respondsToSelector:@selector(LoginSucceed)])
    {
        [_delegate LoginSucceed];
    }
}

@end
