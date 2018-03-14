//
//  CustomNetWorkURL.m
//  hpwifiShop
//
//  Created by wangxiaoqin on 14-7-22.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomNetWorkURL.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CustomNetWorkURL

+ (NSString*)getSignMd5:(NSDictionary*)params{
    NSArray *keyArray = [params allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (NSString *keyStr in sortArray) {
        NSString *ValueStr = [NSString stringWithFormat:@"%@",[params objectForKey:keyStr]];
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",keyStr,ValueStr];
        
        [signArray addObject:keyValueStr];
    }
    
    NSString *sign = [signArray componentsJoinedByString:@""];
    PCLog(@"sign=====>>>%@",sign);
    PCLog(@"signMd5===>>>%@",[self signMd5:sign]);
    return [self signMd5:sign];
}

+ (NSString*)getRequestUrlWithHead:(NSString*)API_head From:(NSDictionary*)_Key_Vaule
{    @synchronized (self)
    {
        if (_Key_Vaule.count == 0) {
            return [NSString stringWithString:API_head];
        }
        
        NSArray * keyArray = [_Key_Vaule allKeys];
        NSArray * vauleArray = [_Key_Vaule allValues];
        NSMutableArray * newArray =[[NSMutableArray alloc]init];
        NSMutableString * urlBodyStr = [[NSMutableString alloc]initWithString:API_head];
        if (keyArray.count == vauleArray.count) {
            for (int i = 0; i< [vauleArray count]; i++) {
                
                if (vauleArray[i] == nil||vauleArray[i] == NULL||[vauleArray[i] isEqual:[NSNull null]])
                {
                    [newArray addObject:[NSString stringWithFormat:@"%@=%@",keyArray[i],@""]];
                }
                else
                {
                    [newArray addObject:[NSString stringWithFormat:@"%@=%@",keyArray[i],vauleArray[i]]];
                }
                
            }
            NSString * str = [newArray componentsJoinedByString:@"&"];
            [urlBodyStr appendString:str];
        }
        return urlBodyStr;
    }
}

+ (NSString *)signMd5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

@end
