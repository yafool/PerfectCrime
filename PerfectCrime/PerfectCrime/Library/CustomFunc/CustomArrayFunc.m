//
//  CustomArrayFunc.m
//  TestWebApp
//
//  Created by wangxiaoqin on 14-6-26.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomArrayFunc.h"

@implementation CustomArrayFunc
#pragma mark - Max element in array

+ (NSUInteger)indexOfMaximumElementInArray:(NSArray *)array
{
	id max = [array objectAtIndex:0];
	
	for (NSUInteger i = 1; i < [array count]; i++) {
		if ([array objectAtIndex:i] > max) {
			max = [array objectAtIndex:i];
		}
	}
	
	return [array indexOfObject:max];
}

#pragma mark - Longest string in array

+ (NSString *)longestStringInArray:(NSMutableArray *)array
{
	NSString *returnValue = nil;
	
	for (NSString *string in array) {
		if (returnValue == nil || [string length] > [returnValue length]) {
			returnValue = string;
		}
	}
    
	return returnValue;
}

#pragma mark - Shortest string in array

+ (NSString *)shortestStringInArray:(NSMutableArray *)array
{
	NSString *returnValue = nil;
	
	for (NSString *string in array) {
		if (returnValue == nil || [string length] < [returnValue length]) {
			returnValue = string;
		}
	}
    
	return returnValue;
}

#pragma mark - Array reverse

+ (NSMutableArray *)reversedArrayWithArray:(NSMutableArray *)arrayToReverse
{
	NSMutableArray *reversedArray = [@[] mutableCopy];
    
	for (NSUInteger i = [arrayToReverse count] - 1; i <= [arrayToReverse count]; i--) {
		[reversedArray addObject:arrayToReverse[i]];
	}
    
	return [reversedArray copy];
}

#pragma mark - Intersection of two arrays

+ (NSArray *)intersectionOfArray:(NSArray *)firstArray withArray:(NSArray *)secondArray
{
    NSMutableSet *intersection = [NSMutableSet setWithArray:firstArray];
    [intersection intersectSet:[NSSet setWithArray:secondArray]];
    
    return [intersection allObjects];
}

#pragma mark - Union of two arrays

+ (NSArray *)unionWithoutDuplicatesOfArray:(NSArray *)firstArray withArray:(NSArray *)secondArray
{
	NSSet *firstSet = [NSSet setWithArray:firstArray];
	NSSet *secondSet = [NSSet setWithArray:secondArray];
    
	NSMutableSet *resultSet = [NSMutableSet setWithSet:firstSet];
	[resultSet unionSet:secondSet];
    
	return [resultSet allObjects];
}

#pragma mark - Find duplicates

+ (BOOL)findDuplicatesInArray:(NSArray *)givenArray
{
	for (NSUInteger i = 0; i < [givenArray count]; i++) {
		for (NSUInteger j = i + 1; j < [givenArray count]; j++) {
			if (i != j && givenArray[i] == givenArray[j]) {
				return YES;
			}
		}
	}
    
	return NO;
}

#pragma mark - Linear search

+ (NSInteger)indexOfObjectViaLinearSearch:(id)object inArray:(NSArray *)arrayToSearch
{
	NSInteger i = 0, indexOfFoundedObject = 0;
	
	for (i = 0; i < [arrayToSearch count]; i++) {
		if (object == [arrayToSearch objectAtIndex:i]) {
			indexOfFoundedObject = i;
			break;
		}
	}
	if (i == [arrayToSearch count]) {
		indexOfFoundedObject = -1;
	}
	
	return indexOfFoundedObject;
}

#pragma mark - Binary search

+ (NSInteger)indexOfObjectViaBinarySearch:(id)object inSortedArray:(NSArray *)sortedArray
{
	NSUInteger firstIndex = 0;
	NSUInteger uptoIndex = [sortedArray count];
	NSUInteger indexOfFoundedObject = 0;
	
	while (firstIndex < uptoIndex) {
		NSUInteger mid = (firstIndex + uptoIndex) / 2;
		if ([object isKindOfClass:[NSNumber class]]) {
			if ([object integerValue] < [[sortedArray objectAtIndex:mid] integerValue]) {
				uptoIndex = mid;
			}
			else if ([object integerValue] > [[sortedArray objectAtIndex:mid] integerValue]) {
				firstIndex = mid + 1;
			}
			else {
				return indexOfFoundedObject = mid;
			}
		}
	}
	
	return indexOfFoundedObject = -1;
}
#pragma mark - Bubble sort

+ (NSMutableArray *)bubbleSortedArrayWithUnsortedArray:(NSMutableArray *)unsortedArray
{
	id temp = nil;
	
	for (int i = (int)[unsortedArray count] - 2; i >= 0; i--) {
		for (int j = 0; j <= i; j++) {
			if ([unsortedArray[j] integerValue] > [unsortedArray[j + 1] integerValue]) {
				temp = [unsortedArray objectAtIndex:j];
				[unsortedArray replaceObjectAtIndex:j withObject:[unsortedArray objectAtIndex:j + 1]];
				[unsortedArray replaceObjectAtIndex:j + 1 withObject:temp];
			}
		}
	}
	
	return unsortedArray;
}
#pragma mark - Quick sort
+ (NSMutableArray *)quickSortedArrayWithUnsortedArray:(NSMutableArray *)unsortedArray withLeftIndex:(NSInteger)left withRightIndex:(NSInteger)right
{
	NSInteger i = 0, j = 0;
	id x = nil, y = nil;
	
	i = left;
	j = right;
	x = unsortedArray[(left + right) / 2];
	
	do {
		while (([unsortedArray[i] floatValue] < [x floatValue]) && (i < right)) {
			i++;
		}
		while (([x floatValue] < [unsortedArray[j] floatValue]) && (j > left)) {
			j--;
		}
		
		if (i <= j) {
			y = unsortedArray[i];
			[unsortedArray replaceObjectAtIndex:i withObject:unsortedArray[j]];
			unsortedArray[j] = y;
			i++;
			j--;
		}
	}
	while (i <= j);
	
	if (left < j) {
		[self quickSortedArrayWithUnsortedArray:unsortedArray withLeftIndex:left withRightIndex:j];
	}
	if (i < right) {
		[self quickSortedArrayWithUnsortedArray:unsortedArray withLeftIndex:i withRightIndex:right];
	}
	
	return unsortedArray;
}
+(BOOL)isBlankArray:(NSArray *)theArray
{
    if (theArray == nil||[theArray isEqual:[NSNull null]])
    {
        return YES;
    }
    if ([theArray isKindOfClass:[NSArray class]])
    {
        if ([theArray count] == 0)
        {
            return YES;
        }
    }
    return NO;
}


@end
