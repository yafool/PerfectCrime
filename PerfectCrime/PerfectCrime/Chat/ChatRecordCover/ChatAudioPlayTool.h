//
//  ChatAudioPlayTool.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatAudioPlayTool : NSObject

+ (instancetype)audioPlayTool:(NSString *)path;

- (void)play;

@end
