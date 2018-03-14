//
//  AccountServer.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "AccountServer.h"
#include "EditNickView.h"

@implementation AccountServer

@synthesize delegate = _delegate;

-(void)onCologin:(NSDictionary*)m_dict{
    if (_delegate && [_delegate respondsToSelector:@selector(responseCologin:)])
    {
        [_delegate responseCologin:m_dict];
    }
}

-(void)onModify:(NSDictionary*)m_dict{
    if (_delegate && [_delegate respondsToSelector:@selector(responseModify:)])
    {
        [_delegate responseModify:m_dict];
    }
}

-(void)onUserInfo:(NSDictionary*)m_dict{
    if (_delegate && [_delegate respondsToSelector:@selector(responseUserInfo:)])
    {
        [_delegate responseUserInfo:m_dict];
    }
}

// 联合登陆
-(void)requestCologin:(NSDictionary*)m_dict{
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:UserUrl];
    
    [HYBNetworking postWithUrl:@"/murder/user/login" refreshCache:NO params:postDict success:^(id response) {
        if (!response) {
            [MBProgressHUD showErrorMessage:@"请求不到数据！"];
            return;
        }
        
        NSMutableDictionary *respDict = [[NSMutableDictionary alloc]initWithDictionary:response];
        NSString *code = [[respDict allKeys]containsObject: @"code"]?[respDict valueForKey:@"code"]:[respDict valueForKey:@"errno"];
        NSString *msg = [respDict valueForKey:@"msg"];
        if(200 == [code integerValue]){
            [respDict addEntriesFromDictionary:m_dict];
            [self onCologin:respDict];
        } else if (-2 == [code integerValue]){// 昵称重复
            [EditNickView showWithRegister:m_dict andSucessBlock:^(NSDictionary* userDict){
                [self onCologin:userDict];
            } andCancelBlock:^(void){
                [MBProgressHUD showErrorMessage:@"昵称重复缘故，用户放弃登陆"];
            }];
        }else{
            PCLog(@"getUserSort: code=%@; msg=%@", code, msg);
            [MBProgressHUD showErrorMessage:msg];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];

}
// 修改头像或昵称
-(void)requestModify:(NSDictionary*)m_dict{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:UserUrl];
    
    [HYBNetworking postWithUrl:@"/murder/user/updateUserInfo" refreshCache:NO params:postDict success:^(id response) {
        if (!response) {
            [MBProgressHUD showErrorMessage:@"请求不到数据！"];
            return;
        }
        
        NSMutableDictionary *respDict = [[NSMutableDictionary alloc]initWithDictionary:response];
        NSString *code = [respDict valueForKey:@"code"];
        NSString *msg = [respDict valueForKey:@"msg"];
        if(200 == [code integerValue]){
            [respDict addEntriesFromDictionary:m_dict];
            [self onModify:respDict];
        }else{
            PCLog(@"getUserSort: code=%@; msg=%@", code, msg);
            [MBProgressHUD showErrorMessage:msg];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}
//获取用户信息
-(void)requestGetUserInfo:(NSDictionary*)m_dict{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:UserUrl];
    
    [HYBNetworking postWithUrl:@"/murder/user/getUserInfo" refreshCache:NO params:postDict success:^(id response) {
        if (!response) {
            [MBProgressHUD showErrorMessage:@"请求不到数据！"];
            return;
        }
        
        NSMutableDictionary *respDict = [[NSMutableDictionary alloc]initWithDictionary:response];
        NSString *code = [respDict valueForKey:@"code"];
        NSString *msg = [respDict valueForKey:@"msg"];
        if(200 == [code integerValue]){
            [self onModify:respDict];
        }else{
            PCLog(@"getUserSort: code=%@; msg=%@", code, msg);
            [MBProgressHUD showErrorMessage:msg];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}
@end
