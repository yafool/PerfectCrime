//
//  ConfirmAppearance.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/24.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "ConfirmAppearance.h"

@interface ConfirmAppearance()
{
    NSMutableDictionary *confirmDict;
    NSString            *input_pwd;
}
@end

@implementation ConfirmAppearance

-(void)initConfirm:(NSDictionary*)m_dict{
    confirmDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    input_pwd = nil;
}

-(NSString*)getHomeName{
    if (confirmDict) {
        return [confirmDict valueForKey:@"roomName"];
    } else {
        return nil;
    }
}

-(void)setInputPwd:(NSString*)pwd{
    input_pwd = pwd;
}

-(BOOL)isConfirm{
    NSString * passwd = [confirmDict valueForKey:@"passwd"];
    return (input_pwd && [input_pwd isEqualToString:passwd]);
}
@end
