//
//  HomeConfirmView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/24.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgView.h"
#import "ConfirmAppearance.h"

@class ConfirmAppearance;

@interface HomeConfirmView : DlgView
+ (ConfirmAppearance *)appearances;

+ (void)showWithHome:(NSDictionary*)home_dict andAction:(CommitAction)confirmAction;
@end
