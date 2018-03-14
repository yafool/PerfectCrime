//
//  MVPVoteView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/11/9.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "MVPVoteView.h"
#import "GameInfoManager.h"
#import "VoteViewCell.h"

@interface MVPVoteView ()
{
    NSMutableArray      *collectionArry;
    MVPVoteBlock        mvpVoteBlock;
    NSInteger           contentHeight;
}
@property (nonatomic, strong) UILabel           *lb_title;
@property (nonatomic, strong) UIButton          *btn_cancel;
@property (nonatomic, strong) UIView            *ui_content;
@property (nonatomic, strong) UICollectionView  *cv_voters;
@property (nonatomic, strong) UIImageView       *imv_lineTop;
@property (nonatomic, strong) UIImageView       *imv_lineBottom;
@end

@implementation MVPVoteView

+ (DlgAppearance *)appearances{
    static DlgAppearance* appearance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [[DlgAppearance alloc] init];
    });
    
    return appearance;
}

+ (void)showWitVoteActionBlock:(MVPVoteBlock)mvpVoteBlock{
    MVPVoteView* alertView = [[MVPVoteView alloc]_initWithVoteAction:mvpVoteBlock];
    [alertView show];
}

- (id)_initWithVoteAction:(MVPVoteBlock)mvpVoteBlock{
    
    if (self = [super init]){
        [self _setVoteActionBlock:mvpVoteBlock];
        [self _setAllView];
        [self _setAutoLayout];
    }
    
    return self;
}

-(void)_setVoteActionBlock:(MVPVoteBlock)block{
    if (nil==block) {
        PCLog(@"function input error! block=%@", block);
    }
    mvpVoteBlock = block;
    collectionArry = [[NSMutableArray alloc]init];
    
    // 遍历玩家，根据VoteBoxType 为collectionArry筛选玩家
    NSArray *players = [NSArray arrayWithArray:[[GameInfoManager sharedGameInfoManager]players]];
    for (PlayerInfo *player in players) {
        if (PlayerReady_sitdown == player.ready) {
            [collectionArry addObject:player];
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
        self.backgroundColor = [MVPVoteView appearances].DlgMaskViewColor;
        self.frame = FullScreen;
        self.userInteractionEnabled = YES;
        
        
        //显示区域
        self.alertView = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [MVPVoteView appearances].DlgViewColor;
            view.layer.cornerRadius = [MVPVoteView appearances].DlgViewCornerRadius;
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
            lb.text = @"推举 MVP";
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb;
        });
        self.btn_cancel = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.backgroundColor = [UIColor clearColor];
            [btn setImage:[UIImage imageNamed:@"cornerBtnClose"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(_onClickCancel) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        self.ui_content = ({
            UIView*ui = [[UIView alloc] init];
            ui.backgroundColor = [UIColor clearColor];
            ui.userInteractionEnabled = YES;
            ui;
        });
        
        [self.alertView addSubview:self.lb_title];
        [self.alertView addSubview:self.btn_cancel];
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
        [self.btn_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_title.centerY).with.offset(0);
            make.right.equalTo(ws.alertView).with.offset(-4);
            make.size.equalTo(CGSizeMake(BoxTitleHeight/3*2, BoxTitleHeight/3*2));
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

- (void)_onClickCancel{
    [self dismiss];
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
    PlayerInfo *player = collectionArry[indexPath.row];
    mvpVoteBlock(player);
    [self dismiss];
}
@end
