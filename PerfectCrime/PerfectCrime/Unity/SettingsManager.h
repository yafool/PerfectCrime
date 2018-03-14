//
//  SettingsManager.h
//  MobileBusiness
//
//  Created by mc on 12-2-21.
//  Copyright (c) 2012年 Daoyoudao (Beijing) Technology Co., Ltd. All rights reserved.
//

#import "SynthesizeSingleton.h"
@interface SettingsManager : NSObject

@property (nonatomic,copy) NSString *DeviceToken;        //设备的token
@property (nonatomic,copy) NSString *locationCityName;   //保存上一次的定位城市

/*储存首页接口版本号*/
@property (nonatomic,copy) NSString *tsVersion;          //当前更新版本号---时间戳
/*储存系统版本号*/
@property (nonatomic,copy) NSString *shopVerson;         //APP的版本号

@property (nonatomic,copy) NSString *userToken;          //用户登录成功后需要的token

@property (nonatomic,copy) NSString *nickName;            //帐户名
@property (nonatomic,copy) NSString *userId;              //帐户Id
@property (nonatomic,copy) NSString *picUrl;              //用户的头像地址
@property (nonatomic,copy) NSString *picFrame;            //用户的头像框
@property (nonatomic,copy) NSString *sex;                 //用户性别
@property (nonatomic,copy) NSString *age;                 //用户年龄
@property (nonatomic,copy) NSString *area;                //用户地区
@property (nonatomic,copy) NSString *skin;                //皮肤
@property (nonatomic,copy) NSString *firstUpdate;         //修改用户昵称次数: 0、没有修改过; 1、修改过


@property (nonatomic,copy) NSString *cacheBi;                   //储存BI数据

+ (SettingsManager *)sharedSettingsManager;

-(BOOL)hasLogin;

@end


