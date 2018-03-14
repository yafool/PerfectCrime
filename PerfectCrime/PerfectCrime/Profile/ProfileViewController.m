//
//  ProfileViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/14.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "ProfileViewController.h"
#import "PortraitSetViewController.h"
#import "AccountServer.h"

@interface ProfileViewController ()
<AccountServerDelegate>
{
    NSMutableDictionary * dict_Essential;
    NSMutableDictionary * dict_Game;
}
@property (nonatomic, strong) AccountServer *accountServer;
@end

@implementation ProfileViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    

    [self.navigationItem setItemWithTitle:CustomLocalizedString(@"我的", nil) textColor:[CustomColorRGB colorWithHexString:kNavColor] fontSize:18 itemType:center];
    [self initDate];
    
    [self setPlayerEssentialInfoView];
    [self setPlayerGameInfoView];
    [self setSettingsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AccountServer*)accountServer{
    if (!_accountServer) {
        _accountServer = [[AccountServer alloc]init];
        _accountServer.delegate = self;
    }
    
    return _accountServer;
}

- (void)initDate{
    // 设置默认值
    dict_Essential = [[NSMutableDictionary alloc]init];
    [dict_Essential setValue:[SettingsManager sharedSettingsManager].picUrl forKey:@"picUrl"];
    [dict_Essential setValue:[SettingsManager sharedSettingsManager].picFrame forKey:@"picFrame"];
    [dict_Essential setValue:[SettingsManager sharedSettingsManager].nickName forKey:@"nickName"];
    [dict_Essential setValue:[SettingsManager sharedSettingsManager].sex forKey:@"sex"];
    [dict_Essential setValue:[SettingsManager sharedSettingsManager].age forKey:@"age"];
    [dict_Essential setValue:[SettingsManager sharedSettingsManager].area forKey:@"area"];
    
    dict_Game = [[NSMutableDictionary alloc]init];
    [dict_Game setValue:@"100" forKey:@"gamesNum"];
    [dict_Game setValue:@"88" forKey:@"winNum"];
    [dict_Game setValue:@"88%" forKey:@"winsRate"];
    [dict_Game setValue:@"1001" forKey:@"gameScore"];
    [dict_Game setValue:@"11" forKey:@"mvpNum"];
    
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:userId, @"userId", nil];
    [self.accountServer requestGetUserInfo:postDict];
    
}

- (void) setPlayerEssentialInfoView{
    playerEssentialInfoView = [[PlayerEssentialInfoView alloc]initWithFrame:CGRectMake(0, 8, ViewFrame_bounds_width, 180)];
    playerEssentialInfoView.delegate = self;
    
    [self.view addSubview:playerEssentialInfoView];
}

- (void) setPlayerGameInfoView{
    playerGameInfoView = [[PlayerGameInfoView alloc]initWithFrame:CGRectMake(0, 8+180+8, ViewFrame_bounds_width, 120)];
    
    [self.view addSubview:playerGameInfoView];
}

- (void) setSettingsView{
    settingsView = [[SettingsView alloc]initWithFrame:CGRectMake(0, 8+180+8+120+8, ViewFrame_bounds_width, 80)];
    
    [self.view addSubview:settingsView];
}

#pragma mark ------------- Delegate -------------
- (void)OnClickEssentialInfo{
    PortraitSetViewController*portraitSetViewController = [[PortraitSetViewController alloc]init];
    portraitSetViewController.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    [self.navigationController pushViewController:portraitSetViewController animated:YES];
}

-(void)OnClickRemindSetting{
    PCLog(@"@====>OnClickRemindSetting");
}
-(void)OnClickSkinSetting{
    PCLog(@"@====>OnClickSkinSetting");
}

#pragma mark ------------- AccountServerDelegate -------------
-(void)responseUserInfo:(NSDictionary*)m_dict{
    NSInteger code = [[m_dict valueForKey:@"code"]integerValue];
    NSString *msg = [m_dict valueForKey:@"msg"];
    if (200 == code) {
        __block NSInteger winNum = 0;
        __block NSInteger failNum = 0;
        [m_dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            if ([@"nickname" isEqualToString:key]
                || [@"picUrl" isEqualToString:key]
                || [@"picFrame" isEqualToString:key]
                || [@"area" isEqualToString:key]) {
                [dict_Essential setValue:obj forKey:key];
            } else if ([@"winNum" isEqualToString:key]){
                winNum = [obj integerValue];
            } else if ([@"failNum" isEqualToString:key]){
                failNum = [obj integerValue];
            } else if ([@"sex" isEqualToString:key]){
                if (0 == [obj integerValue]) {
                    [dict_Essential setValue:@"男" forKey:key];
                } else {
                    [dict_Essential setValue:@"女" forKey:key];
                }
            } else if ([@"age" isEqualToString:key]){
                [dict_Essential setValue:[NSString stringWithFormat:@"%@",obj] forKey:key];
            }
            NSInteger gamesNum = winNum + failNum;
            float rate = (0 == gamesNum)? 0:winNum/(gamesNum);
            [dict_Game setObject:[NSString stringWithFormat:@"%ld", gamesNum] forKey:@"gamesNum"];
            [dict_Game setObject:[NSString stringWithFormat:@"%ld", winNum] forKey:@"winNum"];
            [dict_Game setObject:[NSString stringWithFormat:@"%f",  rate] forKey:@"winsRate"];
            
            [playerEssentialInfoView initEssentialInfo:dict_Essential];
            [playerGameInfoView initGameInfo:dict_Game];
        }];
    } else {
        [MBProgressHUD showErrorMessage:msg];
    }
}

@end
