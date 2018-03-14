//
//  MQTTManager.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/6.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^receiveMessageBlock)(NSString * message);

@interface MQTTManager : NSObject
//声明block 属性
@property (nonatomic,strong)receiveMessageBlock messageBlock;
    
+ (instancetype)share;
    
- (void)connect:(NSString*)userId andTopic:(NSString*)homeId;
- (void)disConnect;
    
- (void)sendMsg:(NSString *)msg andTopic:(NSString*)homeId;
    
    
    
    
@end
