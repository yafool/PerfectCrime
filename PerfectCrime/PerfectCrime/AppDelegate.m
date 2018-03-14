//
//  AppDelegate.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideMenuController.h"
#import "GameMainViewController.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "WeChatManager.h"
#import "WXApi.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize mainVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //向微信注册应用。
    [[WeChatManager getInstance]registerApp];
    
    // 通常放在appdelegate就可以了
    [HYBNetworking updateBaseUrl:BaseUrl];
    [HYBNetworking enableInterfaceDebug:YES];
    
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [HYBNetworking configRequestType:kHYBRequestTypeJSON
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:YES];
    
    // 设置GET、POST请求都缓存
    [HYBNetworking cacheGetRequest:NO shoulCachePost:NO];

    
    //初始化一些数据持久化的默认的数据
    [self setCustomePublicDefaultData];
    
    // 应用启动加载页
    NSDictionary * dic = @{@"320x480" : @"LaunchImage-700", @"320x568" : @"LaunchImage-700-568h", @"375x667" : @"LaunchImage-800-667h", @"414x736" : @"LaunchImage-800-Portrait-736h"};
    NSString * key = [NSString stringWithFormat:@"%dx%d", (int)[UIScreen mainScreen].bounds.size.width, (int)[UIScreen mainScreen].bounds.size.height];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:dic[key]]]] ;
    UIViewController*rootVC = [[UIViewController alloc]init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([[SettingsManager sharedSettingsManager] hasLogin]){
            [self LoginSucceed];
        }else{
            [self setBeginViewController];
        }
    });
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    
    return [WXApi handleOpenURL:url delegate:[WeChatManager getInstance]];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:[WeChatManager getInstance]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:[WeChatManager getInstance]];
}

/*
 *登录页
 */
- (void)setBeginViewController{
    
    //初始化账号信息
    [[SettingsManager sharedSettingsManager]setUserId:@""];
    
    LoginViewController * LoginView = [[LoginViewController alloc]init];
    LoginView.delegate = self;
    LoginView.navigationItem.title = CustomLocalizedString(@"登录页", nil);
    XNNavViewController * navView = [[XNNavViewController alloc]initWithRootViewController:LoginView];
    
    self.window.rootViewController = nil;
    self.window.rootViewController = navView;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

// 实现 LoginViewControllerDelegate
-(void)LoginSucceed{
    [self setRootViewController];
}


//初始化一些数据持久化的默认的数据
-(void)setCustomePublicDefaultData{
    //设置唯一识别 即使删除也不会消失
    [[KeychainItemMode sharedInstance] setKeyChainUUID];
    
    //第一次 进入app 或者 版本升级
    if([CustomStringFunc isBlankString:[SettingsManager sharedSettingsManager].shopVerson] || ![[CustomSoftwareFunc getSoftwareVersion] isEqualToString:[SettingsManager sharedSettingsManager].shopVerson]){
        
        
    }else{
        
    }
    
    //默认的---定位的城市id  默认的定位经纬度
    [[MyClass_Public getInstance]setCityID:@"110000"];
    [[MyClass_Public getInstance]setCityName:@"北京"];
    [[MyClass_Public getInstance]setLatitudeW:@"39.91949"];
    [[MyClass_Public getInstance]setLongitudeJ:@"116.3787"];
    //默认的---选择的城市id
    [[MyClass_Public getInstance]setCurrentCityId:@"110000"];
    [[MyClass_Public getInstance]setCurrentCityName:@"北京"];
    
}

- (void)setRootViewController{
    self.mainVC = [[MainViewController alloc]init];
    
    LeftMenuViewController * leftMenu = [[LeftMenuViewController alloc]init];
    XNNavViewController *nvcLeft = [[XNNavViewController alloc] initWithRootViewController:leftMenu];
    
    RightMenuViewController * rightMenu = [[RightMenuViewController alloc]init];
    XNNavViewController *nvcRight = [[XNNavViewController alloc] initWithRootViewController:rightMenu];
    
    self.mainVC.leftdelegate = leftMenu;
    self.mainVC.rightdelegate = rightMenu;
    
    
    SlideMenuController *slideMenuController = [[SlideMenuController alloc] initWithMainViewController:self.mainVC leftMenuViewController:nvcLeft rightMenuViewController:nvcRight];
    
    slideMenuController.automaticallyAdjustsScrollViewInsets = YES;
    slideMenuController.delegate = self.mainVC;
    
    self.window.rootViewController = nil;
    self.window.rootViewController = slideMenuController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self disableSlidMenu];
    [self.window makeKeyWindow];
    
}

- (void)disableSlidMenu{
    if([self.window.rootViewController isKindOfClass:[SlideMenuController class]]){
        SlideMenuController *slideMenuController = (SlideMenuController *)self.window.rootViewController;
        [slideMenuController removeLeftGestures];
        [slideMenuController removeRightGestures];
    }
}

- (void)enableSlidMenu{
    if([self.window.rootViewController isKindOfClass:[SlideMenuController class]]){
        SlideMenuController *slideMenuController = (SlideMenuController *)self.window.rootViewController;
        [slideMenuController addLeftGestures];
        [slideMenuController addRightGestures];
    }
    
}

- (void)changeMainViewController:(UIViewController *)newMainController{
    if([self.window.rootViewController isKindOfClass:[SlideMenuController class]]){
        SlideMenuController *slideMenuController = (SlideMenuController *)self.window.rootViewController;
        [slideMenuController changeMainViewController:newMainController close:NO];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
