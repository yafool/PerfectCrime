//
//  DlgView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DlgAppearance.h"

//屏幕尺寸
#define FullScreen [UIScreen mainScreen].bounds
// title区 和 按钮区 高度
#define DlgTitleHeight        48
#define DlgBottomRowHeight    56
// 框体宽度
#define DlgWidth    (FullScreen.size.width - 2 *30)
//按钮默认高度
#define DlgBtnHeight (32)

#pragma mark --- UIButton (block) [categora]
typedef void(^CommitAction)(UIButton* button);

@interface UIButton (block)

@property (readonly) NSMutableDictionary *event;

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(CommitAction)action;

@end

#pragma mark --- DlgAppearance [interface]
@class DlgAppearance;

@interface DlgView : UIView
@property (nonatomic, strong) UIView        *alertView;
- (void)show;
- (void)dismiss;
- (void)setShowAnimationIfDruation:(NSTimeInterval)druation andStyle:(PopupAnimationStyles)style;

@end
