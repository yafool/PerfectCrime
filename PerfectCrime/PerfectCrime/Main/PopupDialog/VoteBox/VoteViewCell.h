//
//  VoteViewCell.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/11/7.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"

@interface VoteViewCell : UICollectionViewCell
// 玩家信息
@property (strong, nonatomic) PlayerInfo    *player;
@property (assign, nonatomic) NSInteger       votes;

// 根据传入的 player info 初始化view
-(void)initVoterView:(PlayerInfo*)m_info;
// player info 有变化时刷新 view
-(void)onVoteChange;
@end
