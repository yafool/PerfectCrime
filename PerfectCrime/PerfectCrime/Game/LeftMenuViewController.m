//
//  LeftMenuViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/8.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "PlayerViewCell.h"
#import "GameInfoManager.h"
#import "ChatKeyboard.h"   //键盘
#import "ChatModel.h"   //消息模型
#import "ChatUtil.h"
#import "ChatHandler.h"
#import "GameServer.h"
#import "GameHandler.h"
#import "PlayerAlertView.h"
#import "LeftMenuTopView.h"
#import "WhisperView.h"
#import "MainViewController.h"
#import "DataStructure.h"
#import "VoteBoxView.h"
#import "MVPVoteView.h"

#define FRAME_HEIGHT_CollectionView   400

typedef NS_ENUM(NSInteger, WhisperKeyboard) {
    // 键盘可以切换
    WhisperKeyboard_show = 0,
    // 键盘不可以被唤出
    WhisperKeyboard_hide
    
};

@interface LeftMenuViewController ()
<
ChatHandlerDelegate,
GameServerDelegate,
GameHandlerDelegate,
LeftMenuTopViewDelegate,
WhisperViewDelegate,
AgentLeftSlideMenuControllerDelegate
>
{
    UICollectionView *_collectionView;
    LeftMenuTopView *_topView;
    WhisperView *_whisperView;
    NSMutableArray *_collectionAry;
}
//键盘
@property (nonatomic, strong) ChatKeyboard *customKeyboard;
//聊天模型
@property (nonatomic, strong) ChatModel *config;
// 游戏逻辑接口
@property (nonatomic, strong) GameServer *GameServer;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    
    //注册成为 ChatHandler代理
    [[ChatHandler shareInstance]addDelegate:self delegateQueue:nil];
    //注册成为 GameHandler代理
    [[GameHandler shareInstance]addDelegate:self delegateQueue:nil];
}

- (void)viewDidUnload {
    [super viewDidLoad];
    [[ChatHandler shareInstance]removeDelegate:self];
    [[GameHandler shareInstance]removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //系统键盘弹起通知
    [[NSNotificationCenter defaultCenter]addObserver:self.customKeyboard selector:@selector(systemKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //自定义键盘系统键盘降落
    [[NSNotificationCenter defaultCenter]addObserver:self.customKeyboard selector:@selector(keyboardResignFirstResponder:) name:ChatKeyboardResign object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - addSubview
- (void)addTopView{
    if(!_topView){
        CGRect frame = self.view.bounds;
        frame.size.height = FRAME_HEIGHT_TopView;
        _topView = [[LeftMenuTopView alloc]initWithFrame:frame];
        [_topView initMyView:nil];
        _topView.delegate = self;
        [self.view addSubview:_topView];
    }
    
    [_topView changeForUserSit];
}

- (void)addCollectionView{
    if(!_collectionView){
        CGRect frame = self.view.bounds;
        frame.origin.y = FRAME_HEIGHT_TopView;
        frame.size.height = FRAME_HEIGHT_CollectionView;
        // 可以给layout设置全局属性
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // default is UICollectionViewScrollDirectionVetical
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 注册类，是用纯代码生成的collectiviewcell类才行
        [_collectionView registerClass:[PlayerViewCell class] forCellWithReuseIdentifier:@"PlayerViewCell"];
    } else {
        [_collectionView reloadData];
    }
}

- (void)addWhisperView{
    if(!_whisperView){
        CGRect frame = self.view.bounds;
        frame.origin.y = _collectionView.frame.origin.y + FRAME_HEIGHT_CollectionView;
        frame.size.height = frame.size.height - frame.origin.y;
        _whisperView = [[WhisperView alloc]initWithFrame:frame];
        _whisperView.delegate = self;
        [self.view addSubview:_whisperView];
        //初始化键盘
        [self.view addSubview:self.customKeyboard];
        CGRect keyboardFrame = self.view.bounds;
        keyboardFrame.origin.y = keyboardFrame.size.height - kBottomInset;;
        keyboardFrame.size.height = CTKEYBOARD_DEFAULTHEIGHT;
        self.customKeyboard.frame = keyboardFrame;
        self.customKeyboard.hidden = YES;
        [self.customKeyboard setTag:WhisperKeyboard_hide];
    }
}


- (GameServer*)GameServer{
    if (!_GameServer) {
        _GameServer = [[GameServer alloc]init];
        _GameServer.delegate = self;
    }
    
    return _GameServer;
}

#pragma makr --- 初始化聊天元素
- (ChatKeyboard *)customKeyboard
{
    if (!_customKeyboard) {
        _customKeyboard = [ChatKeyboard initWithKeyboardWidth:self.view.frame.size.width];
       
        //传入当前控制器 ，方便打开相册（如放到控制器 ， 后期的逻辑过多，控制器会更加臃肿）
        __weak typeof(self) weakself = self;
        //普通文本消息
        [_customKeyboard textCallback:^(NSString *text) {
            //发送文本
            [weakself sendTextMessage:text];
            
        } audioCallback:^(ChatAlbumModel *audio) {
            
            [weakself sendAudioMessage:audio];
        } picCallback:^(NSArray<ChatAlbumModel *> *images) {
            
            [weakself sendPictureMessage:images];
        } videoCallback:^(ChatAlbumModel *videoModel) {
            
            [weakself sendVideoMessage:videoModel];
        } target:self];
        
    }
    return _customKeyboard;
}

#pragma makr --- 初始化消息模型
- (ChatModel*)config{
    
    if (!_config) {
        
        _config = [[ChatModel alloc]init];
        _config.userId = [[SettingsManager sharedSettingsManager]userId];
        _config.nickName = [[SettingsManager sharedSettingsManager]nickName];
        _config.picUrl = [[SettingsManager sharedSettingsManager]picUrl];
        _config.picFrame = [[SettingsManager sharedSettingsManager]picFrame];
        _config.roomId = [GameInfoManager sharedGameInfoManager].roomInfo.roomId;
        _config.roomName = [GameInfoManager sharedGameInfoManager].roomInfo.roomName;
        _config.chatArea = ChatAreaType_dark;
        _config.progress = @0;
    }
    
    return _config;
}
#pragma mark - 发送文本/表情消息
- (void)sendTextMessage:(NSString *)text
{
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    NSArray *ary = [[GameInfoManager sharedGameInfoManager]players];
    __weak typeof(WhisperView*) weakWhisperView = _whisperView;
    [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:PlayerInfo.class]) {
            PlayerInfo *player = (PlayerInfo*)obj;
            if (player.userId && [player.userId isEqualToString:userId]) {
                [weakWhisperView pillowTalk:player andWhisper:text];
                PCLog(@"userId: %@; player.userId: %@", userId, player.userId);
                *stop = YES;
            }
        }
        
    }];
    //创建文本消息
    ChatModel *textModel = [ChatUtil initTextMessage:text config:self.config];
    //传输文本
    [[ChatHandler shareInstance]sendTextMessage:textModel];
}

#pragma mark - 发送语音消息
- (void)sendAudioMessage:(ChatAlbumModel *)audio
{
    // continue...
}

#pragma mark - 发送图片消息
- (void)sendPictureMessage:(NSArray<ChatAlbumModel *> *)picModels
{
    // continue...
}

#pragma mark - 发送视频消息
- (void)sendVideoMessage:(ChatAlbumModel *)videoModel
{
    // continue...
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
    
}

#pragma mark - UICollectionViewDataSource
// 指定Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _collectionAry.count;
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerInfo *player = _collectionAry[indexPath.row];
    PlayerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerViewCell" forIndexPath:indexPath];
    [cell initMyView:player];
    return cell;
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UICollectionViewDelegate
// 选中操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [PlayerAlertView showWithDictionary:nil
                     andBlacklistAction:^(UIButton *button) {
                         NSLog(@"黑名单");
                     }
                        andFriendAction:^(UIButton *button) {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            [self makeFriend:dict];
                        }];
}

-(void) makeFriend:(NSDictionary*)m_dict{
    
}

#pragma mark - GameServerDelegate
-(void)onGameServerResponseWithID:(GameServerResponseID)enum_id andResponse:(NSDictionary*)m_dict{
    PCLog(@"onGameServerResponseWithID : m_dict=%@", m_dict);
    NSString *code = [m_dict valueForKey:@"code"];
    NSString *msg = [m_dict valueForKey:@"msg"];
    switch (enum_id) {
        case GameServerResponseID_userSit:// 玩家入座
        {
            if ([@"200" isEqualToString:code]) {
                [GameInfoManager sharedGameInfoManager].roomInfo.hoster = [m_dict valueForKey:@"hoster"];
                
            } else{
                [MBProgressHUD showErrorMessage:msg];
            }
            break;
        }
        case GameServerResponseID_startGame:// 开始游戏
        {
            if ([@"200" isEqualToString:code]) {
                NSMutableDictionary *eventDictionary = [[NSMutableDictionary alloc]init];
                [eventDictionary setValue:Message_startGame forKey:@"action"];
                [eventDictionary setValue:@1 forKey:@"day"];
                [eventDictionary setValue:@1 forKey:@"dayornight"];
                [[ChatHandler shareInstance]sendHandleEvent:eventDictionary];
            } else{
                [MBProgressHUD showErrorMessage:msg];
            }
            
            break;
        }
        case GameServerResponseID_voteMVP://选取mvp
        {
            PCLog(@"vote mvp response, code=%@; msg=%@", code, msg);
            break;
        }
        default:
            break;
    }
}

#pragma mark - LeftMenuTopViewDelegate
// 展示入席玩家列表
-(void)OnShowSitDownList{
    if (nil!=_collectionAry) {
        [_collectionAry removeAllObjects];
    } else {
        _collectionAry = [[NSMutableArray alloc]init];
    }
    NSArray *players = [[GameInfoManager sharedGameInfoManager]players];
    for (PlayerInfo *player in players) {
        if (PlayerReady_sitdown == player.ready) {
            [_collectionAry addObject:player];
        }
    }
    
    [_collectionView reloadData];
}
// 展示全部玩家列表
-(void)OnShowAllPlayerList{
    if (nil!=_collectionAry) {
        [_collectionAry removeAllObjects];
    }
    
    _collectionAry = [[NSMutableArray alloc]initWithArray:[GameInfoManager sharedGameInfoManager].players];
    [_collectionView reloadData];
}
// 房主在入席人满后可以点击开始游戏（仅房住有权）
-(void)OnOptionPlaying{
    RoomInfo *roomInfo = [GameInfoManager sharedGameInfoManager].roomInfo;
    NSString *roomId = roomInfo.roomId;
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    NSMutableDictionary *postDist = [[NSMutableDictionary alloc]init];
    [postDist setObject:roomId forKey:@"roomId"];
    [postDist setObject:userId forKey:@"userId"];
    [self.GameServer requestStartGame:postDist];
    
}
// 非房住进入房间后点击按钮入席
-(void)OnOptionSit{
    // 1、入座 2、离座
    NSString *type = @"1";
    RoomInfo *roomInfo = [GameInfoManager sharedGameInfoManager].roomInfo;
    NSString *roomId = roomInfo.roomId;
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    NSMutableDictionary *postDist = [[NSMutableDictionary alloc]init];
    [postDist setObject:roomId forKey:@"roomId"];
    [postDist setObject:userId forKey:@"userId"];
    [postDist setObject:type forKey:@"type"];
    [self.GameServer requestUserSit:postDist];
    
}
// 非房住进入房间后点击按钮离席
-(void)OnOptionLeave{
    // 0、进入房间 1、入座 2、离座
    NSString *type = @"2";
    RoomInfo *roomInfo = [GameInfoManager sharedGameInfoManager].roomInfo;
    NSString *roomId = roomInfo.roomId;
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    NSMutableDictionary *postDist = [[NSMutableDictionary alloc]init];
    [postDist setObject:roomId forKey:@"roomId"];
    [postDist setObject:userId forKey:@"userId"];
    [postDist setObject:type forKey:@"type"];
    [self.GameServer requestUserSit:postDist];
    
}

#pragma mark - WhisperViewDelegate
-(void)OnWhisperViewDidScroll{
    // 切换键盘
    PlayerInfo *myself = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if (!myself.killed
        && WhisperKeyboard_show == self.customKeyboard.tag
        && (PlayerRole_police == myself.role || PlayerRole_terrorist == myself.role)) {
        self.customKeyboard.hidden = !self.customKeyboard.hidden;
    }
}
#pragma mark - AgentLeftSlideMenuControllerDelegate
-(void)onLeftWillOpen{
    
    UILabel *custom = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kTopInset)];
    custom.text = [GameInfoManager sharedGameInfoManager].roomInfo.roomName;
    custom.textColor = [CustomColorRGB colorWithHexString:kNavColor];
    [self.navigationItem setItemWithCustomView:custom itemType:left];
    
    _collectionAry = [[NSMutableArray alloc]initWithArray:[[GameInfoManager sharedGameInfoManager]players]];

    [self addTopView];
    [self addCollectionView];
    [self addWhisperView];
}


#pragma mark ---- [ChatHandlerDelegate] --- 接收消息
- (void)didReceiveChatMessage:(ChatModel *)chatModel
{
    if (ChatAreaType_dark != chatModel.chatArea) {
        PCLog(@"WhisperView not process message with chatArea=%ld",chatModel.chatArea);
        return;
    }
    PlayerInfo *myself = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    
    if([myself.userId isEqualToString:chatModel.userId]){
        return;
    }
        
    for (PlayerInfo *player in [GameInfoManager sharedGameInfoManager].players) {
        if ([chatModel.userId isEqualToString:player.userId]) {
            if (myself.role == player.role) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_whisperView pillowTalk:player andWhisper:chatModel.content.text];
                });
            }
            break;
        }
    }
}

- (void)didReceiveEventMessage:(id)data
{
    NSString *action = [data objectForKey:@"action"];
    if ([Message_userInRoom isEqualToString:action]) {
        //推送玩家入座
        NSString *userId = [[data objectForKey:@"userId"] stringValue];
       
        for (PlayerInfo *player in [GameInfoManager sharedGameInfoManager].players) {
            if ([userId isEqualToString:player.userId]) {
                NSString *status = [data objectForKey:@"status"];
                player.ready = [status integerValue];
                break;
            }
        }
        
        [GameInfoManager sharedGameInfoManager].roomInfo.startGame = [[data objectForKey:@"startGame"]integerValue];
        
        for (PlayerInfo *player in _collectionAry) {
            if ([userId isEqualToString:player.userId]) {
                NSString *status = [data objectForKey:@"status"];
                player.ready = [status integerValue];
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_topView changeForUserSit];
            [_collectionView reloadData];
        });
        
        
    } else if ([Message_userEnterRoom isEqualToString:action]) {
        //推送玩家进入房间
        NSString *userId = [[data objectForKey:@"userId"] stringValue];
        for (PlayerInfo *player in [GameInfoManager sharedGameInfoManager].players) {
            if ([userId isEqualToString:player.userId]) {
                [[GameInfoManager sharedGameInfoManager].players removeObject:player];
                break;
            }
        }
        PlayerInfo *player = [PlayerInfo initPlayerWithDictionary:data];
        [[GameInfoManager sharedGameInfoManager].players addObject:player];
        
        [_collectionAry removeAllObjects];
        [_collectionAry addObjectsFromArray:[GameInfoManager sharedGameInfoManager].players];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_topView changeForUserSit];
            [_topView changeToPlayers];
            [_collectionView reloadData];
        });
    } else if ([Message_userRole isEqualToString:action]) {
        //推送玩家角色
        NSArray *dataAry = [data objectForKey:@"data"];
        for (NSDictionary *dict in dataAry){
            NSString *userId = [dict valueForKey:@"userId"];
            for (PlayerInfo *player in [GameInfoManager sharedGameInfoManager].players) {
                if ([player.userId isEqualToString:userId]) {
                    player.role = [[dict valueForKey:@"userRole"]integerValue];
                    player.num = [NSString stringWithFormat:@"%@",[dict valueForKey:@"num"]];
                    break;
                }
            }
        }
        // conlectionView 切换到全部玩家列表
        [_collectionAry removeAllObjects];
        [_collectionAry addObjectsFromArray:[GameInfoManager sharedGameInfoManager].players];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_topView changeToPlayers];
            [_topView changeForUserSit];
            [_collectionView reloadData];
        });
    } else if ([Message_userLeaveRoom isEqualToString:action]) {
        //推送玩家离开房间
        NSString *roomId = [NSString stringWithFormat:@"%@",[data objectForKey:@"roomId"]];
        NSString *userId = [NSString stringWithFormat:@"%@",[data objectForKey:@"userId"]];
        NSInteger end    = [[data objectForKey:@"end"]integerValue];
        PCLog(@"action:userLeaveRoom roomId=%@; userId=%@; end=%ld", roomId, userId, end);
        
        
        // 更新房间里玩家列表
        for (PlayerInfo *player in [GameInfoManager sharedGameInfoManager].players) {
            if ([userId isEqualToString:player.userId]) {
                if (0 == end) {// 游戏没有结束
                    player.trusteeship = true;
                } else if(1 == end){// 游戏已经结束了
                    [[GameInfoManager sharedGameInfoManager].players removeObject:player];
                }
                
                break;
            }
        }
        
        // 更新 conlectionView
        for (PlayerInfo *player in _collectionAry) {
            if ([userId isEqualToString:player.userId]) {
                if (0 == end) {// 游戏没有结束
                    player.trusteeship = true;
                } else if(1 == end){// 游戏已经结束了
                    [_collectionAry removeObject:player];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                });
                break;
            }
        }
    } else if ([Message_startGame isEqualToString:action]) {
        NSInteger days = [[data objectForKey:@"day"]integerValue];
        DayState daystate = [[data objectForKey:@"dayornight"]integerValue];
        [GameInfoManager sharedGameInfoManager].gameProgress.days=days;
        [GameInfoManager sharedGameInfoManager].gameProgress.dayState=daystate;
        [[GameHandler shareInstance] gameBegin];
    } else if ([Message_mpvresult isEqualToString:action]) {
        //推送mpv结果
        NSString *mpvId = [data objectForKey:@"mpv"];
        
        for (PlayerInfo *player in [GameInfoManager sharedGameInfoManager].players) {
            if ([mpvId isEqualToString:player.userId]) {
                [MBProgressHUD showInfoMessage: [NSString stringWithFormat:@"%@ 被选举为本次的MVP", player.userId]];
            }
        }
        
    } else if ([Message_gameover isEqualToString:action]) {
        //推送游戏结束
        [[GameHandler shareInstance] gameEnd];
    } else if ([Message_changeHoster isEqualToString:action]) {
        // 推送房主变更
        [GameInfoManager sharedGameInfoManager].roomInfo.hoster = [data objectForKey:@"hoster"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_topView changeForUserSit];
        });
    }
}

- (void)sendMessageTimeOutWithTag:(long)tag{

}

#pragma mark ---- [GameHandlerDelegate]  游戏逻辑
// 天黑请闭眼
- (void)atNightfall{
    [self.customKeyboard setTag:WhisperKeyboard_hide];
    self.customKeyboard.hidden = YES;
}
// 警察交流
- (void)policeTalk{
    PlayerInfo *player = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if (PlayerRole_police == player.role) {
        [self.customKeyboard setTag:WhisperKeyboard_show];
        self.customKeyboard.hidden = NO;
    }
}
// 警察开始验人
- (void)policeCheck{
    PlayerInfo *player = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if (PlayerRole_police == player.role) {
        [self.customKeyboard setTag:WhisperKeyboard_hide];
        self.customKeyboard.hidden = YES;
    }
}
// 验人
- (void)vote2Check:(PlayerInfo*)player{
    // player 向警察亮明身份
    for (PlayerInfo *playerInfo in _collectionAry) {
        if ([playerInfo.userId isEqualToString:player.userId]) {
            playerInfo.identity = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
            break;
        }
    }
}
// 匪徒交流
- (void)terroristTalk{
    PlayerInfo *player = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if (PlayerRole_terrorist == player.role) {
        [self.customKeyboard setTag:WhisperKeyboard_show];
        self.customKeyboard.hidden = NO;
    }
}
// 匪徒开始杀人
- (void)terroristKill{
    PlayerInfo *player = [[GameInfoManager sharedGameInfoManager]getPlayerSelf];
    if (PlayerRole_terrorist == player.role) {
        [self.customKeyboard setTag:WhisperKeyboard_hide];
        self.customKeyboard.hidden = YES;
    }
}
// 杀人
- (void)vote2Kill:(PlayerInfo*)player{
    // player 出局
    for (PlayerInfo *playerInfo in _collectionAry) {
        if ([playerInfo.userId isEqualToString:player.userId]) {
            playerInfo.killed = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
            break;
        }
    }
}
// 白天的投票
- (void)voteAtDay:(PlayerInfo*)player{
    for (PlayerInfo *playerInfo in _collectionAry) {
        if ([playerInfo.userId isEqualToString:player.userId]) {
            playerInfo.killed = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
            break;
        }
    }
}
// 天黑倒计时
- (void)nightfallTicker:(NSString*)title{
    [_topView changeForCountdown:title];
}

// 游戏结束
- (void)gameOver{
    [MVPVoteView showWitVoteActionBlock:^(PlayerInfo *player){
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
        [postDict setValue:[SettingsManager sharedSettingsManager].userId forKey:@"userId"];
        [postDict setValue:[GameInfoManager sharedGameInfoManager].roomInfo.roomId forKey:@"roomId"];
        [postDict setValue:player.userId forKey:@"mpv"];
        
        [self.GameServer requestVoteMVP:postDict];
    }];
};

@end
