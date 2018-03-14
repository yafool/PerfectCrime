//
//  CustomBadgeView.h
//  hpwifiShop
//
//  Created by wangxiaoqin on 14-7-10.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBadgeView : UIView
{
    UIImageView * imageView;
    UILabel * labelText;
}
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UILabel * labelText;
- (void)setBadgeVaule:(NSString*)_vaule;
@end
