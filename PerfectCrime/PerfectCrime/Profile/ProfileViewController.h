//
//  ProfileViewController.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/14.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "FatherViewController.h"

#import "PlayerEssentialInfoView.h"
#import "PlayerGameInfoView.h"
#import "SettingsView.h"

@interface ProfileViewController : FatherViewController
<
PlayerEssentialInfoDelegate,
SettingsDelegate
>
{
    PlayerEssentialInfoView * playerEssentialInfoView;
    PlayerGameInfoView * playerGameInfoView;
    SettingsView * settingsView;
}
@end
