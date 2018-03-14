//
//  CustomNetWorkURL.h
//  hpwifiShop
//
//  Created by wangxiaoqin on 14-7-22.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomNetWorkURL : NSObject
+ (NSString*)getSignMd5:(NSDictionary*)params;
+ (NSString*)getRequestUrlWithHead:(NSString*)API_head From:(NSDictionary*)_Key_Vaule;
@end
