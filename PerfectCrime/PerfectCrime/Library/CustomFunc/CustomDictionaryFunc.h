//
//  CustomDictionaryFunc.h
//  hpwifiShop
//
//  Created by cuitonghui on 15/10/12.
//  Copyright © 2015年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDictionaryFunc : NSObject
/*************************************************
 *方法注释*
 *Function:         // isBlankDiction
 *Description:      // 判断数组为空
 *Calls:            // 无
 *@param            theDict (NSDictionary *)theDict
 *@return           // BOOL
 *@Others:          // 其它说明
 **************************************************/
+(BOOL)isBlankDiction:(NSDictionary *)theDict;
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
