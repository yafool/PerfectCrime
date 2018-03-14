//
//  MBProgressHUD+JDragon.h
//  JDragonHUD
//
//  Created by JDragon on 2017/1/17.
//  Copyright © 2017年 JDragon. All rights reserved.
//

/*
 [MBProgressHUD showActivityMessageInWindow:nil];
 [MBProgressHUD showActivityMessageInView:nil];
 [MBProgressHUD showTipMessageInWindow:@"在window"];
 [MBProgressHUD showTipMessageInView:@"在View"];
 [MBProgressHUD showSuccessMessage:@"加载成功"];
 [MBProgressHUD showWarnMessage:@"显示警告"];
 [MBProgressHUD showErrorMessage:@"显示错误"];
 [MBProgressHUD showInfoMessage:@"显示信息"];
 */
#import "MBProgressHUD.h"

@interface MBProgressHUD (JDragon)

+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer;


+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInView:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer;


+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;


+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;


+ (void)hideHUD;

@end
