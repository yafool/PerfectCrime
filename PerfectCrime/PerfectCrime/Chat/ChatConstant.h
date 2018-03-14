//
//  ChatConstant.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#ifndef ChatConstant_h
#define ChatConstant_h


/*
 设备
 */
static NSString *DeviceType                = @"iOS";    //设备类型

/*
 消息内容类型
 */
static NSString *Content_Text            = @"text";   //文本,表情消息
static NSString *Content_Audio          = @"audio";   //语音消息
static NSString *Content_Picture        = @"picture";   //图片消息
static NSString *Content_Video          = @"video";   //视频消息
static NSString *Content_File             = @"file";   //文件消息
static NSString *Content_Tip             = @"tip";   //提示消息(欢迎XX加入群 , XX撤回了一条消息等)


/*
 标题
 */
static NSString *ChatlistTitle           = @"聊天列表";   //聊天列表标题

/*
 聊天通知
 */
static NSString *ChatKeyboardResign = @"ChatKeyboardShouldResignFirstResponder"; //键盘失去第一响应者


/*
 enum
 */

//长按消息操作类型
typedef NS_ENUM(NSInteger,LongpressSelectHandleType){
    LongpressSelectHandleTypeBack     =  0<<0, //撤回
    LongpressSelectHandleTypeDelete   =  1<<0, //删除
    LongpressSelectHandleTypeTransmit =  2<<0  //转发
};


#endif /* ChatConstant_h */
