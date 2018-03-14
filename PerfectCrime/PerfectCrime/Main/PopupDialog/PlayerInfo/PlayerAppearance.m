//
//  PlayerAppearance.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayerAppearance.h"

@implementation PlayerAppearance

- (void)setViewInfo:(NSDictionary*)m_dict
{
    PCLog(@"PlayerAppearance==>self: %@  &&  m_dict: %@", self, m_dict);
    if (self && m_dict) {
        
        self.myUserID = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"uid"]];
        self.portrait = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"portrait"]];
        self.nick = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"nick"]];
        self.sex = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"sex"]];
        self.age = [m_dict valueForKey:@"age"];
        self.addr = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"addr"]];
        self.gamesNum = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"gamesNum"]];
        self.winsNum = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"winsNum"]];
        self.winsRate = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"winsRate"]];
        self.gameScore = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"gameScore"]];
        self.gameScore = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"mvpNum"]];
        
        
    }
}

@end
