//
//  PlayerAlertView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/18.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeAppearance.h"
#import "DlgView.h"


#pragma mark --- CreateHomeView [interface]
@class HomeAppearance;

@interface CreateHomeView : DlgView
+ (HomeAppearance *)appearances;

+ (void)showWithCreateAction:(CommitAction)createAction;
@end
