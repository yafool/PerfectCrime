//
//  PlayState.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/12/3.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStructure.h"
#import "GameInfoManager.h"
#import "GameHandler.h"

#define AT_Nightfall    @"天黑请闭眼"
#define AT_Daybreak     @"天亮了"

@interface PlayState : NSObject
-(void)GoNext:(PlayState*)state;
-(void)OnPlaying;
@end
