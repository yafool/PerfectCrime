//
//  HomeServer.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HomeServerID) {
    // 房间列表
    HomeServerIDhomeList = 0,
    // 创建房间
    HomeServerIDhomeCreate,
    // 进入房间
    HomeServerIDhomeEnter,
    // 离开房间
    HomeServerIDhomeExit,
    // 房间玩家信息
    HomeServerIDhomePlayers
};


@protocol HomeServerDelegate<NSObject>
-(void)responseWithServerID:(HomeServerID)requestid andResponse:(NSMutableDictionary *) response;
@end

@interface HomeServer : NSObject
{
    __unsafe_unretained id <HomeServerDelegate> _delegate;
}
@property (nonatomic,assign)id <HomeServerDelegate> delegate;

// 房间列表
-(void)requestHomeList:(NSDictionary *)dictionary;
// 创建房间
-(void)requestHomeCreate:(NSDictionary *)dictionary;
// 进入房间
-(void)requestHomeEnter:(NSDictionary *)dictionary;
// 离开房间
-(void)requestHomeExit:(NSDictionary *)dictionary;
// 房间玩家信息
-(void)requestHomePlayers:(NSDictionary *)dictionary;

@end

