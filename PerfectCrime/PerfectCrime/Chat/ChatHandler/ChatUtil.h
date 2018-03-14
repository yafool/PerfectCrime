//
//  ChatUtil.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatModel,ChatAlbumModel;

@interface ChatUtil : NSObject

//消息高度计算
+ (CGFloat)heightForMessage:(ChatModel *)currentChatmodel premodel:(ChatModel *)premodel;

//初始化文本消息模型
+ (ChatModel *)initTextMessage:(NSString *)text config:(ChatModel *)config;
//初始化语音消息模型
+ (ChatModel *)initAudioMessage:(ChatAlbumModel *)audio config:(ChatModel *)config;
//初始化图片消息模型
+ (NSArray<ChatModel *> *)initPicMessage:(NSArray<ChatAlbumModel *> *)pics config:(ChatModel *)config;
//初始化视频消息模型
+ (ChatModel *)initVideoMessage:(ChatAlbumModel *)video config:(ChatModel *)config;

+ (NSString*)chatMode2NSString:(ChatModel *)chatModel;
+ (ChatModel*)string2ChatModel:(NSString *)message;

@end
