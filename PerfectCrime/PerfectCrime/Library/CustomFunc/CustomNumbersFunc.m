//
//  CustomNumbersFunc.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-26.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomNumbersFunc.h"

@implementation CustomNumbersFunc
#pragma mark - Leap year check

+ (BOOL)isLeapGivenYear:(NSUInteger)givenYear
{
	NSAssert(givenYear > 0 && givenYear <= 9999, @"Plz enter another year from 0001 - 100000 range");
    
	NSUInteger remainder_4, remainder_100, remainder_400;
	remainder_4 = givenYear % 4;
	remainder_100 = givenYear % 100;
	remainder_400 = givenYear % 400;
    
	return ((remainder_4 == 0 && remainder_100 != 0) || remainder_400 == 0) ? YES : NO;
}
@end
