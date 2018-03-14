//
//  WeChatManager.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/15.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "WeChatManager.h"
#import "WXApi.h"
#import "AFNetworking.h"

@interface WeChatManager ()<WXApiDelegate>
@property (nonatomic,retain)UIViewController * controller;
@end


@implementation WeChatManager

+ (id)getInstance{
    static WeChatManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WeChatManager alloc] init];
    });
    return instance;
}

//向微信注册应用。
-(void)registerApp{
    [WXApi registerApp:WeiXinAppkey];
}
/** 发起微信登陆鉴权 */
- (void)sendAuthReq:(UIViewController *)controller andBlock:(WeChatAuthBlock)block{
    self.controller = controller;
    self.authBlock = block;
    
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.openID = WeiXinAppkey;
        req.state = @"1245";
        
        [WXApi sendReq:req];
    }else{
        //把微信登录的按钮隐藏掉。
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.openID = WeiXinAppkey;
        req.state = @"1245";
        
        [WXApi sendAuthReq:req viewController:controller delegate:self];
    }
}

-(void)authSuccessByCode:(NSString *)code{
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeiXinAppkey,WeiXinAppSecret,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        PCLog(@"dic %@",dic);
        
        /*
         access_token	接口调用凭证
         expires_in	access_token接口调用凭证超时时间，单位（秒）
         refresh_token	用户刷新access_token
         openid	授权用户唯一标识
         scope	用户授权的作用域，使用逗号（,）分隔
         unionid	 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* openID=[dic valueForKey:@"openid"];
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PCLog(@"error %@",error.localizedFailureReason);
        self.authBlock(ReturnCode_failed, nil);
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //拿到相关微信用户信息后， 需要与后台对接，进行登录
        PCLog(@"login success dic  ==== %@",dic);
        self.authBlock(ReturnCode_success, dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PCLog(@"error %ld",(long)error.code);
        self.authBlock(ReturnCode_failed, nil);
    }];
}

#pragma mark -------- WXApiDelegate  ----------------/
/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * resp具体的回应内容，是自动释放的
 *        enum  WXErrCode {
 *              WXSuccess           = 0,    成功
 *              WXErrCodeCommon     = -1,  普通错误类型
 *              WXErrCodeUserCancel = -2,    用户点击取消并返回
 *              WXErrCodeSentFail   = -3,   发送失败
 *              WXErrCodeAuthDeny   = -4,    授权失败
 *              WXErrCodeUnsupport  = -5,   微信不支持
 *       }
 */
-(void) onResp:(BaseResp*)resp{
    PCLog(@"=======> onResp: resp %d",resp.errCode);
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            SendAuthResp *sendAuthResp = (SendAuthResp *)resp;
            [self authSuccessByCode:sendAuthResp.code];
        }else{ //失败
            [MBProgressHUD showErrorMessage:resp.errStr];
            self.authBlock(ReturnCode_failed, nil);
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        
        if (resp.errCode == 0) {  //成功。
            self.shareBlock(ReturnCode_success);
        }else{ //失败
            [MBProgressHUD showErrorMessage:resp.errStr];
            self.shareBlock(ReturnCode_failed);
        }
    }
    
//    if ([resp isKindOfClass:[PayResp class]]) { // 微信支付
//        
//        if (resp.errCode == 0) {  //成功。
//            self.payBlock(ReturnCode_success);
//        }else{ //失败
//            [MBProgressHUD showErrorMessage:resp.errStr];
//            self.payBlock(ReturnCode_failed);
//        }
//    }
}

@end
