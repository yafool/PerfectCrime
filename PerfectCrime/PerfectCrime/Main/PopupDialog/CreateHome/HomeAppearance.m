//
//  PlayerAppearance.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "HomeAppearance.h"
@interface HomeAppearance()
{
    NSMutableDictionary *speedDict;
    NSMutableDictionary *gradeDict;
    /** 用户id*/
    NSString *userId;
    /** 房间名*/
    NSString *name ;
    /** 等级*/
    NSString *grade;
    /** 房速*/
    NSString *speed;
    /** 人数限制*/
    NSString *limit;
    /** mima*/
    NSString *passwd;
    /** 编辑内容是否有效*/
    BOOL createValid;
}
@end

@implementation HomeAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        speedDict = [[NSMutableDictionary alloc]init];
        [speedDict setValue:@"1" forKey:kHomeSpeed_quick];// 快速 == 1
        [speedDict setValue:@"2" forKey:kHomeSpeed_normal];// 中速 == 2
        [speedDict setValue:@"3" forKey:kHomeSpeed_slow];// 慢速 == 2
        
        gradeDict = [[NSMutableDictionary alloc]init];
        [gradeDict setValue:@"1" forKey:kHomeGrade_rookie];// 菜鸟 == 1
        [gradeDict setValue:@"2" forKey:kHomeGrade_master];// 高手 == 2
    }
    return self;
}

- (NSDictionary*)getHomeInfo{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:userId forKey:@"userId"];
    [dict setValue:name forKey:@"name"];
    [dict setValue:[gradeDict valueForKey:grade] forKey:@"grade"];    
    [dict setValue:[speedDict valueForKey:speed] forKey:@"speed"];
    [dict setValue:limit forKey:@"limit"];
    [dict setValue:passwd forKey:@"passwd"];
    
    return dict;
}

- (void)clearHomeInfo{
    [self setUserId:nil];
    [self setName:nil];
    [self setGrade:nil];
    [self setSpeed:nil];
    [self setLimit:nil];
    [self setPasswd:nil];
    [self setCreateValid:NO];
}

- (void)setUserId:(NSString*)str{
    userId = str;
}

- (void)setName:(NSString*)str{
    name = str;
}

- (void)setGrade:(NSString*)str{
    grade = str;
}

- (void)setSpeed:(NSString*)str{
    speed = str;
}

- (void)setLimit:(NSString*)str{
    limit = str;
}

- (void)setPasswd:(NSString*)str{
    passwd = str;
}

- (void)setCreateValid:(BOOL)valid{
    createValid = valid;
}

- (BOOL)isCreateValid{
    return createValid;
}

- (NSString*) speedKeyWithValue:(NSString*)value{
    if (!value) {
        PCLog(@"home speed is nil!");
        return kHomeSpeed_normal;
    }
    __block NSString* retKey = kHomeSpeed_normal;//默认为 正常
    [speedDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj && key) {
            NSString *str = [NSString stringWithFormat:@"%@", obj];
            if ([value isEqualToString:str] ) {
                retKey = [NSString stringWithFormat:@"%@", key];
                *stop = YES;
            }
        }
    }];
    
    return retKey;
}

- (NSString*) gradeKeyWithValue:(NSString*)value{
    if (!value) {
        PCLog(@"home grade is nil!");
        return kHomeGrade_rookie;
    }
    
    __block NSString* retKey = kHomeGrade_rookie;// 默认为菜鸟
    [gradeDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj && key) {
            NSString *str = [NSString stringWithFormat:@"%@", obj];
            if ([value isEqualToString:str] ) {
                retKey = [NSString stringWithFormat:@"%@", key];
                *stop = YES;
            }
        }
    }];
    
    return retKey;
}
@end
