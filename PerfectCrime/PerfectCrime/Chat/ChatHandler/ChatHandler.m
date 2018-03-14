//
//  ChatHandler.m
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "ChatHandler.h"
#import "ChatModel.h"
#import "MJExtension.h"
#import "ChatUtil.h"

//自动重连次数
NSInteger autoConnectCount = TCP_AutoConnectCount;

@interface ChatHandler ()
{
    NSString *topic;
}
//所有的代理
@property (nonatomic, strong) NSMutableArray *delegates;
    
@end

@implementation ChatHandler


#pragma mark - 初始化聊天handler单例
+ (instancetype)shareInstance
{
    static ChatHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[ChatHandler alloc]init];
    });
    return handler;
}

- (instancetype)init
{
    if (self = [super init]) {
        /*
         消息分类
         */
        [MQTTManager share].messageBlock = ^(NSString * msg){
            #warning  - 注意 ...
            //此处可以进行本地数据库存储,具体的就不多解释 , 通常来讲 , 每个登录用户创建一个DB ,每个DB对应3张表足够 ,一张用于存储聊天列表页 , 一张用于会话聊天记录存储,还有一张用于好友列表/群列表的本地化存储. 但是注意的一点 , 必须设置自增ID . 此外,个人建议预留出10个或者20个字段以备将来增加需求,或者使用数据库升级亦可
            
            //进行回执服务器,告知服务器已经收到该条消息(实际上是可以解决消息丢失问题 , 因为心跳频率以及网络始终是有一定延迟,当你断开的一瞬间,服务器并没有办法非常及时的获取你的连接状态,所以进行双向回执会更加安全,服务器推向客户端一条消息,客户端未进行回执的话,服务器可以将此条消息设置为离线消息,再次进行推送)
            
            //消息分发,将消息发送至每个注册的Object中 , 进行相应的布局等操作
            NSMutableDictionary * msgDict = [msg objectFromJSONString];
            PCLog(@"收到服务端消息:%@  转换为字典：%@", msg, msgDict);
            if ([[msgDict allKeys]  containsObject: @"action"]) {// 事件类型
                for (int i=0; i<self.delegates.count; i++) {
                    if ([self.delegates[i] respondsToSelector:@selector(didReceiveEventMessage:)]) {
                        [self.delegates[i] didReceiveEventMessage:msgDict];
                    }
                }
            } else {//聊天内容 文字 图片 音频 视频
                
                ChatModel *reply = [ChatUtil string2ChatModel:msg];
                
                for (id<ChatHandlerDelegate>delegate in self.delegates) {
                    if ([delegate respondsToSelector:@selector(didReceiveChatMessage:)]) {
                        [delegate didReceiveChatMessage:reply];
                    }
                }
            }
        };
        
    }
    return self;
}

- (NSMutableArray *)delegates
{
    
    if (!_delegates) {
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

#pragma mark - 添加代理
- (void)addDelegate:(id<ChatHandlerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue
{
    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}
    
    
    
#pragma mark - 移除代理
- (void)removeDelegate:(id<ChatHandlerDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}
#pragma mark - 移除全部代理
- (void)removeAllDelegate{
    [self.delegates removeAllObjects];
}

#pragma mark - 连接服务器端口
- (void)connectServer:(NSString*)roomId
{
    topic = roomId;
    NSString* userId = [SettingsManager sharedSettingsManager].userId;
    [[MQTTManager share]connect:userId andTopic:topic];
}



#pragma mark - 发送消息
- (void)sendMessage:(ChatModel *)chatModel andHomeID:(NSString*)homeId timeOut:(NSUInteger)timeOut tag:(long)tag
{
    //将模型转换为json字符串
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [chatModel.mj_keyValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        if (key && obj) {
//            [dict setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
//        }
//    }];
    NSString * messageJson = [ChatUtil chatMode2NSString:chatModel];
    
    //NSString *messageJson = chatModel.mj_JSONString;
    
    //NSString *messageJson = [chatModel.keyValues JSONString];
    
    //以"\n"分割此条消息 , 支持的分割方式有很多种例如\r\n、\r、\n、空字符串,不支持自定义分隔符,具体的需要和服务器协商分包方式 , 这里以\n分包
    /*
     如不进行分包,那么服务器如果在短时间里收到多条消息 , 那么就会出现粘包的现象 , 无法识别哪些数据为单独的一条消息 .
     对于普通文本消息来讲 , 这里的处理已经基本上足够 . 但是如果是图片进行了分割发送,就会形成多个包 , 那么这里的做法就显得并不健全,严谨来讲,应该设置包头,把该条消息的外信息放置于包头中,例如图片信息,该包长度等,服务器收到后,进行相应的分包,拼接处理.
     */
    
    //写入数据
    [[MQTTManager share]sendMsg:messageJson andTopic:topic];
    
}


#pragma mark - 主动断开连接
- (void)executeDisconnectServer
{
    [self disconnect];
}

#pragma mark - 连接中断
- (void)serverInterruption
{
    [self disconnect];
}

- (void)disconnect
{
    //断开连接
    [[MQTTManager share] disConnect];
}


#pragma mark - 消息发送
// 发送 “事件类型--动作触发”
- (void)sendHandleEvent:(NSDictionary *)eventDict
{
    NSString * messageJson = [eventDict JSONString];
    //写入数据
    [[MQTTManager share]sendMsg:messageJson andTopic:topic];
}
//发送文本消息
- (void)sendTextMessage:(ChatModel *)textModel
{
    [self sendMessage:textModel andHomeID:topic timeOut:15000 tag:ChatMessageContentType_Text];
}

//发送语音消息
- (void)sendAudioMessage:(ChatModel *)audioModel
{
    //TO-DO
}

//发送图片消息
- (void)sendPicMessage:(NSArray<ChatModel *>*)picModels
{
    //TO-DO
}

//发送视频消息
- (void)sendVideoMessage:(ChatModel *)videoModel
{
    //TO-DO
}


@end
