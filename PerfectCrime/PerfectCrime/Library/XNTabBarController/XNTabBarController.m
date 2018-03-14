//
//  XNTabBarController.m
//
//  Created by neng on 14-6-19.
//  Copyright (c) 2014年 neng. All rights reserved.
//

#import "XNTabBarController.h"
#import "XNTabBarButton.h"
#import "CustomBadgeView.h"

@interface XNTabBarController ()
/**
 *  设置之前选中的按钮
 */
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation XNTabBarController
#pragma mark -------- 旋转屏幕  ----------------/
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window  NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate{
    
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
/* 隐藏 tabbar 发送通知 */
+ (void)hideTabbar{
    NSNotificationCenter * notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:@"hideTabbar" object:nil];
}
/* 显示 tabbar 发送通知 */
+ (void)showTabbar{
    NSNotificationCenter * notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:@"showTabbar" object:nil];
}
/*************************************************
 *方法注释*
 *Function:         // show
 *Description:      // 显示tabbar 的动画效果
 *Calls:            // 无
 *@return           // 无
 *@Others:          // 其中 区分IOS7 及 IOS6 执行动画不一样
 **************************************************/
- (void)show{
    [myView setHidden:NO];
    CGRect rect = self.tabBar.frame;
    [UIView animateWithDuration:0.4f animations:^{
        myView.frame = rect;
    } completion:^(BOOL finished){
        
    }];
}

/*************************************************
 *方法注释*
 *Function:         // hide
 *Description:      // 隐藏tabbar 的动画效果
 *Calls:            // 无
 *@return           // 无
 *@Others:          // 其中 区分IOS7 及 IOS6 执行动画不一样
 **************************************************/
- (void)hide{
    CGRect rect = self.tabBar.frame;
    rect.origin.y = rect.origin.y + rect.size.height;
    [UIView animateWithDuration:0.4f animations:^{
        myView.frame = rect;
    } completion:^(BOOL finished){
        [myView setHidden:YES];
    }];
}
- (void)viewDidLoad {
	[super viewDidLoad];
    
    /* 添加监听事件 监听是否触发 tabbar 的隐藏及显示 */
    NSNotificationCenter * notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(show) name:@"showTabbar" object:nil];
    [notification addObserver:self selector:@selector(hide) name:@"hideTabbar" object:nil];

	//隐藏现有的tabBar
	CGRect rect = self.tabBar.frame; //这里要用bounds来加, 否则会加到下面去.看不见
	[self.tabBar setHidden:YES];  //隐藏TabBarController自带的下部的条

	//测试添加自己的视图
    myView = [[UIImageView alloc] init]; //设置代理必须改掉前面的类型,不能用UIView
	myView.frame = rect;
    myView.image = [UIImage imageNamed:@"bottomTabbar_navbj"];
    myView.userInteractionEnabled = YES;
	[self.view addSubview:myView]; //添加到系统自带的tabBar上, 这样可以用的的事件方法. 而不必自己去写
    
    btnArray   = [[NSMutableArray alloc]init];
    badgeArray = [[NSMutableArray alloc]init];

    //添加按钮
	for (int i = 0; i < 4; i++) {
        
        XNTabBarButton *btn = [[XNTabBarButton alloc] init];

		NSString *imageName = [NSString stringWithFormat:@"tabbar_tap%d", i + 1];
		NSString *imageNameSel = [NSString stringWithFormat:@"tabbar_hover%d", i + 1];

		[btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:imageNameSel] forState:UIControlStateSelected];

		CGFloat x = i * myView.frame.size.width / 4;
		btn.frame = CGRectMake(x, 0, myView.frame.size.width / 4, myView.frame.size.height);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
		[myView addSubview:btn];

        btn.tag = i;//设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图

		//带参数的监听方法记得加"冒号"
		[btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        /* 将array添加进数组 比便根据数组中元素的指针访问 btn */
        [btnArray addObject:btn];
		//设置刚进入时,第一个按钮为选中状态
		if (0 == i) {
			btn.selected = YES;
			self.selectedBtn = btn;  //设置该按钮为选中的按钮
            self.selectedIndex = btn.tag;
		}
	}
    
    /*
    // 在创建完所有按钮之后 添加badgeView 以免在一个循环中被后续按钮所覆盖掉
    for (UIButton * button in btnArray) {
        static int i = 0;
        i ++;
        if(i == 2){
            CustomBadgeView * badgeView = [[CustomBadgeView alloc]init];
            badgeView.backgroundColor = [UIColor clearColor];
            CGRect  badgeFrame = CGRectMake(button.frame.origin.x + button.frame.size.width - 40, button.frame.origin.y+2, 15, 15);
            badgeView.imageView.image = [UIImage imageNamed:@"BadgeImage"];
            badgeView.imageView.frame = badgeFrame;
            badgeView.labelText.frame = badgeFrame;
            [badgeView setBadgeVaule:[NSString stringWithFormat:@"1%i",i]];
            [myView addSubview:badgeView];
            //  存放已经创建的badgeView 指针 以便修改
            [badgeArray addObject:badgeView];
        }
    }
    */
    
}

/**
 *  自定义TabBar的按钮点击事件
 */
- (void)clickBtn:(UIButton *)button {
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    //2.再将当前按钮设置为选中
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    self.selectedIndex = button.tag;
}

@end
