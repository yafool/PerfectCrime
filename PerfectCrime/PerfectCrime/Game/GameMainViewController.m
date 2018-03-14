//
//  GameMainViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/8.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "GameMainViewController.h"
#import "ChatKeyboard.h"   //键盘
#import "ChatTextCell.h"   //文本cell
#import "ChatAudioCell.h" //语音cell
#import "ChatImageCell.h" //图片cell
#import "ChatVideoCell.h"  //视频cell
#import "ChatFileCell.h"  // 文件cell
#import "ChatTipCell.h"  //提示语cell
#import "ChatModel.h"   //消息模型
#import "ChatUtil.h"    //工具类
#import "ChatAudioPlayTool.h" //语音播放器
#import "NSString+extension.h"
#import "GameInfoManager.h"
#import "GameServer.h"
#import "GameHandler.h"
#import "DataStructure.h"
#import "ChatHandler.h"
#import "MainTopView.h"
#import "HomeServer.h"
#import "VoteBoxView.h"
#import "MVPVoteView.h"

@interface GameMainViewController ()
<ChatHandlerDelegate,
HomeServerDelegate,
GameHandlerDelegate,
GameServerDelegate>

// 顶部指示view
@property (nonatomic, strong) MainTopView *topView;
//聊天列表
@property (nonatomic, strong) UITableView *chatTableView;
//消息数据源
@property (nonatomic, strong) NSMutableArray *talkMessages;
//titleView
@property (nonatomic, strong) UILabel *titleView;
//铃铛
@property (nonatomic, strong) UIImageView *bellView;
//键盘
@property (nonatomic, strong) ChatKeyboard *customKeyboard;
//语音播放器
@property (nonatomic, strong) ChatAudioPlayTool *audioPlayTool;
//聊天模型
@property (nonatomic, strong) ChatModel *config;
// 房间接口
@property (nonatomic, strong) HomeServer *HomeServer;
// 游戏接口
@property (nonatomic, strong) GameServer *GameServer;

@end


@implementation GameMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XNTabBarController hideTabbar];
    
    //系统键盘弹起通知
    [[NSNotificationCenter defaultCenter]addObserver:self.customKeyboard selector:@selector(systemKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //自定义键盘系统键盘降落
    [[NSNotificationCenter defaultCenter]addObserver:self.customKeyboard selector:@selector(keyboardResignFirstResponder:) name:ChatKeyboardResign object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [XNTabBarController showTabbar];
    // 禁用 slide menu
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate disableSlidMenu];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //渐变光泽
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIMainBackColor CGColor],(id)[[UIColor lightGrayColor]CGColor],nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    //初始化navgationBar
    [self.navigationItem setItemWithTitle:[GameInfoManager sharedGameInfoManager].roomInfo.roomName textColor:[CustomColorRGB colorWithHexString:kNavColor] fontSize:18 itemType:center];
    
    CustomBarItem *leftItem = [self.navigationItem setItemWithImage:@"NavBackButton" size:CGSizeMake(60, 35) itemType:left];
    [leftItem setOffset:0];//设置item偏移量(正值向左偏，负值向右偏)
    [leftItem addTarget:self selector:@selector(popToBack) event:(UIControlEventTouchUpInside)];
    
    // 启用 slide menu
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate enableSlidMenu];
    
    //获取房间中当前玩家列表
    [self requestHomePlayers];
    //初始化UI
    [self initUI];
    //拉取数据库消息
    [self getHistoryMessages];
    //注册成为handler代理
    [[ChatHandler shareInstance]addDelegate:self delegateQueue:nil];
    //注册成为 GameHandler代理
    [[GameHandler shareInstance]addDelegate:self delegateQueue:nil];
    //获取游戏配置信息
    [self.GameServer requestGetConfig:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ChatModel*)config{
    
    if (!_config) {
        
        _config = [[ChatModel alloc]init];
        _config.userId = [[SettingsManager sharedSettingsManager]userId];
        _config.nickName = [[SettingsManager sharedSettingsManager]nickName];
        _config.picUrl = [[SettingsManager sharedSettingsManager]picUrl];
        _config.picFrame = [[SettingsManager sharedSettingsManager]picFrame];
        _config.roomId = [GameInfoManager sharedGameInfoManager].roomInfo.roomId;
        _config.roomName = [GameInfoManager sharedGameInfoManager].roomInfo.roomName;
        _config.chatArea = ChatAreaType_dawn;
        _config.progress = @0;
    }
    
    return _config;
}
#pragma mark --- 初始化接口
- (HomeServer*)HomeServer{
    if (!_HomeServer) {
        _HomeServer = [[HomeServer alloc]init];
        _HomeServer.delegate = self;
    }
    
    return _HomeServer;
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
        //_customKeyboard = [[ChatKeyboard alloc]init];
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

- (UIImageView *)bellView
{
    if (!_bellView) {
        _bellView = [[UIImageView alloc]init];
        _bellView.image = LoadImage(@"grey_bell");
    }
    return _bellView;
}
- (UILabel *)titleView
{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.font = FontSet(16);
        _titleView.textColor = UIMainWhiteColor;
        _titleView.textAlignment = NSTextAlignmentLeft;
        //铃铛
        [_titleView addSubview:self.bellView];
    }
    return _titleView;
}

- (NSMutableArray *)talkMessages
{
    if (!_talkMessages) {
        _talkMessages = [NSMutableArray array];
    }
    return _talkMessages;
}

- (MainTopView *)topView
{
    CGRect frame = self.view.bounds;
    frame.size.height = FRAME_HEIGHT_TopView;
    if (!_topView) {
        _topView = [[MainTopView alloc]initWithFrame:frame];
        _topView.backgroundColor = UIMainBackColor;
        
    }
    return _topView;
}

- (UITableView *)chatTableView
{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:Frame(0, FRAME_HEIGHT_TopView, SCREEN_WITDTH, Height(self.view.bounds)-49) style:UITableViewStylePlain];
        _chatTableView.backgroundColor = [UIColor clearColor];
        
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.allowsSelection = NO;
        _chatTableView.delegate     = self;
        _chatTableView.dataSource = self;
        //普通文本,表情消息类型
        [_chatTableView registerClass:[ChatTextCell class] forCellReuseIdentifier:@"ChatTextCell"];
        //语音消息类型
        [_chatTableView registerClass:[ChatAudioCell class] forCellReuseIdentifier:@"ChatAudioCell"];
        //图片消息类型
        [_chatTableView registerClass:[ChatImageCell class] forCellReuseIdentifier:@"ChatImageCell"];
        //视频消息类型
        [_chatTableView registerClass:[ChatVideoCell class] forCellReuseIdentifier:@"ChatVideoCell"];
        //文件消息类型
        [_chatTableView registerClass:[ChatFileCell class] forCellReuseIdentifier:@"ChatFileCell"];
        //提示消息类型
        [_chatTableView registerClass:[ChatTipCell class] forCellReuseIdentifier:@"ChatTipCell"];
    }
    return _chatTableView;
}

#pragma mark - 拉取数据库消息
- (void)getHistoryMessages
{
    
}

#pragma mark - 初始化UI
- (void)initUI
{
    //初始化顶部指示view
    [self.view addSubview:self.topView];
    //初始化聊天界面
    [self.view addSubview:self.chatTableView];
    //初始化键盘
    [self.view addSubview:self.customKeyboard];
    
    CGRect frame = self.view.bounds;
    
    frame.origin.y = frame.size.height - kTopInset - kBottomInset;
    frame.size.height = CTKEYBOARD_DEFAULTHEIGHT;
    self.customKeyboard.frame = frame;
    self.customKeyboard.hidden = YES;
}


-(void)requestHomePlayers{
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    NSString *roomId = [GameInfoManager sharedGameInfoManager].roomInfo.roomId;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
    [postDict setValue:userId forKey:@"userId"];
    [postDict setValue:roomId forKey:@"roomId"];
    
    [self.HomeServer requestHomePlayers:postDict];
}

-(void)exitRoom{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
    [postDict setValue:[SettingsManager sharedSettingsManager].userId forKey:@"userId"];
    [postDict setValue:[GameInfoManager sharedGameInfoManager].roomInfo.roomId forKey:@"roomId"];
    
    [self.HomeServer requestHomeExit:postDict];
    
    [[ChatHandler shareInstance] removeDelegate:self];
    [[GameHandler shareInstance] removeDelegate:self];
    
}
- (void)popToBack{
    [self exitRoom];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送文本/表情消息
- (void)sendTextMessage:(NSString *)text
{
    //创建文本消息
    ChatModel *textModel = [ChatUtil initTextMessage:text config:self.config];
    [self.talkMessages addObject:textModel];
    [self.chatTableView reloadData];
    [self scrollToBottom];
    //传输文本
    [[ChatHandler shareInstance]sendTextMessage:textModel];
}

#pragma mark - 发送语音消息
- (void)sendAudioMessage:(ChatAlbumModel *)audio
{
    ChatModel *audioModel = [ChatUtil initAudioMessage:audio config:_config];
    [self.talkMessages addObject:audioModel];
    [self.chatTableView reloadData];
    [self scrollToBottom];
    //传输
    [[ChatHandler shareInstance]sendAudioMessage:audioModel];
}

#pragma mark - 发送图片消息
- (void)sendPictureMessage:(NSArray<ChatAlbumModel *> *)picModels
{
    //消息基本信息配置
    NSArray *picMessages = [ChatUtil initPicMessage:picModels config:_config];
    [self.talkMessages addObjectsFromArray:picMessages];
    [self.chatTableView reloadData];
    [self scrollToBottom];
    [[ChatHandler shareInstance]sendPicMessage:picMessages];
}

#pragma mark - 发送视频消息
- (void)sendVideoMessage:(ChatAlbumModel *)videoModel
{
    
}

#pragma mark - 滚动,点击等相关处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter]postNotificationName:ChatKeyboardResign object:nil];
}

#pragma mark - 滚动到底部
- (void)scrollToBottom
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_talkMessages.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - 播放语音
- (void)playAudio:(NSString *)path
{
    self.audioPlayTool = [ChatAudioPlayTool audioPlayTool:path];
    [self.audioPlayTool play];
}

#pragma mark ---- [ChatHandlerDelegate] --- 接收消息
- (void)didReceiveChatMessage:(ChatModel *)chatModel
{
    
    if (ChatAreaType_dawn != chatModel.chatArea) {
        PCLog(@"GameMainView not process message with chatArea=%ld",chatModel.chatArea);
        return;
    }
    
    NSString *userId = [SettingsManager sharedSettingsManager].userId;
    if (userId && [userId isEqualToString:chatModel.userId]) {
        NSArray *ary = [NSArray arrayWithArray:self.talkMessages];

        [self.talkMessages removeAllObjects];
        [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChatModel *model = (ChatModel*)obj;
            if ([userId isEqualToString:model.userId]) {
                model.isSend = YES;
                model.isSending=NO;
                model.byMyself = YES;
            }
            
            [self.talkMessages addObject:model];
        }];
        //刷新 TableView
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chatTableView reloadData];
        });
        
    } else {
        chatModel.isSend = YES;
        chatModel.isSending=NO;
        chatModel.byMyself = NO;
        [self.talkMessages addObject:chatModel];
        
        //刷新 TableView
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chatTableView reloadData];
            [self scrollToBottom];
        });
        
    }
   
}

#pragma mark --- [dataSource]

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.talkMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel *chatModel = self.talkMessages[indexPath.row];
    __weak typeof(self) weakself = self;
    //文本,表情消息
    if (hashEqual(chatModel.contenType, Content_Text)) {
        
        ChatTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"ChatTextCell"];
        textCell.textModel = chatModel;
        return textCell;
        
        //语音消息
    }else if (hashEqual(chatModel.contenType, Content_Audio)){
        
        ChatAudioCell *audioCell = [tableView dequeueReusableCellWithIdentifier:@"ChatAudioCell"];
        audioCell.audioModel      = chatModel;
        //重新发送
        [audioCell sendAgain:^(ChatModel *audioModel) {
            
            //播放语音
        } playAudio:^(NSString *path) {
            
            [weakself playAudio:path];
            //长按操作
        } longpress:^(LongpressSelectHandleType type, ChatModel *audioModel) {
            
            //用户详情
        } toUserInfo:^(NSString *userID) {
            
        }];
        return audioCell;
        
        //图片消息
    }else if (hashEqual(chatModel.contenType, Content_Picture)){
        
        ChatImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"ChatImageCell"];
        imageCell.imageModel = chatModel;
        return imageCell;
        
        //视频消息
    }else if (hashEqual(chatModel.contenType, Content_Video)){
        
        ChatVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"ChatVideoCell"];
        
        return videoCell;
        
        //文件消息
    }else if (hashEqual(chatModel.contenType, Content_File)){
        
        ChatFileCell *fileCell = [tableView dequeueReusableCellWithIdentifier:@"ChatFileCell"];
        
        return fileCell;
        
        //提示语消息
    }else{
        
        ChatTipCell *tipCell = [tableView dequeueReusableCellWithIdentifier:@"ChatTipCell"];
        
        return tipCell;
    }
}

#pragma mark --- [delegate]
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel *chatmodel = self.talkMessages[indexPath.row];
    ChatModel *premodel  = nil;
    if (self.talkMessages.count > 1) premodel = self.talkMessages[self.talkMessages.count - 2];
    //如果已经计算过 , 直接返回高度
    if (chatmodel.messageHeight) return  chatmodel.messageHeight;
    //计算消息高度
    return [ChatUtil heightForMessage:chatmodel premodel:premodel];
}

#pragma mark ------------------- HomeServerDelegate ---------------------
-(void)responseWithServerID:(HomeServerID)requestid andResponse:(NSMutableDictionary *) response{
    if(!response){
        PCLog(@"HomeServerDelegate response is nil! requestid=%ld", requestid);
        return;
    }
    
    NSString *code = [response valueForKey:@"code"];
    NSString *msg = [response valueForKey:@"msg"];
    
    switch (requestid) {
        
        case HomeServerIDhomeExit:{
            if ( 200 == [code integerValue]) {
                [[ChatHandler shareInstance]executeDisconnectServer];
            } else {
                [MBProgressHUD showInfoMessage:msg];
            }
            break;
        }
        case HomeServerIDhomePlayers:{
            if ( 200 == [code integerValue]) {
                NSArray *plays = [response valueForKey:@"data"];
                [[GameInfoManager sharedGameInfoManager]updatePlayers:plays];
                NSString *roomId = [GameInfoManager sharedGameInfoManager].roomInfo.roomId;
                [[ChatHandler shareInstance]connectServer:roomId];
                
            } else {
                [MBProgressHUD showInfoMessage:msg];
            }
            break;
        }
        default:{
            PCLog(@"HomeServerDelegate response: code=%@; msg=%@", code, msg);
            break;
        }
    }
}

#pragma mark - GameServerDelegate
-(void)onGameServerResponseWithID:(GameServerResponseID)enum_id andResponse:(NSDictionary*)m_dict{
    PCLog(@"onGameServerResponseWithID : m_dict=%@", m_dict);
    NSString *code = [NSString stringWithFormat:@"%@", [m_dict valueForKey:@"code"]];
    NSString *msg = [m_dict valueForKey:@"msg"];
    switch (enum_id) {
        case GameServerResponseID_config:
        {
            if ([@"200" isEqualToString:code]) {
                [[GameInfoManager sharedGameInfoManager]updateGameConfig:m_dict];
            } else{
                [MBProgressHUD showErrorMessage:msg];
            }
            break;
        }
        
        default:
            break;
    }
}

#pragma mark - 键盘降落
- (void)keyboardResignFirstResponder:(NSNotification *)note
{
    PCLog(@"keyboardResignFirstResponder %@", note)
}

#pragma mark - GameHandlerDelegate

// 天亮了
- (void)atDaybreak{
    [_topView setProcessTitle];
}
// 天亮后依次发言
- (void)speakByPlayer:(PlayerInfo*)player{
    PlayerInfo *myself = [[GameInfoManager sharedGameInfoManager] getPlayerSelf];
    if (myself.userId == player.userId) {//自己发言时间到，关闭键盘
        self.customKeyboard.hidden = NO;
    } else {
        self.customKeyboard.hidden = YES;
    }
}
// 玩家托管了
- (void)trusteeshipPlayer:(PlayerInfo*)player{
    PlayerInfo *myself = [[GameInfoManager sharedGameInfoManager] getPlayerSelf];
    if (myself.userId == player.userId) {//自己发言时间到，关闭键盘
        ChatModel *textModel = [ChatUtil initTextMessage:@"已托管，下一个" config:self.config];
        [self.talkMessages addObject:textModel];
        [self.chatTableView reloadData];
        [self scrollToBottom];
        //传输文本
        [[ChatHandler shareInstance]sendTextMessage:textModel];
    }
}
// 开始曝匪
- (void)killTerrorist{
    self.customKeyboard.hidden = YES;
}
// 白天的投票
- (void)voteAtDay:(PlayerInfo*)player{
    dispatch_async(dispatch_get_main_queue(), ^{
        [VoteBoxView showWithVoteType:VoteBoxType_atDaybreak andVoteActionBlock:^(VoteBoxType type, PlayerInfo *player) {
            // player 被投死了
            [MBProgressHUD showInfoMessage:[NSString stringWithFormat:@"%@号玩家%@出局了",player.num, player.nickName]];
        }];
    });    
}
// 游戏结束
- (void)gameOver{
    self.customKeyboard.hidden = YES;
}
// 天亮倒计时
- (void)daybreakTicker:(NSString*)title{
    [_topView setCountdownTitle:title];
}
@end
