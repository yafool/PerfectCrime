//
//  DlgAppearance.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgAppearance.h"

@implementation DlgAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /** alertView*/
        self.DlgMaskViewColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.DlgViewPadding = UIEdgeInsetsMake(30, 20, 30, 20);
        self.DlgViewColor = [UIColor whiteColor];
        self.DlgViewCornerRadius = 4.;
        
        /** Animation*/
        self.PopupAnimationStyles = PopupAnimationStyleDefault;
        
    }
    return self;
}

@end
