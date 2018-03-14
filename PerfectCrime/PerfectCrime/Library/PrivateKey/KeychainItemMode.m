//
//  KeychainItemMode.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-7-7.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "KeychainItemMode.h"
#import "KeychainItemWrapper.h"
@implementation KeychainItemMode
@synthesize onlykeychain;
static KeychainItemMode * sharedSingleton = nil;

+ (KeychainItemMode *) sharedInstance{
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    if (sharedSingleton == nil) {
        sharedSingleton = [[KeychainItemMode alloc] init];
        }
    return sharedSingleton;
}

- (void)initKeyChain{
    /*
    //初始化并重置默认的通用钥匙串项目数据。
    [onlykeychain resetKeychainItem];
    */
    if (!onlykeychain) {
        onlykeychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"keyChainIdentifier"
                                                           accessGroup:nil];
    }
}

- (BOOL)setKeyChainUUID{
    if (!([self getKeyChainUUID].length<=0)) {
        return YES;
    }
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //保存密码
    [onlykeychain setObject:idfv forKey:(__bridge id)kSecValueData];
    
    if (![onlykeychain objectForKey:(__bridge id)kSecValueData]) {
        return NO;
    }
    return YES;
}

- (NSString*)getKeyChainUUID{
    [self initKeyChain];
    //从keychain里取出帐号密码
    NSString *uuid = [onlykeychain objectForKey:(__bridge id)kSecValueData];
    return uuid;
}

@end
