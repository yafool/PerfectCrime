//
//  HomeServer.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "HomeServer.h"

@implementation HomeServer

@synthesize delegate = _delegate;

-(void)onResponsServer:(HomeServerID)enginer_id andResponse:(NSMutableDictionary *) response{
    if (_delegate && [_delegate respondsToSelector:@selector(responseWithServerID: andResponse:)])
    {
        [_delegate responseWithServerID:enginer_id andResponse:response];
    }
}

// 房间列表
-(void)requestHomeList:(NSDictionary *)dictionary{
    [MBProgressHUD showInfoMessage:@"加载中..."];
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:HomeUrl];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
    [postDict setValue:@"9" forKey:@"pageSize"];
    [postDict setValue:@"1" forKey:@"pageNo"];
    [HYBNetworking postWithUrl:@"/murder/room/getRoomList" refreshCache:NO params:postDict success:^(id response) {
        [self onResponsServer:HomeServerIDhomeList andResponse:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
    
}
// 创建房间
-(void)requestHomeCreate:(NSDictionary *)dictionary{
    [MBProgressHUD showInfoMessage:@"加载中..."];
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:HomeUrl];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    
    [HYBNetworking postWithUrl:@"/murder/room/addUserRoom" refreshCache:NO params:postDict success:^(id response) {
        [self onResponsServer:HomeServerIDhomeCreate andResponse:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}
// 进入房间
-(void)requestHomeEnter:(NSDictionary *)dictionary{
    [MBProgressHUD showInfoMessage:@"加载中..."];
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:HomeUrl];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    
    [HYBNetworking postWithUrl:@"/murder/room/userEnterRoom" refreshCache:NO params:postDict success:^(id response) {
        [self onResponsServer:HomeServerIDhomeEnter andResponse:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}
// 离开房间
-(void)requestHomeExit:(NSDictionary *)dictionary{
    [MBProgressHUD showInfoMessage:@"加载中..."];
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:HomeUrl];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    
    [HYBNetworking postWithUrl:@"/murder/room/leaveRoom" refreshCache:NO params:postDict success:^(id response) {
        [self onResponsServer:HomeServerIDhomeExit andResponse:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}
// 房间玩家信息
-(void)requestHomePlayers:(NSDictionary *)dictionary{
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:HomeUrl];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    
    [HYBNetworking postWithUrl:@"/murder/room/getRoomUsers" refreshCache:NO params:postDict success:^(id response) {
        [self onResponsServer:HomeServerIDhomePlayers andResponse:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}

@end
