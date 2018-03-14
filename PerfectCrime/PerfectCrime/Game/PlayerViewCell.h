//
//  PlayerViewCell.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/13.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"

@interface PlayerViewCell : UICollectionViewCell
// 根据传入的 player info 初始化view
-(void)initMyView:(PlayerInfo*)m_info;
// 获取当前 CollectionView 的 player info
-(PlayerInfo*)getPlayerInfo;
@end
