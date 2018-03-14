//
//  DlgAppearance.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PlayerAlertColor(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.]


typedef NS_ENUM(NSUInteger, PopupAnimationStyles) {
    PopupAnimationStyleDefault,
};

@interface DlgAppearance : NSObject
/** alertView*/
@property (nonatomic,strong) UIColor* DlgMaskViewColor;
@property (nonatomic,strong) UIColor* DlgViewColor;
@property (nonatomic, assign) UIEdgeInsets DlgViewPadding;
@property (nonatomic,assign) CGFloat DlgViewCornerRadius;

/** Animation*/
@property (nonatomic, assign) PopupAnimationStyles PopupAnimationStyles;

@end
