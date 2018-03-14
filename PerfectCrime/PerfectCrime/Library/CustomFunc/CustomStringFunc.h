//
//  CustomStringFunc.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-25.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>

/*************************************************
 *类注释*
 *<p>Title:有关字符串的操作类</p>
 *<p>Description: 如算中英混合字符算长度，去除字符串中的副文本符号等</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
 **************************************************/
@interface CustomStringFunc : NSObject
/*************************************************
 *方法注释*
 *Function:         // + (int)convertToInt:(NSString*)strtemp;
 *Description:      // 获取中英文总共的长度
 *Calls:            // 无
 *@param            strtemp (NSString*)strtemp;
 *@return           // int
 *@Others:          // 其它说明
 **************************************************/
+ (int)convertToInt:(NSString*)strtemp;

/*************************************************
 *方法注释*
 *Function:         // + (BOOL)isMobileNumber:(NSString *)mobileNum
 *Description:      // 判断是否为合法手机号
 *Calls:            // 无
 *@param            mobileNum (NSString *)mobileNum
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*************************************************
 *方法注释*
 *Function:         // + (BOOL)isEmailAddress:(NSString*)email;
 *Description:      // 判断是否为合法的邮箱
 *Calls:            // 无
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL)isEmailAddress:(NSString*)email;

/*************************************************
 *方法注释*
 *Function:         // + (BOOL) isIncludeSpecialCharact:(NSString *)str;
 *Description:      // 判断是否包含特殊字符
 *Calls:            // 无
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL) isIncludeSpecialCharact:(NSString *)str;

/*************************************************
 *方法注释*
 *Function:         // + (BOOL) isIncludeChineseInString:(NSString*)str;
 *Description:      // 判断是否包含非中文文字
 *Calls:            // 无
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL) isIncludeChineseInString:(NSString*)str;

/*************************************************
 *方法注释*
 *Function:         // +(BOOL)isBlankString:(NSString *)string;
 *Description:      // 判断字符串是否为空或者空格或者类型不符
 *Calls:            // 无
 *@Others:          // 其它说明
 **************************************************/
+(BOOL)isBlankString:(NSString *)string;

/*************************************************
 *方法注释*
 *Function:         // + (BOOL) validateZip: (NSString *) candidate;
 *Description:      // 验证邮编
 *Calls:            // 无
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+ (BOOL) validateZip: (NSString *) candidate;
//获得设备型号
+ (NSString *)getCurrentDeviceModel;
//检测手机号是否正确
+ (BOOL)checkTel:(NSString *)str;
//检测价格输入是否正确
+ (BOOL)checkEnterPrice:(NSString *)str;
/*ios去掉字符串中的html标签的方法*/
+(NSString *)filterHTML:(NSString *)html;
/*首行缩进的lable*/
+(NSMutableAttributedString*)getLableFrome:(NSString*)contentText lb_font:(UIFont*)lbfont firstLineIndent:(float)firstIndent;
/*手机号码中间位置用****代替*/
+(NSString*)hidePhone:(NSString*)phoneStr;
/*
 *根据字典，按key和value还回body字符串
 */
+ (NSString*)getRequestUrlWithFromDict:(NSDictionary*)_Key_Vaule;
/*字符串转换成16进制*/
+ (NSString *) stringToHex:(NSString *)str;
/*16进制转换成字符串*/
+ (NSString *) stringFromHex:(NSString *)str;
/*!
 @abstract NSString类型UTF8Encoding（包含特殊字符）
 */
+ (NSString *)URLEncodedString:(NSString *)str;
/*!
 @abstract UTF8Encoding类型转NSString（包含特殊字符）
 */
+ (NSString*)URLDecodedString:(NSString *)str;
/*!
 @abstract 判断文字是否包含Emoji表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;
/*************************************************
 *方法注释*
 *Function:         // +(BOOL)checkMenuArry:(NSMutableArray*)m_arry IsExist:(NSString*)menuType;
 *Description:      // 检查首页某一个模板类型是否存在
 *Calls:            // 无
 *@Others:          // 其它说明
 **************************************************/
+(BOOL)checkMenuArry:(NSMutableArray*)m_arry IsExist:(NSString*)menuType;
/*************************************************
 *方法注释*
 *Function:         // +(NSInteger)objectIndexInMenuArry:(NSMutableArray*)m_arry IsExist:(NSString*)menuType;
 *Description:      // 检查首页某一个模板类型存在的位置
 *Calls:            // 无
 *@Others:          // 其它说明
 **************************************************/
+(NSInteger)objectIndexInMenuArry:(NSMutableArray*)m_arry IsExist:(NSString*)menuType;
//判断16进制颜色值是否为空或者空格或者类型不符
+(BOOL)isTextCokorString:(NSString *)string;
//通过图片Data数据第一个字节 来获取图片扩展名
+(NSString*)getPictureKinds:(NSString*)picSource;
//检查是否有标题
+(BOOL)checkMenuListArryIsExistTitle:(NSArray*)m_arry;
//检查是否有价格
+(BOOL)checkMenuListArryIsExistPrice:(NSArray*)m_arry;
//去掉字符串中的某个字符串
+(NSString*)replacingStringBy:(NSString*)byString deletStr:(NSString*)DStr;
//判断字符串是否包含非法字符
+ (BOOL)isHaveIllegalChar:(NSString *)str;
//判断URL是否为空
+(BOOL)isCheckUrlCanUse:(NSURL *)url;
@end
