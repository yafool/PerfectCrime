//
//  CustomDataFunc.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*************************************************
                    *类注释*
 *<p>Title:时间相关类</p>
 *<p>Description: 针对时间封装 时间转换的方法</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
**************************************************/
@interface CustomDataFunc : NSObject

// 计算发布时间距现在时间的时长
+ (NSString *)newsTime:(NSString *)newsTimes;

// 获取当前日期时间
+ (NSString *)getTimeDateNow:(NSString *)timeKind;

// 获取当天是星期几
+(NSString *)getWeekday;

/*时间戳 转时间*/
+ (NSString *)getTimeDateFrome:(NSString*)data timeKinds:(NSString*)kind;

/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName;

//检查获取到的token是否过期
+ (BOOL)checkTokenIsOutTime:(NSString *)getTokenTimes expiresInTime:(NSString*)expiresin;

/**
 *  获取给定时间的前一天和后一天
 */
+(NSString*)getTimeDateFromeData:(NSString *)data dataKinds:(int)kind;

//获得当前时间的前几天，几个月的日期
+(NSString*)getbeforDateFromeCurrentTime:(NSInteger)beforMonths BeforDays:(NSInteger)beforDay;

//检查广告展示时间是否超过2小时
+ (BOOL)checkShowADIsOutTime:(NSString *)adTimes;

/**
 *  仿QQ空间时间显示
 *  @param string eg:2015年5月24日 02时21分30秒
 */
+ (NSString *)format:(NSString *)string;

/**
 *  获取当前时间戳
 *  13位精确到毫秒*1000，不乘就是精确到秒
 *  eg:1485065812018
 */
+ (NSString *)getCurrentTheTimestamp;
#pragma mark - 时间比较大小
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
@end

