//
//  ChatUtil.m
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "ChatUtil.h"
#import "ChatModel.h"
#import "ChatAlbumModel.h"
#import "MYCoreTextLabel.h"
#import "MJExtension.h"

@implementation ChatUtil

+ (void)shouldShowTime:(ChatModel *)currentmodel premodel:(ChatModel *)premodel
{
    if (!premodel) {
        currentmodel.showTime = !premodel;
    }
    //取最后两个时间戳比较时间
    NSInteger length = (currentmodel.sendTime.longLongValue-premodel.sendTime.longLongValue)/1000; //socket处时间戳多了三位
    
    if (length>60) {
        
        currentmodel.showTime = YES;
    }else{
        currentmodel.showTime = NO;
    }
}

#pragma mark - 消息高度计算
+ (CGFloat)heightForMessage:(ChatModel *)currentChatmodel premodel:(ChatModel *)premodel
{
    //是否显示时间
    [self shouldShowTime:currentChatmodel premodel:premodel];
    
    CGFloat height = 0.f;
    //文本,表情
    if (hashEqual(currentChatmodel.contenType, Content_Text)) {
        MYCoreTextLabel *coreLabel = [[MYCoreTextLabel alloc]init];
        coreLabel.textFont = [UIFont systemFontOfSize:14];
        coreLabel.lineSpacing = 6;
        coreLabel.imageSize =CGSizeMake(24, 24);
        [coreLabel setText:currentChatmodel.content.text customLinks:nil keywords:nil];
        CGSize labelSize = [coreLabel sizeThatFits:CGSizeMake(ViewFrame_bounds_width - 145, MAXFLOAT)];
        height = 5 + 10 + labelSize.height + 10;
        height = height < 50 ? 50 : height;
        //优化布局群聊
        currentChatmodel.messageHeight += 16;
        
        return currentChatmodel.messageHeight += currentChatmodel.shouldShowTime ? height + 50 : height + 15;
        //语音
    }else if (hashEqual(currentChatmodel.contenType, Content_Audio)){
        
        height = 50;
        //优化布局群聊
        currentChatmodel.messageHeight += 16;
        
        return currentChatmodel.messageHeight += currentChatmodel.shouldShowTime ? height + 50 : height + 15;
        //图片
    }else if (hashEqual(currentChatmodel.contenType, Content_Picture)){
        
        CGFloat picHeight = currentChatmodel.content.picSize.height;
        CGFloat picWidth  = currentChatmodel.content.picSize.width;
        //宽大于高
        if (picWidth > picHeight) {
            
            //极宽极低固定50高
            if (100*(picHeight/picWidth)<=50) {
                height = 50;
            }else{
                height = 135 *(picHeight/picWidth);
            }
            //宽小于高
        }else if (picWidth < picHeight){
            
            height = 130;
            //宽高相等
        }else{
            height = 120;
        }
        //优化布局群聊
        currentChatmodel.messageHeight += 16;
        
        return currentChatmodel.messageHeight += currentChatmodel.shouldShowTime ? height + 50 : height + 15;
        //视频
    }else if (hashEqual(currentChatmodel.contenType, Content_Video)){
        
        return currentChatmodel.messageHeight += currentChatmodel.shouldShowTime ? height + 50 : height + 15;
        //文件
    }else if (hashEqual(currentChatmodel.contenType, Content_File)){
        
        return currentChatmodel.messageHeight += currentChatmodel.shouldShowTime ? height + 50 : height + 15;
        //提示语
    }else{
        
        return currentChatmodel.messageHeight += currentChatmodel.shouldShowTime ? height + 50 : height + 15;
    }
}


#pragma marl - 创建发送消息模型
+ (ChatModel *)creatMessageModel:(ChatModel *)config
{
    ChatModel * chatModel = [[ChatModel alloc]init];
    ChatContentModel *content = [[ChatContentModel alloc]init];
    chatModel.content          = content;
    chatModel.userId     = config.userId;
    chatModel.deviceType     = @"iOS";
    chatModel.versionCode   = TCP_VersionCode;
    chatModel.chatArea      = config.chatArea;
    chatModel.byMyself      = YES;
    chatModel.isSend        = NO;
    chatModel.isSending     = YES;
    chatModel.picUrl    = config.picUrl;
    chatModel.picFrame  = config.picFrame;
    chatModel.nickName       = config.nickName;
    chatModel.roomId          = config.roomId;
    chatModel.roomName    = config.roomName;
    chatModel.progress    = config.progress;
    
    return chatModel;
}

//初始化文本消息模型
+ (ChatModel *)initTextMessage:(NSString *)text config:(ChatModel *)config
{
    ChatModel *textModel = [self creatMessageModel:config];
    textModel.contenType  = Content_Text;
    textModel.content.text  = text;
    return textModel;
}
//初始化语音消息模型
+ (ChatModel *)initAudioMessage:(ChatAlbumModel *)audio config:(ChatModel *)config
{
    ChatModel *audioModel = [self creatMessageModel:config];
    audioModel.contenType = Content_Audio;
    audioModel.content.seconds = audio.duration;
    NSString *name = [NSString stringWithFormat:@"ChatAudio_%@.mp3",audioModel.sendTime];
    audioModel.content.fileName = name;
    NSString *basePath = nil;
    basePath = [ChatCache_Path stringByAppendingPathComponent:config.roomId];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL exist = [manager fileExistsAtPath:basePath];
    if (!exist) {
        [manager createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    //语音写入缓存
    [audio.audioData writeToFile:[basePath stringByAppendingPathComponent:name] atomically:YES];
    return audioModel;
}
//初始化图片消息模型
+ (NSArray<ChatModel *> *)initPicMessage:(NSArray<ChatAlbumModel *> *)pics config:(ChatModel *)config
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (ChatAlbumModel *pic in pics) {
        
        //创建图片模型
        ChatModel *picModel = [self creatMessageModel:config];
        picModel.contenType = Content_Picture;
        picModel.content.picSize = pic.picSize;
        picModel.content.fileName = pic.name;
        [tmpArray addObject:picModel];
        
        NSString *basePath = nil;
        basePath = [ChatCache_Path stringByAppendingPathComponent:config.roomId];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL exist = [manager fileExistsAtPath:basePath];
        if (!exist) {
            [manager createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        //////////////////资源缓存
        //压缩比
        CGFloat compressScale = 1;
        NSData *smallAlbumData = nil;
        NSData *albumData = nil;
        //用户选择了原图
        if (pic.isOrignal) {
            
            //压缩过的小图缓存 (用户界面展示,节省资源)
            if (pic.orignalPicData.length/1024.0/1024.0 < 3) { //小于3M的
                
                compressScale = 0.1;  //压缩10倍
            }else{  //大于3M
                
                compressScale = 0.05; //压缩20倍
            }
            UIImage *image = [UIImage imageWithData:pic.orignalPicData];
            //小图data
            smallAlbumData = UIImageJPEGRepresentation(image, compressScale);
            //原图data
            albumData        = pic.orignalPicData;
            
            //默认选择,未选择原图
        }else{
            
            //压缩过的小图缓存 (用户界面展示,节省资源)
            if (pic.normalPicData.length/1024.0/1024.0 < 3) { //小于3M的
                
                compressScale = 0.1;  //压缩10倍
            }else{  //大于3M
                
                compressScale = 0.05; //压缩20倍
            }
            
            UIImage *image = [UIImage imageWithData:pic.normalPicData];
            //小图data
            smallAlbumData = UIImageJPEGRepresentation(image, compressScale);
            //原图data
            albumData        = pic.normalPicData;
        }
        //小图缓存路径
        NSString *smallDetailPath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",@"small",pic.name]];
        //原图缓存路径
        NSString *detailPath = [basePath stringByAppendingPathComponent:pic.name];
        //小图写入缓存
        [smallAlbumData writeToFile:smallDetailPath atomically:YES];
        //原图写入缓存
        [albumData writeToFile:detailPath atomically:YES];
    }
    return tmpArray;
}
//初始化视频消息模型
+ (ChatModel *)initVideoMessage:(ChatAlbumModel *)video config:(ChatModel *)config
{
    return nil;
}


+ (NSString*)chatMode2NSString:(ChatModel *)chatModel{
    if (!chatModel) {
        PCLog(@"chatMode2NSString failed! chatModel is nil");
        return nil;
    }
    
    ChatContentModel *chatContentModel = chatModel.content;
    if (!chatContentModel) {
        PCLog(@"chatMode2NSString failed! chatContentModel is nil");
        return nil;
    }
    
    // 格式化 ChatContentModel
    NSMutableDictionary *chatContentModelDict = [[NSMutableDictionary alloc]init];
    [chatContentModel.mj_keyValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (key && obj) {
            [chatContentModelDict setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
        }
    }];
    
    // 格式化 ChatModel
    NSMutableDictionary *chatModelDict = [[NSMutableDictionary alloc]init];
    [chatModel.mj_keyValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (key && obj) {
            [chatModelDict setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
        }
    }];
    [chatModelDict setValue:[chatContentModelDict JSONString] forKey:@"content"];
    return [chatModelDict JSONString];
}

+ (ChatModel*)string2ChatModel:(NSString *)message{
    if (!message) {
        PCLog(@"string2ChatModel failed! message is nil");
        return nil;
    }

    NSMutableDictionary *msgDict = [[NSMutableDictionary alloc]initWithDictionary: [message objectFromJSONString]];
    if (!msgDict || ![[msgDict allKeys]containsObject:@"content"]) {
        PCLog(@"string2ChatModel failed! content is nil");
        return nil;
    }
    
    NSString *contentString = [msgDict valueForKey:@"content"];
    NSMutableDictionary *contentDict = [[NSMutableDictionary alloc]initWithDictionary:[contentString objectFromJSONString]];
    [msgDict setValue:contentDict forKey:@"content"];
    
    NSString *picSize = [contentDict valueForKey:@"picSize"];
    NSDictionary *picSizeDict = [picSize objectFromJSONString];
    [contentDict setValue:picSizeDict forKey:@"picSize"];
    
    ChatModel *chatMode = [ChatModel mj_objectWithKeyValues:msgDict];
    ChatContentModel * chatContentModel = [ChatContentModel mj_objectWithKeyValues:contentDict];
    chatMode.content = chatContentModel;
    
   return chatMode;
}
@end
