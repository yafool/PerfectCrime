//
//  HomeViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/14.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "HomeViewController.h"
#import "RoomCollectionViewCell.h"
#import "GameMainViewController.h"
#import "AppDelegate.h"
#import "HomeServer.h"
#import "CreateHomeView.h"
#import "HomeConfirmView.h"
#import "GameInfoManager.h"
#import "PortraitSetViewController.h"
#import "UIImageView+SDWebImage.h"
#import "KxMenu.h"


#define Size_P_Page @"9"

@interface HomeViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
HomeServerDelegate>
{
    NSMutableArray * room_arry;
    UICollectionView *_collectionView;
}
@property (nonatomic, assign) int page;
@property (nonatomic, strong) HomeServer *HomeServer;
@end

@implementation HomeViewController

#pragma mark ------------------- 初始化数据 ---------------------
-(void)initData{
    // 请求房间列表
    room_arry = [[NSMutableArray alloc]init];
    self.page = 1;
    [self getData];
}

-(void)getData{
    NSMutableDictionary *req_dict = [[NSMutableDictionary alloc]init];
    [req_dict setValue:Size_P_Page forKey:@"pageSize"];// 每页显示数量
    [req_dict setValue: [NSString stringWithFormat:@"%d", self.page] forKey:@"pageNo"];    // 页码
    [self.HomeServer requestHomeList:req_dict];
}

-(void)setupCollectionView{
    if (_collectionView == nil) {
        
        // 可以给layout设置全局属性
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // default is UICollectionViewScrollDirectionVetical
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 8, ViewFrame_bounds_width-16, ViewFrame_bounds_height-kTopInset-120) collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 注册类，是用纯代码生成的collectiviewcell类才行
        [_collectionView registerClass:[RoomCollectionViewCell class] forCellWithReuseIdentifier:@"RoomCollectionViewCell"];
        
        __weak __typeof(self) weakSelf = self;
        __unsafe_unretained UICollectionView *conllectionView = _collectionView;
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        conllectionView.mj_header.automaticallyChangeAlpha = YES;
        // 下拉刷新
        conllectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [weakSelf getData];
        }];
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        conllectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [weakSelf getData];
        }];
    }
    
}

- (HomeServer*)HomeServer{
    if (!_HomeServer) {
        _HomeServer = [[HomeServer alloc]init];
        _HomeServer.delegate = self;
    }
    
    return _HomeServer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    
    [self.navigationItem setItemWithTitle:@"游戏大厅" textColor:[CustomColorRGB colorWithHexString:kNavColor] fontSize:18 itemType:center];
    
    CustomBarItem *rightItem = [self.navigationItem setItemWithImage:@"optionMenu" size:CGSizeMake(32, 32) itemType:right];
    [rightItem setOffset:-4];//设置item偏移量(正值向左偏，负值向右偏)
    [rightItem addTarget:self selector:@selector(optionMenuOnClick) event:(UIControlEventTouchUpInside)];
    
    
    [self setupCollectionView];
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    UIImageView *customL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ViewRadius(customL,20);
    [customL downloadImage:[[SettingsManager sharedSettingsManager]picUrl] placeholder:@"defaultHead"];
    NSString *picFrame = [[SettingsManager sharedSettingsManager]picFrame];
    if(![CustomStringFunc isBlankString:picFrame]) {
        UIImageView *frameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        ViewRadius(frameView,20);
        frameView.image = [UIImage imageNamed:[[SettingsManager sharedSettingsManager]picFrame]];
        [customL addSubview:frameView];
    }
    CustomBarItem *leftItem = [self.navigationItem setItemWithCustomView:customL itemType:left];
    
    [leftItem setOffset:4];//设置item偏移量(正值向左偏，负值向右偏)
    [leftItem addTarget:self selector:@selector(toHeadSet) event:(UIControlEventTouchUpInside)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 跳转到头像设置界面
- (void)toHeadSet{
    PortraitSetViewController * headset = [[PortraitSetViewController alloc]init];
    [self.navigationController pushViewController:headset animated:YES];
}

- (void)optionMenuOnClick{
    NSArray *menuItems = @[
          [KxMenuItem menuItem:@"新建房间"
                         image:[UIImage imageNamed:@"createRoom"]
                        target:self
                        action:@selector(createRoom)],
          
          [KxMenuItem menuItem:@"分享"
                         image:[UIImage imageNamed:@"shareOption"]
                        target:self
                        action:@selector(onShare)]
      ];
    CGRect frame = CGRectMake(self.view.frame.size.width - 100, -kTopInset, 100, 64);
    [KxMenu showMenuInView:self.view
                      fromRect:frame
                     menuItems:menuItems];

}
// 创建房间
- (void)createRoom{
    [CreateHomeView showWithCreateAction:^(UIButton *button) {
        PCLog(@"====>CreateAction: isCreateValid=%i", [[CreateHomeView appearances]isCreateValid])
        if ([[CreateHomeView appearances]isCreateValid]) {
            NSDictionary *dict = [[CreateHomeView appearances]getHomeInfo];
            [dict setValue:[[SettingsManager sharedSettingsManager]userId] forKey:@"userId"];
            PCLog(@"request create home: %@", dict);
            [self.HomeServer requestHomeCreate:dict];
        }
    }];
}
// 分享下载
- (void)onShare{
    
}

//进入游戏房间
-(void)entranceGameRoomWith:(NSDictionary *)m_dict {
    [[GameInfoManager sharedGameInfoManager]resetGameInfo];
    //通知服务端玩家进入房间
    [[GameInfoManager sharedGameInfoManager]updateRoomInfo:m_dict];
    
    NSMutableDictionary *req_dict = [[NSMutableDictionary alloc]init];
    [req_dict setValue:[SettingsManager sharedSettingsManager].userId forKey:@"userId"];
    [req_dict setValue:[m_dict valueForKey:@"roomId"] forKey:@"roomId"];
    [self.HomeServer requestHomeEnter:req_dict];
}
//push 房间
-(void)pushEntrance{
    //游戏界面
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    GameMainViewController * gameMain = [[GameMainViewController alloc]init];
    [self.navigationController pushViewController:gameMain animated:YES];
}
#pragma mark - UICollectionViewDataSource
// 指定Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return room_arry.count;
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dict = room_arry[indexPath.row];
    RoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomCollectionViewCell" forIndexPath:indexPath];
    [cell initCellwithDictionary:dict];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((ViewFrame_bounds_width-32)/3, 140);
    
}

// 设置每个cell上下左右相距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(2, 2, 2, 2);
//}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

#pragma mark - UICollectionViewDelegate
// 选中操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RoomCollectionViewCell *cell = (RoomCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *passwd = cell.passwd;
    if ([CustomStringFunc isBlankString:passwd]) {
   
        [self entranceGameRoomWith:[cell roomDict]];
    }else{
        [HomeConfirmView showWithHome:[cell roomDict] andAction:^(UIButton *button) {
            if ([[HomeConfirmView appearances]isConfirm]) {
                [self entranceGameRoomWith:[cell roomDict]];
            }else{
                [MBProgressHUD showInfoMessage:@"您输入的密码错误！"];
            }
        }];
    }    
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
        // 房间列表 --- OK
        case HomeServerIDhomeList:{
            //请求到的结果数据
            if ( 200 == [code integerValue]) {
                // Simulate an async request
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    int pageSum = [[response valueForKey:@"pages"]intValue];// 总页数
                    NSArray * room_results = [response valueForKey:@"data"];
                    if(self.page == 1){ [room_arry removeAllObjects]; }
                    [room_results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary * dict = (NSDictionary*)obj;
                        NSMutableDictionary *formatDict = [[NSMutableDictionary alloc]init];
                        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            [formatDict setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                        }];
                        [room_arry addObject:formatDict];
                    }];
                    
                    //刷新 CollectionView
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 结束刷新
                        [_collectionView.mj_header endRefreshing];
                        if(self.page < pageSum){
                            // 结束刷新
                            [_collectionView.mj_footer endRefreshing];
                        }else{
                            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                            [_collectionView.mj_footer endRefreshingWithNoMoreData];
                        }
                        
                        [_collectionView reloadData];
                    });
                    
                });
            }else {
                PCLog(@"当前没有房间: code=%@; msg=%@", code, msg);
                [MBProgressHUD showInfoMessage:@"当前没有房间"];
            }
            break;
        }
        // 创建房间 --- OK
        case HomeServerIDhomeCreate:{
            if ( 200 == [code integerValue]) {
                NSString *roomId = [response valueForKey:@"roomId"];// 房间ID
                NSMutableDictionary *homeDict = [[NSMutableDictionary alloc]init];
                [homeDict setValue:roomId forKey:@"roomId"];
                [homeDict setValue:[SettingsManager sharedSettingsManager].userId forKey:@"hoster"];
                [homeDict setValue:[[[CreateHomeView appearances]getHomeInfo]valueForKey:@"name"] forKey:@"roomName"];
                PCLog(@"response create home: %@", homeDict);
                [[GameInfoManager sharedGameInfoManager]updateRoomInfo:homeDict];
                [self pushEntrance];
            }else {
                PCLog(@"create room failed: code=%@; msg=%@", code, msg);
                [MBProgressHUD showInfoMessage:@"创建房间失败！"];
                [[CreateHomeView appearances]clearHomeInfo];
            }
            break;
        }
        // 进入房间 --- OK
        case HomeServerIDhomeEnter:{
            if ( 200 == [code integerValue]) {
                [GameInfoManager sharedGameInfoManager].roomInfo.hoster = [NSString stringWithFormat:@"%@",[response valueForKey:@"hoster"]];
                [GameInfoManager sharedGameInfoManager].gameProgress.days=[[response valueForKey:@"day"]integerValue];
                [GameInfoManager sharedGameInfoManager].gameProgress.dayState = [[response valueForKey:@"dayornight"]integerValue];
                [self pushEntrance];
            } else {
                PCLog(@"create room failed: code=%@; msg=%@", code, msg);
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

@end
