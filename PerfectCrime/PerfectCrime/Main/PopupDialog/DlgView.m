//
//  DlgView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgView.h"


#pragma mark --- UIButton (block) [categora]
@implementation UIButton (block)

static char overviewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(CommitAction)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    CommitAction block = (CommitAction)objc_getAssociatedObject(self, &overviewKey);
    
    if (block) {
        __weak typeof(self) weakSelf = self;
        block(weakSelf);
    }
}

@end


#pragma mark --- DlgView
@implementation DlgView

- (void)show{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [self setShowAnimationIfDruation:0 andStyle:PopupAnimationStyleDefault];
}

- (void)dismiss{
    
    [[UIApplication sharedApplication].delegate.window resignKeyWindow];
    
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication].delegate.window becomeKeyWindow];
    
    [self removeFromSuperview];
}

- (void)setShowAnimationIfDruation:(NSTimeInterval)druation andStyle:(PopupAnimationStyles)style{
    switch (style) {
        case PopupAnimationStyleDefault:
        {
            CGPoint startPoint = CGPointMake(self.center.x, -self.alertView.frame.size.height);
            self.alertView.layer.position=startPoint;
            
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.alertView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
                if (druation) {
                    [UIView animateWithDuration:.25 delay:druation options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self dismiss];
                    }];
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
