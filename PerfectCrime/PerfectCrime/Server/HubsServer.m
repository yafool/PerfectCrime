//
//  HubsServer.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "HubsServer.h"

@implementation HubsServer

@synthesize delegate = _delegate;

-(void)onSortArray:(NSArray *) m_ary andType:(PlayerSortType)type{
    if (_delegate && [_delegate respondsToSelector:@selector(playerSortArray: andType:)])
    {
        [_delegate playerSortArray:m_ary andType:(PlayerSortType)type];
    }
}

-(void)onMakeFriend:(NSDictionary*)m_dict{
    if (_delegate && [_delegate respondsToSelector:@selector(alreadyInvited:)])
    {
        [_delegate alreadyInvited:m_dict];
    }
}

-(void)onDragBlackList:(NSDictionary*)m_dict{
    if (_delegate && [_delegate respondsToSelector:@selector(blackList:)])
    {
        [_delegate blackList:m_dict];
    }
}


-(void)requestSortWithType:(PlayerSortType)type andPage:(NSInteger)page{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
    [postDict setValue:[NSString stringWithFormat: @"%ld", type] forKey:@"type"];
    [postDict setValue:[NSString stringWithFormat: @"%ld", page] forKey:@"pageNo"];
    [postDict setValue:@"20" forKey:@"pageSize"];
    [postDict setValue:@"20" forKey:@"userId"];
    
    // 生活首页服务地址
    [HYBNetworking updateBaseUrl:UserUrl];
    
    
    [HYBNetworking postWithUrl:@"murder/room/getUserSort" refreshCache:NO params:postDict success:^(id response) {
        if (!response) {
            [MBProgressHUD showErrorMessage:@"请求不到数据！"];
            return;
        }
        NSDictionary *respDict = [[NSDictionary alloc]initWithDictionary:response];
        NSString *code = [respDict valueForKey:@"code"];
        NSString *msg = [respDict valueForKey:@"msg"];
        if(200 == [code integerValue]){
            NSArray *ary = [respDict valueForKey:@"data"];
            [self onSortArray:ary andType:type];
        }else{
            PCLog(@"getUserSort: code=%@; msg=%@", code, msg);
            [MBProgressHUD showErrorMessage:msg];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络请求失败"];
    }];
}

-(void)makeFriend:(NSMutableDictionary*)m_dict{
    
}

-(void)drag2Blacklist:(NSMutableDictionary*)m_dict{
    
}
@end

