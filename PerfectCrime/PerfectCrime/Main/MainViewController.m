//
//  MainViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "MainViewController.h"

#import "HomeViewController.h"
#import "HubsViewController.h"
#import "MsgViewController.h"
#import "ProfileViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize leftdelegate = _leftdelegate;
@synthesize rightdelegate = _rightdelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initNavView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TabBar 配置
- (void)_initNavView{
    // 游戏大厅
    HomeViewController * homeView = [[HomeViewController alloc]init];
    XNNavViewController * navHomeView = [[XNNavViewController alloc]initWithRootViewController:homeView];
    // 排行榜
    HubsViewController * hubsView = [[HubsViewController alloc]init];
    XNNavViewController * navHubsView = [[XNNavViewController alloc]initWithRootViewController:hubsView];
    // 消息
    MsgViewController * msgView = [[MsgViewController alloc]init];
    XNNavViewController * navMsgView = [[XNNavViewController alloc]initWithRootViewController:msgView];
    // 我的
    ProfileViewController * mineView = [[ProfileViewController alloc]init];
    XNNavViewController * navMyView = [[XNNavViewController alloc]initWithRootViewController:mineView];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.viewControllers = @[navHomeView, navHubsView, navMsgView, navMyView];
    
}

#pragma makr --- [Delegate] --- SlideMenuControllerDelegate
-(void)leftWillOpen {
    if (_leftdelegate && [_leftdelegate respondsToSelector:@selector(onLeftWillOpen)])
    {
        [_leftdelegate onLeftWillOpen];
    }
}

-(void)leftDidOpen {
    if (_leftdelegate && [_leftdelegate respondsToSelector:@selector(onLeftDidOpen)])
    {
        [_leftdelegate onLeftDidOpen];
    }
}

-(void)leftWillClose {
    if (_leftdelegate && [_leftdelegate respondsToSelector:@selector(onLeftWillClose)])
    {
        [_leftdelegate onLeftWillClose];
    }
}

-(void)leftDidClose {
    if (_leftdelegate && [_leftdelegate respondsToSelector:@selector(onLeftDidClose)])
    {
        [_leftdelegate onLeftDidClose];
    }
}

-(void)rightWillOpen {
    if (_rightdelegate && [_rightdelegate respondsToSelector:@selector(onRightWillOpen)])
    {
        [_rightdelegate onRightWillOpen];
    }
}

-(void)rightDidOpen {
    if (_rightdelegate && [_rightdelegate respondsToSelector:@selector(onRightDidOpen)])
    {
        [_rightdelegate onRightDidOpen];
    }
}

-(void)rightWillClose {
    if (_rightdelegate && [_rightdelegate respondsToSelector:@selector(onRightWillClose)])
    {
        [_rightdelegate onRightWillClose];
    }
}

-(void)rightDidClose {
    if (_rightdelegate && [_rightdelegate respondsToSelector:@selector(onRightDidClose)])
    {
        [_rightdelegate onRightDidClose];
    }
}

@end
