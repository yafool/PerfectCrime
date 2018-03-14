//
//  CustomDictionaryFunc.m
//  hpwifiShop
//
//  Created by cuitonghui on 15/10/12.
//  Copyright © 2015年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomDictionaryFunc.h"

@implementation CustomDictionaryFunc
+(BOOL)isBlankDiction:(NSDictionary *)theDict
{
    if (![theDict isKindOfClass:[NSDictionary class]])
    {
        return YES;
    }
    if (theDict == nil||[theDict isEqual:[NSNull null]])
    {
        return YES;
    }
    if ([theDict isKindOfClass:[NSDictionary class]])
    {
        if ([theDict count] == 0)
        {
            return YES;
        }
    }
    return NO;
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    PCLog(@"json解析的数据====》》》》》：%@",jsonString);
    if ([CustomStringFunc isBlankString:jsonString]) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        PCLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
