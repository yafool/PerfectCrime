//
//  CustomArrayFunc.h
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-26.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
/*************************************************
 *类注释*
 *<p>Title:数组扩展方法</p>
 *<p>Description: 跟数组有关的方法</p>
 *@author:徐海缘
 *@version目前项目的版本号，默认为1.0
 **************************************************/
@interface CustomArrayFunc : NSObject
// 获取数组中最大元素的，索引
+ (NSUInteger)indexOfMaximumElementInArray:(NSArray *)array;

// 在一个存储字符串的数组当中找出最长的字符串。
+ (NSString *)longestStringInArray:(NSMutableArray *)array;

// 在一个存储字符串的数组当中找出最短的字符串。
+ (NSString *)shortestStringInArray:(NSMutableArray *)array;

// 数组逆置， 将传进来的数组 逆向排列 例如[1,2,3,4,5] 返回为[5,4,3,2,1];
+ (NSMutableArray *)reversedArrayWithArray:(NSMutableArray *)arrayToReverse;

// 获取两个数组的交集.
+ (NSArray *)intersectionOfArray:(NSArray *)firstArray withArray:(NSArray *)secondArray;

// 获取两个数组的并集。
+ (NSArray *)unionWithoutDuplicatesOfArray:(NSArray *)firstArray withArray:(NSArray *)secondArray;

// 检测数组中是否包含相同元素。
+ (BOOL)findDuplicatesInArray:(NSArray *)givenArray;

// 线性搜索 数组中是否包含 这个object 包含则返回 其在数组中的下标 否则返回-1
+ (NSInteger)indexOfObjectViaLinearSearch:(id)object inArray:(NSArray *)arrayToSearch;

// 二分法搜索 数组中是否包含这个object 包含则返回 其在数组中的下标 否则返回-1
+ (NSInteger)indexOfObjectViaBinarySearch:(id)object inSortedArray:(NSArray *)sortedArray;

// 冒泡排序 从小到大
+ (NSMutableArray *)bubbleSortedArrayWithUnsortedArray:(NSMutableArray *)unsortedArray;

// 快速排序  范围排序 左右下标 内排序
+ (NSMutableArray *)quickSortedArrayWithUnsortedArray:(NSMutableArray *)unsortedArray
                                        withLeftIndex:(NSInteger)left
                                       withRightIndex:(NSInteger)right;
// 判断数组为空
+(BOOL)isBlankArray:(NSArray *)theArray;

//用户权限 1.允许登录 2.报表 4.员工 8.退款
+(BOOL)isHaseAuthority:(int)code;

@end
