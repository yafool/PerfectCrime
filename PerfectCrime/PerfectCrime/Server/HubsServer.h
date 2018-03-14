//
//  HubsServer.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlayerSortType) {
    // 胜率
    PlayerSortType_winRate = 1,
    // 总分
    PlayerSortType_score,
    // 总局数
    PlayerSortType_totalNum,
    // MVP次数
    PlayerSortType_mvp
    
};

@protocol HubsServerDelegate<NSObject>
-(void)playerSortArray:(NSArray *) m_ary andType:(PlayerSortType)type;
-(void)alreadyInvited:(NSDictionary*)m_dict;
-(void)blackList:(NSDictionary*)m_dict;
@end

@interface HubsServer : NSObject
{
    __unsafe_unretained id <HubsServerDelegate> _delegate;
}
@property (nonatomic,assign)id <HubsServerDelegate> delegate;

-(void)requestSortWithType:(PlayerSortType)type andPage:(NSInteger)page;
-(void)makeFriend:(NSMutableDictionary*)m_dict;
-(void)drag2Blacklist:(NSMutableDictionary*)m_dict;
@end
