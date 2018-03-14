//
//  AppDelegate.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MainViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginViewControllerDelegate>
{
    MainViewController  * mainVC;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController * mainVC;

- (void)setBeginViewController;
- (void)setRootViewController;

- (void)disableSlidMenu;
- (void)enableSlidMenu;
@end

