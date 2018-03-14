//
//  KeychainItemMode.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-7-7.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
@interface KeychainItemMode : NSObject
{
    KeychainItemWrapper * onlykeychain;
}
@property (nonatomic,retain) KeychainItemWrapper * onlykeychain;
+ (KeychainItemMode *) sharedInstance;
/*************************************************
 *方法注释*
 *Function:         // setKeyChainPassword
 *Description:      // 设置私钥 中唯一识别Password
 *Calls:            // initKeychina
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
- (BOOL)setKeyChainUUID;
/*************************************************
 *方法注释*
 *Function:         // getKeyChainPassWord
 *Description:      // 获取私钥 中唯一识别Password
 *Calls:            // 无
 *@return           // NSString
 *@Others:          // 其它说明
 **************************************************/
- (NSString*)getKeyChainUUID;
@end
