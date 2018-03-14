//
//  CustomColorRGB.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-25.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
/*************************************************
 *类注释*
 *<p>Title:颜色类方法</p>
 *<p>Description: 有关RGB颜色 等方法</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
 **************************************************/
@interface CustomColorRGB : NSObject
// 将16进制颜色 转化为 IOS中的 RGB颜色
+ (UIColor *) colorWithHexString: (NSString *)color;
/*随机颜色*/
+ (UIColor *)randomColor;
@end
