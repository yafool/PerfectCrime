//
//  WeChatManager.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/15.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ReturnCode) {
    ReturnCode_success = 200,
    ReturnCode_failed
};


typedef void (^WeChatAuthBlock)(ReturnCode code, NSDictionary* m_dict);
typedef void (^WeChatShareBlock)(ReturnCode code);
typedef void (^WeChatPayBlock)(ReturnCode code);

@interface WeChatManager : NSObject
//声明block 属性
@property (nonatomic,strong)WeChatAuthBlock  authBlock;
@property (nonatomic,strong)WeChatShareBlock shareBlock;
@property (nonatomic,strong)WeChatPayBlock   payBlock;

//初始化
+ (id)getInstance;
//向微信注册应用。
-(void)registerApp;

/** 发起微信登陆鉴权 */
- (void)sendAuthReq:(UIViewController *)controller andBlock:(WeChatAuthBlock)block;


@end
