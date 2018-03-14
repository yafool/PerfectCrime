//
//  MQTTManager.m
//  Chat
//
//  Created by 刘亚夫 on 2017/7/6.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "MQTTManager.h"
#import "MQTTKit.h"
#import "MJExtension.h"


@interface MQTTManager()
{
    MQTTClient *client;
    
}
@end

@implementation MQTTManager
    
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static MQTTManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
    

- (void)connect:(NSString*)userId andTopic:(NSString*)topic
{
    if (client) {
        [self disConnect];
    }
    
    
    client = [[MQTTClient alloc] initWithClientId:userId];
    client.port = kIMPort;
    
    PCLog(@"connect: %@ andTopic: %@", userId, topic);
    [client connectToHost:kIMHost completionHandler:^(MQTTConnectionReturnCode code) {
        
        switch (code) {
            case ConnectionAccepted:{
                PCLog(@"MQTT连接成功");
                //订阅自己ID的消息，这样收到消息就能回调
                [client subscribe:topic withCompletionHandler:^(NSArray *grantedQos) {
                
                    PCLog(@"subscribe: %@ withCompletionHandler: %@", topic, grantedQos);
                }];
            
                break;
            }
            case ConnectionRefusedBadUserNameOrPassword:{
                PCLog(@"错误的用户名密码");
                break;
            }
            default:
                PCLog(@"MQTT连接失败");
            break;
        }
        
    }];
    
    __weak __typeof(self) weakSelf = self;
    [client setMessageHandler:^(MQTTMessage *message) {
        
        //收到消息的回调，前提是得先订阅
        NSString *msg = [message payloadString];

        PCLog(@"收到服务端消息：%@",msg);
        weakSelf.messageBlock(msg);

     }];
}


    
//断开连接
- (void)disConnect
{
    if (client) {
        //取消订阅
        [client unsubscribe:client.clientID withCompletionHandler:^{
            PCLog(@"取消订阅yafool成功");
            
        }];
        //断开连接
        [client disconnectWithCompletionHandler:^(NSUInteger code) {
            
            PCLog(@"断开MQTT成功");
            
        }];
        
        client = nil;
    }
}
    
//发送消息
- (void)sendMsg:(NSString *)msg andTopic:(NSString*)topic
{
    //发送一条消息，发送给自己订阅的主题
    [client publishString:msg toTopic:topic withQos:ExactlyOnce retain:YES completionHandler:^(int mid) {
        
    }];
}
    
@end
