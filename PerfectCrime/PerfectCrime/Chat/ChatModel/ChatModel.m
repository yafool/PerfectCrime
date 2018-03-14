//
//  ChatModel.m
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (instancetype)init
{
    if (self = [super init]) {
        self.sendTime = getSendTime();
    }
    return self;
}

NS_INLINE NSString *getSendTime() {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%llu",recordTime];
}

@end


@implementation ChatContentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}




@end
