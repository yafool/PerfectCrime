//
//  AccountServer.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccountServerDelegate<NSObject>

@optional
-(void)responseCologin:(NSDictionary*)m_dict;
-(void)responseModify:(NSDictionary*)m_dict;
-(void)responseUserInfo:(NSDictionary*)m_dict;
@end

@interface AccountServer : NSObject
{
    __unsafe_unretained id <AccountServerDelegate> _delegate;
}
@property (nonatomic,assign)id <AccountServerDelegate> delegate;

-(void)requestCologin:(NSDictionary*)m_dict;
-(void)requestModify:(NSDictionary*)m_dict;
-(void)requestGetUserInfo:(NSDictionary*)m_dict;
@end
