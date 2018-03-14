//
//  PlayerAlertView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/18.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerAppearance.h"
#import "DlgView.h"


typedef NS_ENUM(NSUInteger, PlayerAlertViewButtonType) {
    PlayerAlertViewButtonBlacklist = 0,
    PlayerAlertViewButtonFriend,
};

#pragma mark --- PlayerAlertView [interface]
@class PlayerAppearance;

@interface PlayerAlertView : DlgView
+ (PlayerAppearance *)appearances;

+ (void)showWithDictionary:(NSDictionary*)m_dict andBlacklistAction:(CommitAction)blacklistAction andFriendAction:(CommitAction)friendAction;
@end
