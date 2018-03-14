//
//  MainTopView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/17.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OptionTrustDone   @"托管"
#define OptionTrustCancel @"撤销"

@interface MainTopView : UIView
//显示当前发言者的倒计时
-(void)setCountdownTitle:(NSString*)title;
//显示当前进行到第几天
-(void)setProcessTitle;
@end
