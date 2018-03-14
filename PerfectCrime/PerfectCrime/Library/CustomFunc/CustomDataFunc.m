//
//  CustomDataFunc.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomDataFunc.h"
#import <objc/runtime.h>

@implementation CustomDataFunc
//检查广告展示时间是否超过2小时
+ (BOOL)checkShowADIsOutTime:(NSString *)adTimes
{
    BOOL isOutTime = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kTimeFormatOne;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier];
    NSDate *date = [formatter dateFromString:adTimes];
    NSDate *now = [NSDate date];
    //比较获取到token的时间和当前时间 是否 大于 有效时间
    NSTimeInterval interval = [now timeIntervalSinceDate:date];
    
    if(interval > 60*60*2){
        isOutTime = YES;
    }
    
    return isOutTime;
}
//检查获取到的token是否过期
+ (BOOL)checkTokenIsOutTime:(NSString *)getTokenTimes expiresInTime:(NSString*)expiresin
{
    BOOL isOutTime = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kTimeFormatOne;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier];
    NSDate *date = [formatter dateFromString:getTokenTimes];
    NSDate *now = [NSDate date];
    //比较获取到token的时间和当前时间 是否 大于 有效时间
    NSTimeInterval interval = [now timeIntervalSinceDate:date];
    
    if(interval >= [expiresin doubleValue]){
        isOutTime = YES;
    }
    
    return isOutTime;
}
// 比较帖子发布时间和当前时间
+ (NSString *)newsTime:(NSString *)newsTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kTimeFormatOne;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier];
    NSDate *date = [formatter dateFromString:newsTimes];
    NSDate *now = [NSDate date];
    // 比较帖子发布时间和当前时间
    NSTimeInterval interval = [now timeIntervalSinceDate:date];
    NSString *format;
    if (interval <= 60) {
        format = @"刚刚";
    } else if(interval <= 60*60){
        format = [NSString stringWithFormat:@"发布于前%.f分钟", interval/60];
    } else if(interval <= 60*60*24){
        format = [NSString stringWithFormat:@"发布于前%.f小时", interval/3600];
    } else if (interval <= 60*60*24*7){
        format = [NSString stringWithFormat:@"发布于前%d天", (int)interval/(60*60*24)];
    } else if (interval > 60*60*24*7 & interval <= 60*60*24*30 ){
        format = [NSString stringWithFormat:@"发布于前%d周", (int)interval/(60*60*24*7)];
    }else if(interval > 60*60*24*30 ){
        format = [NSString stringWithFormat:@"发布于前%d月", (int)interval/(60*60*24*30)];
    }
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}
/**
 *  获取当前时间
 */
+ (NSString *)getTimeDateNow:(NSString *)timeKind{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeKind];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier];
    NSString *locationString=[formatter stringFromDate: [NSDate date]];
    return locationString;
}
/**
 *  获取给定时间的前一天和后一天
 */
+(NSString*)getTimeDateFromeData:(NSString *)data dataKinds:(int)kind
{
    NSString *dateString = StringFromInteger(data);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kTimeFormatThree];
    NSDate *date = [formatter dateFromString:dateString];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:date];
    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:date];
    if(kind == 1){
        return [formatter stringFromDate:tomorrow];
    }else{
       return [formatter stringFromDate:yesterday];
    }
}

//获得当前时间的前几天，几个月的日期
+(NSString*)getbeforDateFromeCurrentTime:(NSInteger)beforMonths BeforDays:(NSInteger)beforDay{
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kTimeFormatTow];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:beforMonths];
    [adcomps setDay:beforDay];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    return beforDate;
}

+(NSString *)getWeekday{
    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:IOS_VERSION_8_OR_ABOVE ? NSCalendarUnitWeekday : NSWeekdayCalendarUnit fromDate:date];
    NSString *weekday = [self getWeekdayWithNumber:[componets weekday]];
    return weekday;
}

//1代表星期日、如此类推
+(NSString *)getWeekdayWithNumber:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}

/*时间戳 转时间*/
+ (NSString *)getTimeDateFrome:(NSString*)data timeKinds:(NSString*)kind{
    data = StringFromInteger(data);
    if(data.length>10){
        data = [data substringToIndex:10];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[data longLongValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kind];
    NSString * dateString = [formatter stringFromDate:confromTimesp];
    return dateString;
    
}

/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

/**
 *  仿QQ空间时间显示
 *  @param string eg:2015年5月24日 02时21分30秒
 */
+ (NSString *)format:(NSString *)string{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
    //CTHLog(@"startDate= %@", inputDate);
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    NSString *str= [outputFormatter stringFromDate:inputDate];
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:str];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
    //CTHLog(@"endDate:%@",endDate);
    NSString *lastTime = [self compareDate:endDate];
    PCLog(@"lastTime = %@",lastTime);
    return lastTime;
}

+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //CTHLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
    
}

/**
 *  获取当前时间戳
 *  13位精确到毫秒*1000，不乘就是精确到秒
 *  eg:1485065812018
 */
+ (NSString *)getCurrentTheTimestamp{
    NSDate * date             = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp  = [date timeIntervalSince1970];
    NSString * timeString     = [NSString stringWithFormat:@"%.0f", timestamp];
    //注：不想有小数点用%.0f​就OK啦
    return timeString;
}

#pragma mark - 时间比较大小
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //oneDay > anotherDay
        return 1;
    }
    else if (result == NSOrderedAscending){
        //oneDay < anotherDay
        return -1;
    }
    //oneDay = anotherDay
    return 0;
}

@end
