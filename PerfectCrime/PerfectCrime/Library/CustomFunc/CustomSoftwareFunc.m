//
//  CustomSoftwareFunc.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomSoftwareFunc.h"

@implementation CustomSoftwareFunc
+ (NSString*)getSoftwareName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

+ (NSString*)getSoftwareVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString*)getSoftwareBuildVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_buildVersion;
}
+ (NSString*)getSoftwareBundleIdentifier{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_buildVersion = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return app_buildVersion;
}
+(NSString *)databaseFilePath
{
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath firstObject];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"hpWifi.sqlite"];
    return dbFilePath;
    
}
+(NSString *)creatLocaFilePath:(NSString*)fileName
{
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath firstObject];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:fileName];
    return dbFilePath;
    
}
@end
