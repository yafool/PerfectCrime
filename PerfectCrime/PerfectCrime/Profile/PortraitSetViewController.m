//
//  PortraitSetViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/31.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PortraitSetViewController.h"
#import "UIImageView+SDWebImage.h"
#import "EditNickView.h"
#import "AccountServer.h"


#pragma mark -------- CurrentPortraitView [begin] ----------------/

@interface CurrentPortraitView : UIView

@property (nonatomic, strong) UIImageView *imv_bg;
@property (nonatomic, strong) UIImageView *imv_icon;
@property (nonatomic, strong) UIButton    *btn_nick;
@property (nonatomic, strong) UILabel     *lb_nick;
@property (nonatomic, strong) UIImageView *imv_LineX;
@end

@implementation CurrentPortraitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
        [self _autolayouUI];
    }
    return self;
}

- (void)_setup{
    
    self.imv_bg = ({
        UIImageView *imv_bg     = [[UIImageView alloc] init];
        imv_bg.backgroundColor = [UIColor whiteColor];
        imv_bg.userInteractionEnabled = YES;
        imv_bg;
    });
    
    self.imv_icon = ({
        UIImageView*imv_icon     = [[UIImageView alloc] init];
        imv_icon.backgroundColor = [UIColor clearColor];
        imv_icon.clipsToBounds   = YES;
        //圆角设置
        imv_icon.layer.cornerRadius= 135/2/2;//(值越大，角就越圆)
        imv_icon.layer.masksToBounds= YES;
        //边框宽度及颜色设置
        [imv_icon.layer setBorderWidth:lineH];
        [imv_icon.layer setBorderColor:[UIColor clearColor].CGColor];  //设置边框为蓝色
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [imv_icon downloadImage:[[SettingsManager sharedSettingsManager]picUrl] placeholder:@"defaultHead"];
            NSString *picFrame = [SettingsManager sharedSettingsManager].picFrame;
            if (![CustomStringFunc isBlankString:picFrame]) {
                UIImageView *frameV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:picFrame]];
                [frameV setFrame:CGRectMake(0, 0, 135/2, 135/2)];
                [imv_icon addSubview:frameV];
            }
        });
        
        imv_icon;
    });
    
    self.btn_nick = ({
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(modifyNick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    self.lb_nick = ({
        UILabel* lb_nick = [[UILabel alloc] init];
        lb_nick.font = Text_Helvetica(12.0f);
        lb_nick.textColor = [UIColor blackColor];
        lb_nick.backgroundColor = [UIColor clearColor];
        lb_nick.textAlignment = NSTextAlignmentRight;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.lb_nick.text = [SettingsManager sharedSettingsManager].nickName;
        });
        
        lb_nick;
    });
    
    self.imv_LineX = ({
        UIImageView*imv_LineX     = [[UIImageView alloc] init];
        imv_LineX.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_LineX;
    });
    
    [self addSubview:self.imv_bg];
    [self.imv_bg addSubview:self.imv_icon];
    [self.imv_bg addSubview:self.imv_LineX];
    [self.imv_bg addSubview:self.btn_nick];
    [self.btn_nick addSubview:self.lb_nick];
    
}

- (void)_autolayouUI{
    WS(ws);
    [self.imv_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.imv_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_bg).with.offset(15);
        make.centerY.equalTo(ws.imv_bg.centerY).with.offset(0);
        make.size.equalTo(CGSizeMake(135/2, 135/2));
    }];
    
    [self.btn_nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(ws.imv_bg).with.offset(0);
        make.left.equalTo(ws.imv_icon.right).with.offset(4);
    }];
    
    [self.lb_nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(ws.btn_nick).with.offset(0);
        make.height.equalTo(24);
    }];
    
    [self.imv_LineX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws.imv_bg).with.offset(0);
        make.height.equalTo(lineH);
    }];
}

-(void)modifyNick:(UIButton*)but{
    
    [EditNickView showWithSucessBlock:^(NSDictionary *dict){
        self.lb_nick.text = [SettingsManager sharedSettingsManager].nickName;
    } andCancelBlock:^(){
        [MBProgressHUD showInfoMessage:@"放弃修改昵称"];
    }];
}

-(void)updatePicFrame:(NSString*)userHead{
    for(UIView *subV in [self.imv_icon subviews])
    {
        [subV removeFromSuperview];
    }
    UIImageView *frameV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:userHead]];
    [frameV setFrame:CGRectMake(0, 0, self.imv_icon.frame.size.width, self.imv_icon.frame.size.height)];
    [self.imv_icon addSubview:frameV];
    [[SettingsManager sharedSettingsManager]setPicFrame:userHead];
}

@end
#pragma mark -------- CurrentPortraitView [end] ----------------/


#pragma mark -------- PortraitCollectionViewCell [begin] ----------------/
@interface PortraitCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UIImageView *imv_icon;
@end


@implementation PortraitCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self _setup];
        [self _autolayouUI];
        
    }
    return self;
}

- (void)_setup{
    self.imv_back = ({
        UIImageView*imv_back     = [[UIImageView alloc] init];
        imv_back.backgroundColor = [UIColor clearColor];
        imv_back.userInteractionEnabled = YES;
        imv_back;
    });
    self.imv_icon = ({
        UIImageView*imv_icon     = [[UIImageView alloc] init];
        imv_icon.backgroundColor = [UIColor clearColor];
        imv_icon.clipsToBounds   = YES;
        //圆角设置
        imv_icon.layer.cornerRadius= 96/2/2;//(值越大，角就越圆)
        imv_icon.layer.masksToBounds= YES;
        //边框宽度及颜色设置
        [imv_icon.layer setBorderWidth:lineH];
        [imv_icon.layer setBorderColor:[UIColor clearColor].CGColor];  //设置边框为蓝色
        imv_icon;
    });
    
    [self.contentView addSubview:self.imv_back];
    [self.imv_back addSubview:self.imv_icon];
    
}

- (void)_autolayouUI{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.imv_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(ws.imv_back).with.offset(0);
        make.size.equalTo(CGSizeMake(96/2, 96/2));
    }];
}

-(void)initCellwithName:(NSString*)m_name{
    self.imv_icon.image = [UIImage imageNamed:m_name];
}
@end
#pragma mark -------- PortraitCollectionViewCell [begin] ----------------/



@interface PortraitSetViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
AccountServerDelegate>
{
    CurrentPortraitView * _portraitView;
    NSMutableArray * portrait_arry;
    UICollectionView *_collectionView;
}
//头像资源
@property (nonatomic, strong) NSDictionary *portraitDict;
//帐号相关服务
@property (nonatomic, strong) AccountServer *accountServer;
@end

@implementation PortraitSetViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XNTabBarController hideTabbar];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [XNTabBarController showTabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    
    [self.navigationItem setItemWithTitle:@"头像设置" textColor:[CustomColorRGB colorWithHexString:kNavColor] fontSize:18 itemType:center];
    
    CustomBarItem *leftItem = [self.navigationItem setItemWithImage:@"NavBackButton" size:CGSizeMake(60, 35) itemType:left];
    [leftItem setOffset:0];//设置item偏移量(正值向左偏，负值向右偏)
    [leftItem addTarget:self selector:@selector(popToBack) event:(UIControlEventTouchUpInside)];
    
    _portraitView = [[CurrentPortraitView alloc]initWithFrame:CGRectMake(0, 8, ViewFrame_bounds_width, 120)];
    [self.view addSubview:_portraitView];
    
    // 可以给layout设置全局属性
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // default is UICollectionViewScrollDirectionVetical
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 8 + 120 + 8, ViewFrame_bounds_width, ViewFrame_bounds_height-kTopInset-136) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册类，是用纯代码生成的collectiviewcell类才行
    [_collectionView registerClass:[PortraitCollectionViewCell class] forCellWithReuseIdentifier:@"PortraitCollectionViewCell"];
    
    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popToBack{
    [self.navigationController popViewControllerAnimated:YES];
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
    
    NSString * picFrame = [SettingsManager sharedSettingsManager].picFrame;
    if (![CustomStringFunc isBlankString:picFrame]) {
        [postDict setValue:[SettingsManager sharedSettingsManager].userId forKey:@"userId"];
        [postDict setValue:[SettingsManager sharedSettingsManager].picFrame forKey:@"picFrame"];
        [self.accountServer requestModify:postDict];
    }
    
}

- (AccountServer*)accountServer{
    if (!_accountServer) {
        _accountServer = [[AccountServer alloc]init];
        _accountServer.delegate = self;
    }
    
    return _accountServer;
}

-(void) initData{

    portrait_arry = [[NSMutableArray alloc]initWithArray:[self.portraitDict allValues]];
    
}

- (NSDictionary *)portraitDict
{
    if (!_portraitDict) {
        _portraitDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Portraits" ofType:@"plist"]];
    }
    return _portraitDict;
}

#pragma mark - UICollectionViewDataSource
// 指定Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return portrait_arry.count;
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str = portrait_arry[indexPath.row];
    PortraitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortraitCollectionViewCell" forIndexPath:indexPath];
    [cell initCellwithName:str];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((ViewFrame_bounds_width)/5, (ViewFrame_bounds_width)/5);
    
}

// 设置每个cell上下左右相距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(2, 2, 2, 2);
//}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

#pragma mark - UICollectionViewDelegate
// 选中操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str = portrait_arry[indexPath.row];
    PCLog(@"room info: %@", str);
    [_portraitView updatePicFrame:str];
}

#pragma mark - AccountServerDelegate
-(void)responseModify:(NSDictionary*)m_dict{
    PCLog(@"AccountServerDelegate responseModify m_dict: %@", m_dict);
}
@end
