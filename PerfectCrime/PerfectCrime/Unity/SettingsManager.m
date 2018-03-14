//
//  SettingsManager.m
//  MobileBusiness
//
//  Created by mc on 12-2-21.
//  Copyright (c) 2012年 Daoyoudao (Beijing) Technology Co., Ltd. All rights reserved.
//

#import "SettingsManager.h"
//登录用户名和密码
static NSString *SETTING_USERTOKEN =             @"SETTING_USERTOKEN";         //用户登录成功以后返回的token
static NSString *SETTING_DEVICETOKEN =           @"SETTING_DEVICETOKEN";

/*储存系统版本号*/
static NSString *SETTING_TSVERSION =             @"SETTING_TSVERSION";
static NSString *SETTING_SHOPVERSON =            @"SETTING_SHOPVERSON";
static NSString *SETTING_MAPONEVERSON =          @"SETTING_MAPONEVERSON";
static NSString *SETTING_MAPTOWVERSON =          @"SETTING_MAPTOWVERSON";

/*中大账号信息*/
static NSString *SETTING_NICKNAME    =           @"SETTING_NICKNAME";
static NSString *SETTING_USER_ID =               @"SETTING_USER_ID";
static NSString *SETTING_PICURL =                @"SETTING_PICURL";
static NSString *SETTING_PICFRAME =              @"SETTING_PICFRAME";
static NSString *SETTING_SEX =                   @"SETTING_SEX";
static NSString *SETTING_AGE =                   @"SETTING_AGE";
static NSString *SETTING_AREA =                  @"SETTING_AREA";
static NSString *SETTING_SKIN =                  @"SETTING_SKIN";
static NSString *SETTING_FIRSTUPDATE =           @"SETTING_FIRSTUPDATE";


static NSString *SETTING_CACHEBI =               @"SETTING_CACHEBI";      //储存BI数据

@interface SettingsManager ()
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@end
@implementation SettingsManager
SYNTHESIZE_SINGLETON_FOR_CLASS(SettingsManager)

@dynamic userToken;
@dynamic DeviceToken;        //设备的token

@dynamic tsVersion;          //当前更新版本号---时间戳
@dynamic shopVerson;

@dynamic nickName;            //帐户名
@dynamic userId;              //帐户Id
@dynamic picUrl;              //用户的头像地址
@dynamic picFrame;            //用户的头像框

@dynamic cacheBi;              //储存BI数据

@synthesize userDefaults = _userDefaults;

- (id)init
{
    if (self = [super init])
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        [self.userDefaults synchronize];
    }
    return self;
}
- (void)dealloc
{
    self.userDefaults = nil;
}
#pragma mark -
#pragma mark Public methods

-(NSString *)userToken
{
    return [self.userDefaults stringForKey:SETTING_USERTOKEN];
}
-(void)setUserToken:(NSString *)userToken
{
    [self.userDefaults setObject:userToken forKey:SETTING_USERTOKEN];
    [self.userDefaults synchronize];
}

-(NSString*)DeviceToken
{
    return [self.userDefaults stringForKey:SETTING_DEVICETOKEN];
}
-(void)setDeviceToken:(NSString *)DeviceToken
{
    [self.userDefaults setObject:DeviceToken forKey:SETTING_DEVICETOKEN];
    [self.userDefaults synchronize];
}

-(NSString*)tsVersion{
    return [self.userDefaults stringForKey:SETTING_TSVERSION];
}
-(void)setTsVersion:(NSString *)tsVersion{
    [self.userDefaults setObject:tsVersion forKey:SETTING_TSVERSION];
    [self.userDefaults synchronize];
}
-(NSString*)shopVerson{
    return [self.userDefaults stringForKey:SETTING_SHOPVERSON];
}
-(void)setShopVerson:(NSString *)shopVerson{
    [self.userDefaults setObject:shopVerson forKey:SETTING_SHOPVERSON];
    [self.userDefaults synchronize];
}
-(BOOL)hasLogin{
    NSString * tmpUserId = [self.userDefaults stringForKey:SETTING_USER_ID];
    PCLog(@"SettingsManager userId: %@", tmpUserId);
    return ![CustomStringFunc isBlankString:tmpUserId];
}
-(NSString*)userId{
    return [self.userDefaults stringForKey:SETTING_USER_ID];
}
-(void)setUserId:(NSString *)userId{
    [self.userDefaults setObject:userId forKey:SETTING_USER_ID];
    [self.userDefaults synchronize];
}
-(NSString*)nickName{
    return [self.userDefaults stringForKey:SETTING_NICKNAME];
}
-(void)setNickName:(NSString *)nickname{
    [self.userDefaults setObject:nickname forKey:SETTING_NICKNAME];
    [self.userDefaults synchronize];
}
-(NSString*)picUrl{
    return [self.userDefaults stringForKey:SETTING_PICURL];
}
-(void)setPicUrl:(NSString *)picUrl{
    [self.userDefaults setObject:picUrl forKey:SETTING_PICURL];
    [self.userDefaults synchronize];
}
-(NSString*)picFrame{
    return [self.userDefaults stringForKey:SETTING_PICFRAME];
}
-(void)setPicFrame:(NSString *)picFrame{
    [self.userDefaults setObject:picFrame forKey:SETTING_PICFRAME];
    [self.userDefaults synchronize];
}
-(NSString*)firstUpdate{
    return [self.userDefaults stringForKey:SETTING_FIRSTUPDATE];
}
-(void)setFirstUpdate:(NSString *)firstUpdate{
    [self.userDefaults setObject:firstUpdate forKey:SETTING_FIRSTUPDATE];
    [self.userDefaults synchronize];
}
-(NSString*)sex{
    return [self.userDefaults stringForKey:SETTING_SEX];
}
-(void)setSex:(NSString *)sex{
    [self.userDefaults setObject:sex forKey:SETTING_SEX];
    [self.userDefaults synchronize];
}
-(NSString*)age{
    return [self.userDefaults stringForKey:SETTING_AGE];
}
-(void)setAge:(NSString *)age{
    [self.userDefaults setObject:age forKey:SETTING_AGE];
    [self.userDefaults synchronize];
}
-(NSString*)area{
    return [self.userDefaults stringForKey:SETTING_AREA];
}
-(void)setArea:(NSString *)area{
    [self.userDefaults setObject:area forKey:SETTING_AREA];
    [self.userDefaults synchronize];
}
-(NSString*)skin{
    return [self.userDefaults stringForKey:SETTING_SKIN];
}
-(void)setSkin:(NSString *)skin{
    [self.userDefaults setObject:skin forKey:SETTING_SKIN];
    [self.userDefaults synchronize];
}
-(NSString*)cacheBi{
    return [self.userDefaults stringForKey:SETTING_CACHEBI];
}
-(void)setCacheBi:(NSString *)cacheBi{
    [self.userDefaults setObject:cacheBi forKey:SETTING_CACHEBI];
    [self.userDefaults synchronize];
}
@end
