//
//  CustomDeviceFunc.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
/* 获取MAC地址需要引入的头文件 */
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
/* ip地址 */
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
/* 已连接wifi 信息*/
#import <SystemConfiguration/CaptiveNetwork.h>
/*************************************************
 *类注释*
 *<p>Title:设备相关</p>
 *<p>Description: 判断设备的信息及尺寸等方法</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
 **************************************************/
@interface CustomDeviceFunc : NSObject

/*************************************************
 *方法注释*
 *Function:         // is_iOS7
 *Description:      // 判断是否为iOS7以上版本(相关SDK方法会有区别)
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL)is_iOS7;

/*************************************************
 *方法注释*
 *Function:         // is_iPhone5
 *Description:      // 判断是否为iPhone5(屏幕比例与之前不同)
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL)is_iPhone5;

/*************************************************
 *方法注释*
 *Function:         // getMacaddress
 *Description:      // 获取手机的MAC地址
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
//----------------暂无

/*************************************************
 *方法注释*
 *Function:         // fetchSSIDInfo
 *Description:      // 获取手机已连接的wifi信息 BSSID SSID SSIDDATA
 *@return           // id
 *@Others:          // 其它说明
 **************************************************/
+ (id)fetchSSIDInfo;
+ (NSString *)getConnetWiFiSSID;
+ (NSString *)getConnetWiFiBSSID;

/*************************************************
 *方法注释*
 *Function:         // localWiFiIPAddress
 *Description:      // 获取手机的IP地址
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
+ (NSString *) localWiFiIPAddress;

/*************************************************
 *方法注释*
 *Function:         // + (CGSize)getDeviceSize;
 *Description:      // 获取当前屏幕的宽高
 *@return           // CGSize
 *@Others:          // 其它说明
 **************************************************/
+ (CGSize)getDeviceSize;

/*************************************************
 *方法注释*
 *Function:         // + (NSString *)getCurrentLanguage
 *Description:      // 获取当前语言
 *Calls:            // 无
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
+ (NSString *)getCurrentLanguage;

/*************************************************
 *方法注释*
 *Function:         // + (void)callThePhoneNumber:(NSString*)_phoneNumber;
 *Description:      // 呼叫电话 （打完电话后还可以回到APP）
 *Calls:            // 无
 *@Others:          // 其它说明
 **************************************************/
+ (void)callThePhoneNumber:(NSString*)_phoneNumber;

/*************************************************
 *方法注释*
 *Function:         // + (void)jumpToTheSafari:(NSString*)urlStr;
 *Description:      // 跳转第三方浏览器
 *Table Accessed:   // 被访问的表（此项仅对于牵扯到数据库操作的程序）
 *Table Updated:    // 被修改的表（此项仅对于牵扯到数据库操作的程序
 *Calls:            // 无
 *@Others:          // 其它说明
 **************************************************/
+ (void)jumpToTheSafari:(NSString*)urlStr;
/*************************************************
 *方法注释*
 *Function:         // +(BOOL) isConnectionAvailable
 *Description:      // 判断当前网络状态 返回是否有网
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+(BOOL) isConnectionAvailable;
/*************************************************
 *方法注释*
 *Function:         // +(CGRect)CGRectMakeBase:(CGRect)Rect
 *Description:      // 根据比例计算出符合的UI尺寸
 *@return           // CGRect
 *@Others:          // 其它说明
 **************************************************/
+(CGRect)CGRectMakeBase:(CGRect)Rect;
/*************************************************
 *方法注释*
 *Function:         // +(float)autoSizeScaleWight:(float)Wight;
 *Description:      // 根据比例计算出符合的UI尺寸
 *@return           // float
 *@Others:          // 其它说明
 **************************************************/
+(CGFloat)autoSizeScaleWight:(CGFloat)Wight;
/*************************************************
 *方法注释*
 *Function:         // +(float)autoSizeScaleHeight:(float)height;
 *Description:      // 根据比例计算出符合的UI尺寸
 *@return           // float
 *@Others:          // 其它说明
 **************************************************/
+(CGFloat)autoSizeScaleHeight:(CGFloat)height;
/*************************************************
 *方法注释*
 *Function:         // +(NSString*)getCurrentScreenResolution;
 *Description:      // 获取当前手机屏幕的分辨率
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
+(NSString*)getCurrentScreenResolution;
/*************************************************
 *方法注释*
 *Function:         // +(UINavigationController*)getCurrentNavigationController;
 *Description:      // 获取当前view的UINavigationController
 *@return           // UINavigationController
 *@Others:          // 其它说明
 **************************************************/
+(UINavigationController*)getCurrentNavigationController;
//公共参数的语言参数
+(NSString*)getUrlParamsLang;
@end
