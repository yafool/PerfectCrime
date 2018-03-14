//
//  RightMenuViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/8.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "RightMenuViewController.h"
#import "ChatKeyboard.h"   //键盘
#import "ChatTextCell.h"   //文本cell
#import "ChatImageCell.h" //图片cell
#import "ChatTipCell.h"  //提示语cell
#import "ChatModel.h"   //消息模型
#import "ChatUtil.h"    //工具类
#import "ChatHandler.h"
#import "NSString+extension.h"
#import "GameInfoManager.h"
#import "HomeServer.h"

@interface RightMenuViewController ()
<UITableViewDelegate,
UITableViewDataSource,
ChatHandlerDelegate>

@property (nonatomic, strong) RoomInfo *roomInfo;
@property (nonatomic, strong) NSMutableArray *players;
//聊天列表
@property (nonatomic, strong) UITableView *chatTableView;
//消息数据源
@property (nonatomic, strong) NSMutableArray *talkMessages;
//键盘
@property (nonatomic, strong) ChatKeyboard *customKeyboard;
//聊天模型
@property (nonatomic, strong) ChatModel *config;


@end

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    
    //注册成为 ChatHandler代理
    [[ChatHandler shareInstance]addDelegate:self delegateQueue:nil];
}

- (void)viewDidUnload {
    [super viewDidLoad];
    [[ChatHandler shareInstance]removeDelegate:self];
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

- (ChatModel*)config{
    
    if (!_config) {
        
        _config = [[ChatModel alloc]init];
        _config.userId = [[SettingsManager sharedSettingsManager]userId];
        _config.nickName = [[SettingsManager sharedSettingsManager]nickName];
        _config.picUrl = [[SettingsManager sharedSettingsManager]picUrl];
        _config.picFrame = [[SettingsManager sharedSettingsManager]picFrame];
        _config.roomId = [GameInfoManager sharedGameInfoManager].roomInfo.roomId;
        _config.roomName = [GameInfoManager sharedGameInfoManager].roomInfo.roomName;
        _config.chatArea = ChatAreaType_onlookers;
        _config.progress = @0;
    }
    
    return _config;
}

- (NSMutableArray *)talkMessages
{
    if (!_talkMessages) {
        _talkMessages = [NSMutableArray array];
    }
    return _talkMessages;
}


- (UITableView *)chatTableView
{
    CGRect frame = self.view.bounds;
    frame.size.height = Height(self.view.bounds)- FRAME_HEIGHT_TopView - 49;
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.backgroundColor = UIMainBackColor;
        _chatTableView.allowsSelection = NO;
        _chatTableView.delegate     = self;
        _chatTableView.dataSource = self;
        //普通文本,表情消息类型
        [_chatTableView registerClass:[ChatTextCell class] forCellReuseIdentifier:@"ChatTextCell"];
        //图片消息类型
        [_chatTableView registerClass:[ChatImageCell class] forCellReuseIdentifier:@"ChatImageCell"];
        //提示消息类型
        [_chatTableView registerClass:[ChatTipCell class] forCellReuseIdentifier:@"ChatTipCell"];
    }
    return _chatTableView;
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

#pragma mark - 发送语音消息
- (void)sendAudioMessage:(ChatAlbumModel *)audio
{
    
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

#pragma mark - 初始化UI
- (void)initUI
{
    //初始化聊天界面
    [self.view addSubview:self.chatTableView];
    //初始化键盘
    [self.view addSubview:self.customKeyboard];
    CGRect frame = self.view.bounds;
    frame.origin.y = Height(self.view.bounds) - 49;
    frame.size.height = CTKEYBOARD_DEFAULTHEIGHT;
    self.customKeyboard.frame = frame;
    
}

#pragma mark - 拉取数据库消息
- (void)getHistoryMessages
{
    
}

#pragma mark - AgentRightSlideMenuControllerDelegate
-(void)onRightWillOpen{
    // NavgationBar
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
  
    UILabel *custom = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kTopInset)];
    custom.textColor = [CustomColorRGB colorWithHexString:kNavColor];
    custom.text = @"围观闲聊区";
    [self.navigationItem setItemWithCustomView:custom itemType:left];
    
    //系统键盘弹起通知
    [[NSNotificationCenter defaultCenter]addObserver:self.customKeyboard selector:@selector(systemKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //自定义键盘系统键盘降落
    [[NSNotificationCenter defaultCenter]addObserver:self.customKeyboard selector:@selector(keyboardResignFirstResponder:) name:ChatKeyboardResign object:nil];
    
    //初始化UI
    [self initUI];
    //拉取数据库消息
    [self getHistoryMessages];
    
}

-(void)onRightDidOpen{
    PCLog(@"RightMenuViewController::onRightDidOpen");
}

-(void)onRightWillClose{
    PCLog(@"RightMenuViewController::onRightWillClose");
}
-(void)onRightDidClose{
    PCLog(@"RightMenuViewController::onRightDidClose");
}

#pragma mark ---- [Delegate] --- 接收消息
- (void)didReceiveChatMessage:(ChatModel *)chatModel
{
    if (ChatAreaType_onlookers != chatModel.chatArea) {
        PCLog(@"RightMenuView not process message with chatArea=%ld",chatModel.chatArea);
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


- (void)didReceiveEventMessage:(id)data
{
    NSString *action = [data objectForKey:@"action"];
    if ([Message_userInRoom isEqualToString:action]) {
        //推送玩家入座
        
    } else if ([Message_userEnterRoom isEqualToString:action]) {
        //推送玩家进入房间
        
    } else if ([Message_userRole isEqualToString:action]) {
        //推送玩家角色
        
    } else if ([Message_killUser isEqualToString:action]) {
        //推送天黑杀手杀人
        
    } else if ([Message_killResult isEqualToString:action]) {
        //推送杀人结果
        
    } else if ([Message_policeCheckUser isEqualToString:action]) {
        //推送警察验人结果
        
    } else if ([Message_playerSpeak isEqualToString:action]) {
        //天亮了玩家依次发言
        
    } else if ([Message_voteResult isEqualToString:action]) {
        //投票结果
        
    } else if ([Message_gameover isEqualToString:action]) {
        //推送游戏结束
        
    } else if ([Message_userLeaveRoom isEqualToString:action]) {
        //推送玩家离开房间
        
    } else if ([Message_mpvresult isEqualToString:action]) {
        //推送mpv结果
        
    } else if ([Message_InvalidReceipt isEqualToString:action]) {
        //消息发送失败回执
        
    } else if ([Message_Unknow isEqualToString:action]) {
        //消息发送失败
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
        
        //图片消息
    }else if (hashEqual(chatModel.contenType, Content_Picture)){
        
        ChatImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"ChatImageCell"];
        imageCell.imageModel = chatModel;
        return imageCell;
        
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


@end
