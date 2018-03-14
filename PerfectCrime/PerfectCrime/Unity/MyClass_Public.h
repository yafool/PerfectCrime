//
//  MyClass_Public.h
//  hpwifiShop
//
//  Created by wangxiaoqin on 14-7-24.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MyClass_Public : NSObject
@property (nonatomic,copy)     NSString * cityName;
//@property (nonatomic,copy)     NSString * cityWebName;//只给CP第三方的webview使用
@property (nonatomic,copy)     NSString * currentCityName;

@property (nonatomic,copy)     NSString * cityID;
@property (nonatomic,copy)     NSString * currentCityId;

@property (nonatomic,copy)     NSString * longitudeJ;
@property (nonatomic,copy)     NSString * latitudeW;

@property (nonatomic,strong)   NSMutableDictionary * userDict;

//@property (nonatomic,assign)   int  serviceId;

@property (nonatomic,strong)   NSDictionary * fnSpotlightDict;

@property (nonatomic,copy)     NSString * searchTips;


@property (nonatomic,assign)   BOOL  isLaunchedByNotification;
@property (nonatomic,strong)   NSDictionary * m_notification;

@property (nonatomic,strong)   NSDictionary * serviceDict;

+(MyClass_Public *)getInstance;

@end
