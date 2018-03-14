//
//  CustomTextSizeFunc.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*************************************************
 *类注释*
 *<p>Title:全局类方法 text size 计算</p>
 *<p>Description: 自定义计算文字宽高</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
 **************************************************/
@interface CustomTextSizeFunc : NSObject

/*************************************************
 *方法注释*
 *Function:         // [CustomTextSizeFunc getSizeOfText:(NSString *) font:(UIFont *) view:(UIView *)]
 *Description:      // 计算文字的size
 *@Others:          // 其它说明 #something#
 **************************************************/
+ (CGSize)getSizeOfText:(NSString*)_text font:(UIFont*)_font view:(UIView*)_views;
//根据字体大小自动计算label大小
+(CGSize)calculateLabelSizeOfContent:(NSString*)text withFont:(UIFont*)font maxSize:(CGSize)aMaxSize defSize:(CGSize)DSize;
//根据字体大小自动计算label大小
+(CGRect)LabelSizeOfContent:(NSString*)text withFont:(UIFont*)font maxSize:(CGSize)aMaxSize;
//根据字体大小自动计算label大小
//+(CGRect)LabelAutoSizeFromeContent:(NSString*)text withFont:(UIFont*)font maxSize:(CGSize)aMaxSize;
@end
