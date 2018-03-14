//
//  CustomTextSizeFunc.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-23.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomTextSizeFunc.h"

@implementation CustomTextSizeFunc
+ (CGSize)getSizeOfText:(NSString*)_text font:(UIFont*)_font view:(UIView*)_views
{
    UIFont *font = _font;//跟label的字体大小一样
    CGSize size = CGSizeMake(_views.frame.size.width, MAXFLOAT);//跟label的宽设置一样
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[_text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}
//根据字体大小自动计算label大小
+(CGSize)calculateLabelSizeOfContent:(NSString*)text withFont:(UIFont*)font maxSize:(CGSize)aMaxSize defSize:(CGSize)DSize
{
    const CGSize defaultSize = DSize;
    if (text == nil || text.length == 0) {
        return defaultSize;
    }
    CGSize labelSize = CGSizeZero;
    if ([text isKindOfClass:[NSString class]]) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        labelSize = [text boundingRectWithSize:aMaxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        if (labelSize.height < defaultSize.height) {
            labelSize.height = defaultSize.height;
        }
    }
    return labelSize;
}
//根据字体大小自动计算label大小
+(CGRect)LabelSizeOfContent:(NSString*)text withFont:(UIFont*)font maxSize:(CGSize)aMaxSize
{
    CGRect labelRect = CGRectZero;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    labelRect = [text boundingRectWithSize:aMaxSize options:options attributes:attributes context:NULL];
    return labelRect;
}
@end
