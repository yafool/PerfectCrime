//
//  CustomBadgeView.m
//  hpwifiShop
//
//  Created by wangxiaoqin on 14-7-10.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomBadgeView.h"

@implementation CustomBadgeView
@synthesize imageView,labelText;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadView];
    }
    return self;
}

- (void)loadView{
    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    
    labelText = [[UILabel alloc]init];
    labelText.font = Text_Helvetica_Bold(11);
    labelText.backgroundColor = [UIColor clearColor];
    labelText.textColor = [UIColor whiteColor];
    labelText.adjustsFontSizeToFitWidth = YES;
    labelText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelText];
}

- (void)setBadgeVaule:(NSString*)_vaule{
    if ([_vaule isEqualToString:@"0"]) {
        [self setHidden:YES];
    }else{
        labelText.text = _vaule;
        [self setHidden:NO];
    }
}
@end
