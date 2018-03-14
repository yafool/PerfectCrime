//
//  VoteBoxView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/11/7.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "VoteBoxView.h"
#import "GameInfoManager.h"
#import "VoteViewCell.h"
#import "GameHandler.h"
#import "ChatHandler.h"
#import "GameServer.h"

@interface VoteBoxView ()
<ChatHandlerDelegate,
GameHandlerDelegate,
GameServerDelegate>
{
    VoteBoxType         voteBoxType;
    NSMutableArray      *collectionArry;
    VoteActionBlock     voteActionBlock;
    NSInteger           contentHeight;
    NSMutableDictionary *eventDictionary;
}
@property (nonatomic, strong) UILabel           *lb_title;
@property (nonatomic, strong) UIView            *ui_content;
@property (nonatomic, strong) UICollectionView  *cv_voters;
@property (nonatomic, strong) UIImageView       *imv_lineTop;
@property (nonatomic, strong) UIImageView       *imv_lineBottom;

@property (nonatomic, strong) GameServer        *GameServer;
@end

@implementation VoteBoxView

- (GameServer*)GameServer{
    if (!_GameServer) {
        _GameServer = [[GameServer alloc]init];
        _GameServer.delegate = self;
    }
    
    return _GameServer;
}

+ (DlgAppearance *)appearances{
    static DlgAppearance* appearance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [[DlgAppearance alloc] init];
    });
    
    return appearance;
}

+ (void)showWithVoteType:(VoteBoxType)type andVoteActionBlock:(VoteActionBlock)voteActionBlock{
    VoteBoxView* alertView = [[VoteBoxView alloc]_initWithVoleType:type andVoteAction:voteActionBlock];
    [alertView show];
}

- (id)_initWithVoleType:(VoteBoxType)type andVoteAction:(VoteActionBlock)voteActionBlock{
    
    if (self = [super init]){
        [self _setService];
        [self _setVoteType:type andActionBlock:voteActionBlock];
        [self _setAllView];
        [self _setAutoLayout];
    }
    
    return self;
}

// 配置 GameHandler、ChatHandler
- (void)_setService{
    //注册成为 ChatHandler代理
    [[ChatHandler shareInstance]addDelegate:self delegateQueue:nil];
    //注册成为 GameHandler代理
    [[GameHandler shareInstance]addDelegate:self delegateQueue:nil];
}

-(void)_onDestory{
    NSArray *cells = [self.cv_voters visibleCells];
    PlayerInfo *player;
    NSInteger num = 0;
    for (VoteViewCell *cell in cells) {
        if (num <= cell.votes) {
            player = cell.player;
            num = cell.votes;
        }
    }
    voteActionBlock(voteBoxType, player);
    [[ChatHandler shareInstance]removeDelegate:self];
    [[GameHandler shareInstance]removeDelegate:self];
    
    [self dismiss];
}

-(void)_setVoteType:(VoteBoxType)type andActionBlock:(VoteActionBlock)block{
    if (type < 0 || nil==block) {
        PCLog(@"function input error! type=%ld; block=%@", type, block);
    }
    voteBoxType = type;
    voteActionBlock = block;
    collectionArry = [[NSMutableArray alloc]init];
    
    // 遍历玩家，根据VoteBoxType 为collectionArry筛选玩家
    NSArray *players = [NSArray arrayWithArray:[[GameInfoManager sharedGameInfoManager]players]];
    for (PlayerInfo *player in players) {
        if (PlayerReady_outsider == player.ready) {
            continue;
        }
        if (VoteBoxType_4Police == voteBoxType) {
            if (PlayerRole_police != player.role && !player.killed) {
                [collectionArry addObject:player];
            }
        } else if (VoteBoxType_4Terrorist == voteBoxType) {
            if (PlayerRole_terrorist != player.role && !player.killed) {
                [collectionArry addObject:player];
            }
        } else if (VoteBoxType_atDaybreak == voteBoxType) {
            if (!player.killed) {
                [collectionArry addObject:player];
            }
        }
    }
    
    // collection view 区域的大小
    NSInteger row = collectionArry.count/5;
    NSInteger mod = collectionArry.count%5;
    if (0 < mod){
        row++;
    }
    contentHeight = row * VoterSize + row + 1;
}

-(void)_setAllView{
    // 背景前景式布局
    {
        //初始化窗体 背景区域
        self.backgroundColor = [VoteBoxView appearances].DlgMaskViewColor;
        self.frame = FullScreen;
        self.userInteractionEnabled = YES;
        
        
        //显示区域
        self.alertView = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [VoteBoxView appearances].DlgViewColor;
            view.layer.cornerRadius = [VoteBoxView appearances].DlgViewCornerRadius;
            view.layer.masksToBounds = YES;
            view.userInteractionEnabled = YES;
            view;
        });
        [self addSubview:self.alertView];
    }
    // alertview 内分行布局
    {
        // 分行布局
        self.lb_title = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.numberOfLines = 0;
            lb.font = Text_Helvetica(16.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb;
        });
        self.ui_content = ({
            UIView*ui = [[UIView alloc] init];
            ui.backgroundColor = [UIColor clearColor];
            ui.userInteractionEnabled = YES;
            ui;
        });
        
        [self.alertView addSubview:self.lb_title];
        [self.alertView addSubview:self.ui_content];
        
        // 横线分隔
        self.imv_lineTop = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        // collection view : n行5列
        self.cv_voters = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            UICollectionView*cv = [[UICollectionView alloc] initWithFrame:self.ui_content.frame collectionViewLayout:layout];
            cv.backgroundColor = [UIColor clearColor];
            cv.userInteractionEnabled = YES;
            cv.delegate = self;
            cv.dataSource = self;
            // 注册类，是用纯代码生成的collectiviewcell类才行
            [cv registerClass:[VoteViewCell class] forCellWithReuseIdentifier:@"VoteViewCell"];
            cv;
        });
        // 横线分隔
        self.imv_lineBottom = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        
        [self.ui_content addSubview:self.imv_lineTop];
        [self.ui_content addSubview:self.cv_voters];
        [self.ui_content addSubview:self.imv_lineBottom];
    }
}

- (void)_setAutoLayout{
    WS(ws);
    // 确定 alertView 的frame
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(BoxWidth, BoxTitleHeight + contentHeight));
        make.centerY.equalTo(ws.centerY);
        make.centerX.equalTo(ws.centerX);
    }];
    
    // alertview 内分行布局
    {
        // 分行布局
        [self.lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(ws.alertView).with.offset(0);
            make.height.equalTo(BoxTitleHeight);
        }];
        [self.ui_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.lb_title.bottom).offset(0);
            make.height.equalTo(contentHeight);
        }];
        
        // 横线分隔
        [self.imv_lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_content.top).with.offset(0);
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.height.equalTo(lineH);
        }];
        [self.imv_lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_content.bottom).with.offset(-lineH);
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.height.equalTo(lineH);
        }];
        
        // collection view
        [self.cv_voters mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.imv_lineTop.bottom).with.offset(lineH);
            make.bottom.equalTo(ws.imv_lineBottom.top).with.offset(-lineH);;
            make.left.right.equalTo(ws.alertView).with.offset(0);
        }];
    }
}

-(void)_receiveVoteBy:(NSDictionary*)dict{
    NSString *action = [dict valueForKey:@"action"];
    NSString *userId = [dict valueForKey:@"userId"];
    NSString *votedPlayer = nil;
    if ([Message_voteByPolice isEqualToString:action]) {
        votedPlayer = [dict valueForKey:@"checkUserId"];
    } else if([Message_voteByTerrorist isEqualToString:action]) {
        votedPlayer = [dict valueForKey:@"killEdUserId"];
    } else if([Message_voteAtDaybreak isEqualToString:action]) {
        votedPlayer = [dict valueForKey:@"selectedUserId"];
    } else{
        return;
    }
    
    if ([[SettingsManager sharedSettingsManager].userId isEqualToString:userId]) {
        [eventDictionary setValue:@1 forKey:@"hasVoted"];
    }
    
    NSArray *cells = [self.cv_voters visibleCells];
    for (VoteViewCell *cell in cells) {
        if ([votedPlayer isEqualToString:cell.player.userId]) {
            [cell onVoteChange];
            break;
        }
    }
}
-(void)_receiveKillBy:(NSDictionary*)dict{
    NSString *action = [dict valueForKey:@"action"];
    NSString *killedPlayer = nil;
    if([Message_killResult isEqualToString:action]){
        //推送了杀人结果
        killedPlayer = [dict valueForKey:@"KiillUserId"];
    } else if([Message_policeCheckUser isEqualToString:action]){
        //推送了警察验人结果
        killedPlayer = [dict valueForKey:@"userId"];
    } else if([Message_voteResult isEqualToString:action]){
        //推送了白天投票结果
        killedPlayer = [dict valueForKey:@"killedId"];
    } else{
        return;
    }
    
    NSArray *cells = [self.cv_voters visibleCells];
    for (VoteViewCell *cell in cells) {
        if ([killedPlayer isEqualToString:cell.player.userId]) {
            voteActionBlock(voteBoxType, cell.player);
            [[ChatHandler shareInstance]removeDelegate:self];
            [[GameHandler shareInstance]removeDelegate:self];
            
            [self dismiss];;
            break;
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(VoterSize, VoterSize);
}

#pragma mark - UICollectionViewDataSource
// 指定Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return collectionArry.count;
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerInfo *player = collectionArry[indexPath.row];
    VoteViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VoteViewCell" forIndexPath:indexPath];
    [cell initVoterView:player];
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
    if (!eventDictionary) {
        eventDictionary = [[NSMutableDictionary alloc]init];
        [eventDictionary setValue:@0 forKey:@"hasVoted"];
        [eventDictionary setValue:[GameInfoManager sharedGameInfoManager].roomInfo.roomId forKey:@"roomId"];
        [eventDictionary setValue:[SettingsManager sharedSettingsManager].userId forKey:@"userId"];
    }

    // 不能重复投票
    if (1 == [[eventDictionary valueForKey:@"hasVoted"]integerValue]) {
        return;
    }
    
    PlayerInfo *player = collectionArry[indexPath.row];
    if (VoteBoxType_4Police == voteBoxType) {
        [eventDictionary setValue:Message_voteByPolice forKey:@"action"];
        [eventDictionary setValue:player.userId forKey:@"checkUserId"];
    } else if (VoteBoxType_4Terrorist == voteBoxType){
        [eventDictionary setValue:Message_voteByTerrorist forKey:@"action"];
        [eventDictionary setValue:player.userId forKey:@"killEdUserId"];
    } else if (VoteBoxType_atDaybreak == voteBoxType){
        [eventDictionary setValue:Message_voteAtDaybreak forKey:@"action"];
        [eventDictionary setValue:player.userId forKey:@"selectedUserId"];
    }
    [[ChatHandler shareInstance]sendHandleEvent:eventDictionary];
    
    // 以http方式告知服务端投票情况（如果服务端能在Mqtt协议中处理，则 可取消这一多余步骤）
    NSMutableDictionary *httpDict = [[NSMutableDictionary alloc]init];
    [httpDict setValue:[[GameInfoManager sharedGameInfoManager]getPlayerSelf].userId  forKey:@"userId"];
    [httpDict setValue:[[GameInfoManager sharedGameInfoManager]getPlayerSelf].roomId  forKey:@"roomId"];
    if (VoteBoxType_4Police == voteBoxType) {
        [httpDict setValue:player.userId forKey:@"checkUserId"];
        [self.GameServer requestPoliceCheck:httpDict];
    } else if (VoteBoxType_4Terrorist == voteBoxType){
        [httpDict setValue:player.userId forKey:@"killEdUserId"];
        [self.GameServer requestKillPeople:httpDict];
    } else if (VoteBoxType_atDaybreak == voteBoxType){
        [httpDict setValue:player.userId forKey:@"selectedUserId"];
        [self.GameServer requestVoteExecute:httpDict];
    }
}

#pragma mark - ChatHandlerDelegate
- (void)didReceiveEventMessage:(id)data{
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:data];
    NSString *action = [dict valueForKey:@"action"];
    if ([Message_voteByPolice isEqualToString:action]
        || [Message_voteByTerrorist isEqualToString:action]
        || [Message_voteAtDaybreak isEqualToString:action]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _receiveVoteBy:dict];
        });
    }

}

#pragma mark - GameHandlerDelegate
// 投票结束 --- 若响应此项代理：说明夜间投票结束
- (void)voteEnd{
    [self _onDestory];
}
// 游戏结束
- (void)gameOver{
    [self _onDestory];
}
// 天黑倒计时
- (void)nightfallTicker:(NSString*)title{
    if (VoteBoxType_4Police == voteBoxType
        || VoteBoxType_4Terrorist == voteBoxType) {
        self.lb_title.text = title;
    }
}
// 天亮倒计时
- (void)daybreakTicker:(NSString*)title{
    if (VoteBoxType_atDaybreak == voteBoxType) {
        self.lb_title.text = title;
    }
}

#pragma mark - GameServerDelegate
-(void)onGameServerResponseWithID:(GameServerResponseID)enum_id andResponse:(NSDictionary*)m_dict{
    switch (enum_id) {
        case GameServerResponseID_killPeople:
        case GameServerResponseID_policeCheck:
        case GameServerResponseID_voteExecute:
        {
            PCLog(@"VoteBoxView gameserver response = %@", m_dict);
            break;
        }
        default:
            break;
    }
}
@end
