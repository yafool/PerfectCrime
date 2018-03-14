//
//  XNTabBarController.h
//
//  Created by neng on 14-6-19.
//  Copyright (c) 2014年 neng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNTabBarController : UITabBarController
{
    /* 自定义 tabbar subView */
    UIImageView * myView;
    /* 自定义 tabbar 按钮集合 */
    NSMutableArray * btnArray;
    /* 自定义 tabbar 标记集合 */
    NSMutableArray * badgeArray;
}
/* 隐藏 tabbar */
+ (void)hideTabbar;
/* 显示 tabbar */
+ (void)showTabbar;
@end
