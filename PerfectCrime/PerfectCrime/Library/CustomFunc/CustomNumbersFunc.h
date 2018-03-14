//
//  CustomNumbersFunc.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-26.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
/*************************************************
 *类注释*
 *<p>Title:有关数学计算类</p>
 *<p>Description: 该类封装一些数学计算的方法</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
 **************************************************/
@interface CustomNumbersFunc : NSObject
/*************************************************
 *方法注释*
 *Function:         // + (BOOL)isLeapGivenYear:(NSUInteger)givenYear;
 *Description:      // 检测是否是闰年
 *Calls:            // 无
 *@param            givenYear (NSUInteger)givenYear
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL)isLeapGivenYear:(NSUInteger)givenYear;


@end
