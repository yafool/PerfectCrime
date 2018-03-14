//
//  CustomSoftwareFunc.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*************************************************
 *类注释*
 *<p>Title:软件相关信息</p>
 *<p>Description: 获取当前软件相关信息的方法</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
 **************************************************/
@interface CustomSoftwareFunc : NSObject

/*************************************************
 *方法注释*
 *Function:         // + (NSString*)getSoftwareName;
 *Description:      // 获取软件的名字
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
+ (NSString*)getSoftwareName;

/*************************************************
 *方法注释*
 *Function:         // + (NSString*)getSoftwareVersion;
 *Description:      // 获取软件的正式版本号
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
+ (NSString*)getSoftwareVersion;

/*************************************************
 *方法注释*
 *Function:         // + (NSString*)getSoftwareBuildVersion;
 *Description:      // 获取软件的编译版本号
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
+ (NSString*)getSoftwareBuildVersion;

/*************************************************
 *方法注释*
 *Function:         // + (NSString*)getSoftwareBundleIdentifier;
 *Description:      // 获取软件的包名
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
+ (NSString*)getSoftwareBundleIdentifier;

/*************************************************
 *方法注释*
 *Function:         // +(NSString *)databaseFilePath;
 *Description:      // 数据库 路径
 *@return           // 无
 *@Others:          // 其它说明
 **************************************************/
+(NSString *)databaseFilePath;
/*************************************************
 *方法注释*
 *Function:         // +(NSString *)creatLocaFilePath:(NSString*)fileName;
 *Description:      // 创建路径 路径
 *@return           // 路径地址
 *@Others:          // 其它说明
 **************************************************/
+(NSString *)creatLocaFilePath:(NSString*)fileName;
@end
