//
//  NSString+extension.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/6.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


+ (CGSize)stringSizeWithContainer:(UIView *)container maxSize:(CGSize)maxSize;

@end
