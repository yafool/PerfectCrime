//
//  LoginView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate<NSObject>
-(void)onClickWeChatCologin;
@end
@interface LoginView : UIView
{
    __unsafe_unretained id <LoginViewDelegate> _delegate;
}
@property (nonatomic,assign)id <LoginViewDelegate> delegate;
@end
