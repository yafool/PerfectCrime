//
//  CustomStringFunc.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-25.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomStringFunc.h"

@implementation CustomStringFunc

+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

+ (BOOL)checkTel:(NSString *)str
{
    //手机号以13，14， 15，17，18开头，九个 \d 数字字符
    NSString *regex = @"^13[0-9]{9}|15[012356789][0-9]{8}|18[0-9]{9}|14[579][0-9]{8}|17[0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkEnterPrice:(NSString *)str
{
    NSString *regex = @"^([0-9]{1}\\d*)(\\.\\d{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    //手机号以13，14， 15，17，18开头，九个 \d 数字字符
    NSString *phoneRegex = @"^[1][34578][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}

+(BOOL) isEmailAddress:(NSString*)email
{
    
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+(BOOL)isIncludeSpecialCharact: (NSString *)str
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isIncludeChineseInString:(NSString*)str
{
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

//判断字符串是否为空或者空格或者类型不符
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]])
    {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
        {
            return YES;
        }
        if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@""] || string.length <= 0)
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL) validateZip: (NSString *) candidate
{
    NSString *ZipRegex = @"[0-9]\\d{5}(?!\\d)";
    NSPredicate *ZipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZipRegex];
    return [ZipTest evaluateWithObject:candidate];
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPodTouch1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPadMini1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPadMini1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPadMini1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPadMini2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPadMini2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPadMini2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPadMini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPadMini3";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    
    return platform;
}

/*ios去掉字符串中的html标签的方法*/
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

/*首行缩进的lable*/
+(NSMutableAttributedString*)getLableFrome:(NSString*)contentText lb_font:(UIFont*)lbfont firstLineIndent:(float)firstIndent{

    //富文本的基本数据类型，属性字符串。以此为基础，如果这个设置了相应的属性，则会忽略上面设置的属性，默认为空
    NSString *string = [NSString stringWithFormat:@"%@",contentText];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger length = [string length];
    //设置字体
    [attrString addAttribute:NSFontAttributeName value:lbfont range:NSMakeRange(0, length)];//设置所有的字体
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 10;//增加行高
    style.lineHeightMultiple = 0.5;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = firstIndent;//首行头缩进
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    
    return attrString;
}

/*手机号码中间位置用****代替*/
+(NSString*)hidePhone:(NSString*)phoneStr
{
    if([CustomStringFunc isBlankString:phoneStr]){
       return @"";
    }else{
        NSRange range = NSMakeRange (3,4);
        NSString*newPhone = [phoneStr stringByReplacingCharactersInRange:range withString:@"****"];
        return newPhone;
    }
}

/*
 *根据传入的字段还回字符串
 */
+ (NSString*)getRequestUrlWithFromDict:(NSDictionary*)_Key_Vaule
{    @synchronized (self)
    {
        if (_Key_Vaule.count == 0) {
            return @"";
        }
        
        NSArray * keyArray = [_Key_Vaule allKeys];
        NSArray * vauleArray = [_Key_Vaule allValues];
        NSMutableArray * newArray =[[NSMutableArray alloc]init];
        NSMutableString * urlBodyStr = [[NSMutableString alloc]initWithString:@""];
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

/*字符串转换成16进制*/
+ (NSString *) stringToHex:(NSString *)str{
    
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString ;
}

/*16进制转换成字符串*/
+ (NSString *) stringFromHex:(NSString *)str{
    
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}

/*!
 @abstract NSString类型UTF8Encoding（包含特殊字符）
 */
+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str,NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if(result)
        return result;
    return @"";
}

/*!
 @abstract UTF8Encoding类型转NSString（包含特殊字符）
 */
+ (NSString*)URLDecodedString:(NSString *)str
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)str,CFSTR(""),kCFStringEncodingUTF8);
    if(result)
        return result;
    return @"";
}

/*!
 @abstract 判断文字是否包含Emoji表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//检查是否有标题
+(BOOL)checkMenuListArryIsExistTitle:(NSArray*)m_arry{
    __block BOOL isHase = NO;
    [m_arry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(idx > 0){
            NSDictionary * dict = (NSDictionary*)obj;
            NSString * keyStr   = StringFromInteger([dict valueForKey:@"title"]);
            if(![self isBlankString:keyStr]){
                isHase = YES;
            }
        }
        
    }];
    return isHase;
}
//检查是否有价格
+(BOOL)checkMenuListArryIsExistPrice:(NSArray*)m_arry{
    __block BOOL isHase = NO;
    [m_arry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(idx > 0){
            NSDictionary * dict = (NSDictionary*)obj;
            NSString * keyStr   = StringFromInteger([dict valueForKey:@"price"]);
            if(![self isBlankString:keyStr]){
                isHase = YES;
            }
        }
        
    }];
    return isHase;
}
+(BOOL)checkMenuArry:(NSMutableArray*)m_arry IsExist:(NSString*)menuType{
    __block BOOL isHase = NO;
    [m_arry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * dict = (NSDictionary*)obj;
        NSString * keyStr   = StringFromInteger([dict valueForKey:@"widget_id"]);
        if([keyStr isEqualToString:menuType]){
            isHase = YES;
        }
    }];
    return isHase;
}

+(NSInteger)objectIndexInMenuArry:(NSMutableArray*)m_arry IsExist:(NSString*)menuType{
    __block NSInteger objectIndex = 0;
    [m_arry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * dict = (NSDictionary*)obj;
        NSString * keyStr   = StringFromInteger([dict valueForKey:@"widget_id"]);
        if([keyStr isEqualToString:menuType]){
            objectIndex = idx;
        }
    }];
    return objectIndex;
}

//判断16进制颜色值是否为空或者空格或者类型不符
+(BOOL)isTextCokorString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]])
    {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
        {
            return YES;
        }
        if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@""] || string.length <= 0)
        {
            return YES;
        }
        if(string.length < 7 || string.length > 7){
            return YES;
        }
    }
    return NO;
}

//通过图片Data数据第一个字节 来获取图片扩展名
+(NSString*)getPictureKinds:(NSString*)picSource{
    //假设这是一个网络获取的URL
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picSource]];
    //调用获取图片扩展名
    NSString *string = [self contentTypeForImageData:data];
    //输出结果为 png
    PCLog(@"%@",string);
    return string;
}

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

//去掉字符串中的某个字符串
+(NSString*)replacingStringBy:(NSString*)byString deletStr:(NSString*)DStr{
    byString = [byString stringByReplacingOccurrencesOfString:DStr withString:@""];
    return byString;
}

//判断字符串是否包含非法字符
+ (BOOL)isHaveIllegalChar:(NSString *)str{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    NSRange range = [str rangeOfCharacterFromSet:doNotWant];
    if(range.location == NSNotFound){
        return NO;
    }
    return YES;
}

//判断URL是否为空
+(BOOL)isCheckUrlCanUse:(NSURL *)url
{
    if (url == nil || url == NULL) {
        return YES;
    }
    if ([url isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}


@end
