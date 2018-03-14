//
//  UIImage+photoPicker.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatAlbumModel;

//返回选中的所有图片 , 原图或者压缩图
typedef void(^photoPickerImagesCallback)(NSArray<ChatAlbumModel *> *images);

//返回视频存储的位置
typedef void(^videoPathCallback)(ChatAlbumModel *videoModel);


@interface UIImage (photoPicker)

/**
 
 @param imagesCallback <#photosCallback description#>
 @param target 打开相册所需
 @param count 最大可选数量
 */
+ (void)openPhotoPickerGetImages:(photoPickerImagesCallback)imagesCallback target:(UIViewController *)target maxCount:(NSInteger)count;

/**
 获取选中的视频
 
 @param videoPathCallback <#videoPathFileNameCallback description#>
 @param target                    <#target description#>
 */
+ (void)openPhotoPickerGetVideo:(videoPathCallback)videoPathCallback target:(UIViewController *)target cacheDirectory:(NSString *)basePath;

@end
