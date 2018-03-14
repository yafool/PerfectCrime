//
//  WinViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/19.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "WinViewController.h"
#import "PlayerAlertView.h"

@interface WinViewController ()
{
    UITableView *_tableView;
    NSMutableArray * playerArry;
}
@property (nonatomic, assign) int page;
@property (nonatomic, strong) HubsServer *HubsServer;
@end

@implementation WinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initData{
    self.page = 1;
    playerArry = [[NSMutableArray alloc]init];
}

- (HubsServer*)HubsServer{
    if (!_HubsServer) {
        _HubsServer = [[HubsServer alloc]init];
        _HubsServer.delegate = self;
    }
    
    return _HubsServer;
}

-(void)setupTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewFrame_bounds_width, ViewFrame_bounds_height-kTopInset) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[PlayerListCell class] forCellReuseIdentifier:@"PlayerListCell"];
        [self.view addSubview:_tableView];
        
        _tableView.estimatedRowHeight = 48;//预算行高
        _tableView.sectionIndexTrackingBackgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        _tableView.sectionIndexColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
        if ([CustomDeviceFunc is_iOS7]) {
            _tableView.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        }
        else{
            _tableView.backgroundView = nil;
            _tableView.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
        }
        
        __weak __typeof(self) weakSelf = self;
        __unsafe_unretained UITableView *tableView = _tableView;
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.automaticallyChangeAlpha = YES;
        // 下拉刷新
        tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [weakSelf getData];
        }];
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [weakSelf getData];
        }];
    }
    //获取初始数据
    [self getData];
}

// 加载数据
-(void)getData{
    [self.HubsServer requestSortWithType:PlayerSortType_winRate andPage:self.page];;
}

#pragma mark -------- tableViewDelegate ----------------/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return playerArry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerListCell";
    PlayerListCell * cell = (PlayerListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PlayerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary * dict = [playerArry objectAtIndex:indexPath.row];
    [cell showUI:dict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [PlayerAlertView showWithDictionary:nil
        andBlacklistAction:^(UIButton *button) {
            NSLog(@"黑名单");
        }
        andFriendAction:^(UIButton *button) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [self makeFriend:dict];
        }];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
-(void) makeFriend:(NSDictionary*)m_dict{
    
}
#pragma mark -------- PlayerListCellDelegate  ----------------/
-(void)OnAddClickWithPlayer:(NSDictionary*)m_dict{
    [self makeFriend:m_dict];
}

#pragma mark -------- HubsServerDelegate  ----------------/
-(void)playerSortArray:(NSArray *) m_ary andType:(PlayerSortType)type{
    if (PlayerSortType_winRate == type) {
        playerArry = [[NSMutableArray alloc]initWithArray:m_ary];
        [_tableView reloadData];
    }
}

@end
