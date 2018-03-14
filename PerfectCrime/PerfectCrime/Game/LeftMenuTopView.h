//
//  LeftMenuTopView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/13.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PlayersSitDown  @"入席玩家"
#define PlayersInRoom   @"全部玩家"

#define GameReday       @"准备中..."

#define OptionPlay      @"开始游戏"
#define OptionPlaying   @"游戏已开始"
#define OptionEnd       @"游戏结束"
#define OptionSit       @"入席"
#define OptionLeave     @"离席"

@protocol LeftMenuTopViewDelegate<NSObject>
// 展示入席玩家列表
-(void)OnShowSitDownList;
// 展示旁观玩家列表
-(void)OnShowAllPlayerList;
// 房主在入席人满后可以点击开始游戏（仅房住有权）
-(void)OnOptionPlaying;
// 非房住进入房间后点击按钮入席
-(void)OnOptionSit;
// 非房住进入房间后点击按钮离席
-(void)OnOptionLeave;
@end

@interface LeftMenuTopView : UIView
{
    __unsafe_unretained id <LeftMenuTopViewDelegate> _delegate;
}
@property (nonatomic,assign)id <LeftMenuTopViewDelegate> delegate;

-(void)initMyView:(NSDictionary*)m_dict;
-(void)changeToPlayers;
-(void)changeForUserSit;
-(void)changeForCountdown:(NSString*)title;
@end
