//
//  LoginViewController.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FatherViewController.h"
#import "LoginView.h"

@protocol LoginViewControllerDelegate<NSObject>
-(void)LoginSucceed;
@end

@interface LoginViewController : FatherViewController <LoginViewDelegate>
{
    __unsafe_unretained id <LoginViewControllerDelegate> _delegate;
}
@property (nonatomic,assign)id <LoginViewControllerDelegate> delegate;

@end
