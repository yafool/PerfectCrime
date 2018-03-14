//
//  UIImageView+GIF.h
//  Chat
//
//  Created by 刘亚夫 on 2017/7/4.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GIF)
//播放GIF
- (void)GIF_PrePlayWithImageNamesArray:(NSArray *)array duration:(NSInteger)duration;
//停止播放
- (void)GIF_Stop;

@end
