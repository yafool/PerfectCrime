//
//  CustomDeviceFunc.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomDeviceFunc.h"

@implementation CustomDeviceFunc

+ (BOOL)is_iOS7{
   return  [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ?  YES :  NO;
}

+ (BOOL)is_iPhone5{
   return  [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO;
}

+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    //CTHLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
       // CTHLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

+ (NSString *)getConnetWiFiSSID{
    return [[self fetchSSIDInfo] objectForKey:@"SSID"];
}

+ (NSString *)getConnetWiFiBSSID{
    
    NSString * BSSID = [[self fetchSSIDInfo] objectForKey:@"BSSID"];
    NSArray * BSSIDArray = [BSSID componentsSeparatedByString:@":"];
    NSMutableArray * newBSSIDArray = [[NSMutableArray alloc]init];
    for (NSString * strBssid in BSSIDArray) {
        if (strBssid.length == 0) {
            [newBSSIDArray addObject:@"00"];
        }else if(strBssid.length == 1){
            [newBSSIDArray addObject:[NSString stringWithFormat:@"0%@",strBssid]];
        }else{
            [newBSSIDArray addObject:strBssid];
        }
    }
    NSMutableString * newBSSIDStr = [[NSMutableString alloc]init];
    for (NSString * str in newBSSIDArray) {
        [newBSSIDStr appendString:str];
    }
    BSSID = [newBSSIDStr uppercaseString];
    
    return BSSID;
}

+ (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

+ (CGSize)getDeviceSize{
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    return size;
}

+(CGRect)CGRectMakeBase:(CGRect)Rect
{
    
    float autoSizeScaleX = ViewFrame_bounds_width/375;
    float autoSizeScaleY = ViewFrame_bounds_height/667;
    
    CGRect rect;
    
    rect.origin.x = Rect.origin.x * autoSizeScaleX; rect.origin.y = Rect.origin.y * autoSizeScaleY;
    
    rect.size.width = Rect.size.width * autoSizeScaleX; rect.size.height = Rect.size.height * autoSizeScaleY;
    
    return rect;
    
}

+(CGFloat)autoSizeScaleWight:(CGFloat)Wight{
    float autoSizeScaleX = ViewFrame_bounds_width/375;
    return Wight*autoSizeScaleX;
}

+(CGFloat)autoSizeScaleHeight:(CGFloat)height{
    float autoSizeScaleY = ViewFrame_bounds_height/667;
    return height*autoSizeScaleY;
}

+ (NSString *)getCurrentLanguage{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+ (void)callThePhoneNumber:(NSString*)_phoneNumber{
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNumber]];
    UIWebView * phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容器 不需要add到页面上来  效果跟方法二一样但是这个方法是合法的
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

+ (void)jumpToTheSafari:(NSString*)urlStr{
    NSString * enterUrl = [NSString stringWithFormat:@"%@",urlStr];
    NSURL * url =  [NSURL URLWithString:enterUrl];
    if([CustomStringFunc isCheckUrlCanUse:url]){
        enterUrl = [enterUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL * httpUrl = [NSURL URLWithString:enterUrl];
    if([[UIApplication sharedApplication]canOpenURL:httpUrl]) {
        if(IOS_VERSION_10_OR_ABOVE){
            [[UIApplication sharedApplication]openURL:httpUrl options:@{}completionHandler:^(BOOL success) {} ];
        }else{
            [[UIApplication sharedApplication]openURL:httpUrl];
        }
    }
}

+(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

+(NSString*)getCurrentScreenResolution{
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    
    NSString * ScreenResolution = [NSString stringWithFormat:@"%dx%d", (int)width,(int)height];
    
    return ScreenResolution;
}

//获取当前view的UINavigationController
+(UINavigationController*)getCurrentNavigationController{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if([window.rootViewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabVC = (UITabBarController *)window.rootViewController;
        UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
        return pushClassStance;
    }else if([window.rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController * navigation  = (UINavigationController*)window.rootViewController;
        return navigation;
    }
    return nil;
}


@end
