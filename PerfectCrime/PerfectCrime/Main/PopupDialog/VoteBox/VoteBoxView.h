//
//  VoteBoxView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/11/7.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgView.h"
#import "DataStructure.h"

// title 高度
#define BoxTitleHeight        DlgTitleHeight
// 框体宽度
#define BoxWidth    (FullScreen.size.width - 2 *16)
// 正方形collection view 边长；（一行5个view）
#define VoterSize ((BoxWidth-6)/5)

typedef NS_ENUM(NSInteger, VoteBoxType) {
    // 警察
    VoteBoxType_4Police = 1,
    // 匪徒
    VoteBoxType_4Terrorist,
    // 天亮后投票
    VoteBoxType_atDaybreak
};

// 投票结束
typedef void(^VoteActionBlock)(VoteBoxType type, PlayerInfo *player);

@interface VoteBoxView : DlgView
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

+ (DlgAppearance *)appearances;
+ (void)showWithVoteType:(VoteBoxType)type andVoteActionBlock:(VoteActionBlock)voteActionBlock;
@end
