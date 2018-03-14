//
//  ChatHandler.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTManager.h"
#import "ChatModel.h"

@protocol ChatHandlerDelegate <NSObject>

@required
//接收消息代理
- (void)didReceiveEventMessage:(id)data;
@optional
//接收消息代理
- (void)didReceiveChatMessage:(ChatModel *)chatModel;

//发送消息超时代理
- (void)sendMessageTimeOutWithTag:(long)tag;

@end

@interface ChatHandler : NSObject


//聊天单例
+ (instancetype)shareInstance;
//连接服务器端口
- (void)connectServer:(NSString*)roomId;
//主动断开连接
- (void)executeDisconnectServer;
//添加代理
- (void)addDelegate:(id<ChatHandlerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;
//移除代理
- (void)removeDelegate:(id<ChatHandlerDelegate>)delegate;
- (void)removeAllDelegate;

// 发送 “事件类型--动作触发”
- (void)sendHandleEvent:(NSDictionary *)eventDict;

//发送文本消息
- (void)sendTextMessage:(ChatModel *)textModel;

//发送语音消息
- (void)sendAudioMessage:(ChatModel *)audioModel;

//发送图片消息
- (void)sendPicMessage:(NSArray<ChatModel *>*)picModels;

//发送视频消息
- (void)sendVideoMessage:(ChatModel *)videoModel;

@end
