//
//  XNNavViewController.m
//
//  Created by neng on 14-6-20.
//  Copyright (c) 2014年 neng. All rights reserved.
//

#import "XNNavViewController.h"

@interface XNNavViewController ()

@end

@implementation XNNavViewController

#pragma mark -------- 旋转屏幕  ----------------/
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window  NS_AVAILABLE_IOS(6_0){
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

-(void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**这个方法在类第一次调用时被调用, 此方法只会被调用一次. 避免浪费内存*/
+ (void)initialize {
	//修改nav条的样式. (用自己的图片)
	UINavigationBar *navBar = [UINavigationBar appearance];
	[navBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    //修改navBar字体大小文字颜色
	NSDictionary *attris = @{ NSFontAttributeName:Text_Helvetica(21),
		                      NSForegroundColorAttributeName:[UIColor blackColor] };
	[navBar setTitleTextAttributes:attris];
}

/**拦截系统的push事件,即使忘记勾选hide bottom bar on push额能在跳转时隐藏TabBar*/
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	viewController.hidesBottomBarWhenPushed = YES;   //这个必须写在super前面, 否则跳转已经过了
    [super pushViewController:viewController animated:animated];  //要写这个,否则不跳转了
}

@end
