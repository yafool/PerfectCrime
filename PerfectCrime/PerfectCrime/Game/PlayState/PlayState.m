//
//  PlayState.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/12/3.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayState.h"

@implementation PlayState
-(void)GoNext:(PlayState*)state{
    [state OnPlaying];
}

-(void)OnPlaying{
    
}
@end
