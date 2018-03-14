//
//  MVPVoteView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/11/9.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgView.h"
#import "DataStructure.h"

// title 高度
#define BoxTitleHeight        (DlgTitleHeight)
// 框体宽度
#define BoxWidth    (FullScreen.size.width - 2 *16)
// 正方形collection view 边长；（一行5个view）
#define VoterSize ((BoxWidth-6)/5)

// 投票结束
typedef void(^MVPVoteBlock)(PlayerInfo *player);

@interface MVPVoteView : DlgView
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

+ (DlgAppearance *)appearances;
+ (void)showWitVoteActionBlock:(MVPVoteBlock)mvpVoteBlock;
@end
