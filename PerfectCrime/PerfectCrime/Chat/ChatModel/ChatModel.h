//
//  ChatModel.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger){
    
    ChatMessageContentType_Text       = 0<<0, //普通文本消息,表情..
    ChatMessageContentType_Audio      = 1<<0, //语音消息
    ChatMessageContentType_Picture    = 2<<0, //图片消息
    ChatMessageContentType_Video      = 3<<0, //视频消息
    ChatMessageContentType_File       = 4<<0 //文件消息
    
}ChatMessageContentType;

typedef NS_ENUM(NSInteger){
    
    ChatAreaType_dawn           = 1<<0, //天亮了依次发言
    ChatAreaType_dark           = 2<<0, //夜晚警匪交流
    ChatAreaType_onlookers      = 3<<0, //围观闲聊
    
}ChatAreaType;

@class ChatContentModel;

@interface ChatModel : NSObject

@property (nonatomic, copy) NSString *roomId; //房间ID

@property (nonatomic, copy) NSString *roomName; //房间名称

@property (nonatomic, copy) NSString *userId; //消息发送者ID

@property (nonatomic, copy) NSString *picUrl; //发送者头像url

@property (nonatomic, copy) NSString *picFrame; //发送者头像框

@property (nonatomic, copy) NSString *nickName; //昵称

@property (nonatomic, copy) NSString *contenType; //内容类型

@property (nonatomic, copy) NSString *deviceType; //设备类型

@property (nonatomic, copy) NSString *versionCode; //MQTT版本码

@property (nonatomic, copy) NSString *sendTime; //时间戳

@property (nonatomic, strong) ChatContentModel *content; //内容

@property (nonatomic, assign) ChatAreaType chatArea; //闲聊区

@property (nonatomic, assign) BOOL isSending; //是否正在发送中

@property (nonatomic, assign) BOOL byMyself; //消息是否为本人所发

@property (nonatomic, assign) BOOL isSend;  //是否已经发送成功

@property (nonatomic, strong) NSNumber *progress; //进度

#pragma mark - chatlist独有部分
@property (nonatomic, copy) NSString *lastMessage; //最后一条消息
@property (nonatomic, copy) NSString *lastTimeString; //最后一条消息时间

#pragma mark - 额外需要部分属性
@property (nonatomic , assign) CGFloat messageHeight; //消息高度
@property (nonatomic, assign,getter=shouldShowTime) BOOL showTime; // 是否展示时间

@end


@interface ChatContentModel :NSObject

@property (nonatomic, copy) NSString *text; //文本

@property (nonatomic, assign) CGSize picSize; //图片尺寸

@property (nonatomic, strong) NSString *seconds; //时长

@property (nonatomic, copy) NSString *fileName; //文件名

@property (nonatomic, strong) NSNumber *videoDuration; //语音时长

@property (nonatomic, copy) NSString *videoSize;  //视频大小

@property (nonatomic, copy) NSString *bigPicAdress; //图片大图地址

@property (nonatomic, strong) NSString *fileSize; //文件大小

@property (nonatomic, copy) NSString *fileType; //文件类型

@property (nonatomic, copy) NSString *fileIconAdress; //文件缩略图地址

@end
