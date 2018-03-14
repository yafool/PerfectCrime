//
//  DataStructure.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/12.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FRAME_HEIGHT_TopView          50

/*
 消息类型--服务段push的消息事件
 */
static NSString *Message_userInRoom          =@"userInRoom"; //推送玩家入座
static NSString *Message_userEnterRoom       =@"userEnterRoom"; //推送玩家进入房间
static NSString *Message_userRole            =@"userRole"; //推送玩家角色
static NSString *Message_killUser            =@"killUser"; //推送天黑杀手杀人
static NSString *Message_killResult          =@"killResult"; //推送杀人结果
static NSString *Message_policeCheckUser     =@"policeCheckUser"; //推送警察验人结果
static NSString *Message_playerSpeak         =@"playerSpeak"; //天亮了玩家依次发言
static NSString *Message_allalivespeak       =@"allalivespeak"; //被杀者遗言
static NSString *Message_voteResult          =@"voteResult"; //投票结果
static NSString *Message_gameover            =@"gameover"; //推送游戏结束
static NSString *Message_userLeaveRoom       =@"userLeaveRoom"; //推送玩家离开房间
static NSString *Message_mpvresult           =@"mpvresult"; //推送mpv结果
static NSString *Message_changeHoster        =@"changeHoster"; // 推送房主变更
static NSString *Message_InvalidReceipt      =@"invalidReceipt";//消息发送失败回执
static NSString *Message_Unknow              =@"unknow";//消息发送失败回执

/*
 消息类型--终端自己消化的消息事件（注意：服务端也可以收到）
 */
static NSString *Message_startGame             =@"startGame"; //推送警察验人
static NSString *Message_voteByPolice          =@"voteByPolice"; //推送警察验人
static NSString *Message_voteByTerrorist       =@"voteByTerrorist"; //推送玩家杀人
static NSString *Message_voteAtDaybreak        =@"voteAtDaybreak"; //推送天亮曝匪
static NSString *Message_vote4MVP              =@"vote4MVP"; //推送MVP投票

/*
 * 页玩家座席显示区---房间信息
 **/
#define ROOM_STATE_SIT      @"sit_down"  // 入席
#define ROOM_STATE_LEAVE    @"leave"     // 离席
#define ROOM_STATE_EXIT     @"exit"      // 退出

#pragma mark -------- RoomInfo [begin] ----------------/
typedef NS_ENUM(NSInteger, ReadyForGame) {
    // 入席人数不够，不能开始
    ReadyForGame_notReady = 0,
    // 人数已购，可以开始
    ReadyForGame_beReady
    
};

@interface RoomInfo : NSObject
// 房间ID
@property (nonatomic ,copy) NSString *roomId;
// 房主
@property (nonatomic ,copy) NSString *hoster;
// 房间名称
@property (nonatomic, copy) NSString *roomName;
// 房间等级：菜鸟、高手
@property (nonatomic, copy) NSString *grade;
// 房间等级：慢、中、快
@property (nonatomic, copy) NSString *speed;
// 房间人数限制：8、12、16...
@property (nonatomic, copy) NSString *limit;
// 房间密码
@property (nonatomic, copy) NSString *passwd;
// 房间状态:是否可以开始游戏 0、否 1、是
@property (nonatomic,assign) ReadyForGame startGame;
// 初始化
-(RoomInfo *)initRoomInfo;

@end
#pragma mark -------- RoomInfo [end] ----------------/

/*
 * 头像、昵称、序号、身份标识（警察、匪徒、平民）、出局玩家头像被统一图片取代、点选某玩家头像的点选框
 * 0、平民  1、警察  2、杀手  3、旁观者
 **/
typedef NS_ENUM(NSInteger, PlayerRole) {
    // 平民
    PlayerRole_civilian = 0,
    // 警察
    PlayerRole_police = 1,
    // 匪徒
    PlayerRole_terrorist = 2,
    // 旁观者
    PlayerRole_bystander = 3
    
};


typedef NS_ENUM(NSInteger, PlayerReady) {
    // 入席
    PlayerReady_sitdown = 1,
    // 旁观
    PlayerReady_outsider,
};

#pragma mark -------- PlayerInfo [begin] ----------------/
@interface PlayerInfo : NSObject
// 当前用户ID
@property (nonatomic ,copy) NSString *userId;
// 头像
@property (nonatomic, copy) NSString *picUrl;
// 头像框
@property (nonatomic, copy) NSString *picFrame;
// 昵称
@property (nonatomic, copy) NSString *nickName;
// 角色
@property (nonatomic, assign) PlayerRole role;
// 是否向警察出示角色身份 YES:亮明身份；NO：隐藏身份
@property (nonatomic, assign) BOOL identity;
// 入席 or 旁观
@property (nonatomic, assign) PlayerReady ready;
// 序号
@property (nonatomic, copy) NSString *num;
// 是否出局，YES：出局；NO：未出局
@property (nonatomic, assign) BOOL   killed;
// 房间号：在通讯中房间号可以做为 topic
@property (nonatomic ,copy) NSString *roomId;
// 是否开启托管：YES、开启了托管；NO、没有开启托管
@property (nonatomic ,assign) BOOL   trusteeship;

@property (nonatomic ,copy) NSString *age;
@property (nonatomic ,copy) NSString *area;
@property (nonatomic ,copy) NSString *failNum;
@property (nonatomic ,copy) NSString *kin;
@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) NSString *winNum;
// 带参数的构造函数
+(PlayerInfo *)initPlayerWithDictionary:(NSDictionary *)m_dict;
@end
#pragma mark -------- PlayerInfo [end] ----------------/


#pragma mark -------- GameConfig [begin] ----------------/
@interface GameConfig : NSObject
// 杀手晚上发言时间 单位：秒
@property (nonatomic, assign) NSInteger murderNightSpeakTime;
// 杀手晚上杀人时间 单位：秒
@property (nonatomic, assign) NSInteger murderNightKillTime;
// 警察晚上发言时间 单位：秒
@property (nonatomic, assign) NSInteger policeNightSpeakTime;
// 警察晚上验人时间 单位：秒
@property (nonatomic, assign) NSInteger policeNightCheckTime;
// 白天发言时间 单位：秒
@property (nonatomic, assign) NSInteger daySpeakTime;
// 白天投票时间 单位：秒
@property (nonatomic, assign) NSInteger dayVoteTime;

-(GameConfig *)initGameConfig;
@end
#pragma mark -------- GameConfig [end] ----------------/


#pragma mark -------- GameProgress [begin] ----------------/
typedef NS_ENUM(NSInteger, DayState) {
    // 天亮
    DayState_dawn = 1,
    // 天黑
    PlayerReady_dark
    
};
@interface GameProgress : NSObject
// 天黑、天亮
@property (nonatomic, assign) DayState dayState;
// 第几天
@property (nonatomic, assign) NSInteger days;
-(GameProgress *)initGameProgress;
@end
#pragma mark -------- GameProgress [end] ----------------/



