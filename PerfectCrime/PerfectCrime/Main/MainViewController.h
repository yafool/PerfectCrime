//
//  MainViewController.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "XNTabBarController.h"
#import "SlideMenuController.h"



@protocol AgentLeftSlideMenuControllerDelegate<NSObject>
@optional
-(void)onLeftWillOpen;
-(void)onLeftDidOpen;
-(void)onLeftWillClose;
-(void)onLeftDidClose;
@end

@protocol AgentRightSlideMenuControllerDelegate<NSObject>
@optional
-(void)onRightWillOpen;
-(void)onRightDidOpen;
-(void)onRightWillClose;
-(void)onRightDidClose;
@end

@interface MainViewController : XNTabBarController <SlideMenuControllerDelegate>
{
    __unsafe_unretained id <AgentLeftSlideMenuControllerDelegate> _leftdelegate;
    __unsafe_unretained id <AgentRightSlideMenuControllerDelegate> _rightdelegate;
}
@property (nonatomic,assign)id <AgentLeftSlideMenuControllerDelegate> leftdelegate;
@property (nonatomic,assign)id <AgentRightSlideMenuControllerDelegate> rightdelegate;
@end
