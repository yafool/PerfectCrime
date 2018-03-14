//
//  PlayerAlertView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/18.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayerAlertView.h"
#import "PlayerAppearance.h"


//AlertViewWidth
#define AlertTitleHeight        DlgTitleHeight
#define AlertTopRowHeight       80
#define AlertRowHeight          64
#define AlertBottomRowHeight    DlgBottomRowHeight

#define PlayerAlertWidth    DlgWidth
#define PlayerAlertHeight   (AlertTitleHeight + AlertTopRowHeight + AlertBottomRowHeight + AlertRowHeight*3)
//按钮默认高度
#define PlayerAlertBtnHeight DlgBtnHeight


#pragma mark --- PlayerAlertView
@interface PlayerAlertView ()
{
    PlayerAppearance *playerAppearance;
}
//@property (nonatomic, strong) PlayerAppearance *appearance;

@property (nonatomic, strong) UILabel       *lb_title;
@property (nonatomic, strong) UIImageView   *ui_1Row;
@property (nonatomic, strong) UIImageView   *ui_2Row;
@property (nonatomic, strong) UIImageView   *ui_3Row;
@property (nonatomic, strong) UIImageView   *ui_4Row;
@property (nonatomic, strong) UIImageView   *ui_5Row;

@property (nonatomic, strong) UIImageView   *imv_0lineX;
@property (nonatomic, strong) UIImageView   *imv_1lineX;
@property (nonatomic, strong) UIImageView   *imv_2lineX;
@property (nonatomic, strong) UIImageView   *imv_3lineX;
@property (nonatomic, strong) UIImageView   *imv_4lineX;

@property (nonatomic, strong) UIImageView   *imv_icon;
@property (nonatomic, strong) UILabel       *lb_nick;
@property (nonatomic, strong) UIButton      *btn_blacklist;

@property (nonatomic, strong) UIView        *ui_2RLeft;
@property (nonatomic, strong) UIImageView   *imv_2R1LineY;
@property (nonatomic, strong) UIView        *ui_2RCenter;
@property (nonatomic, strong) UIImageView   *imv_2R2LineY;
@property (nonatomic, strong) UIView        *ui_2RRight;

@property (nonatomic, strong) UIView        *ui_3RLeft;
@property (nonatomic, strong) UIImageView   *imv_3R1LineY;
@property (nonatomic, strong) UIView        *ui_3RCenter;
@property (nonatomic, strong) UIImageView   *imv_3R2LineY;
@property (nonatomic, strong) UIView        *ui_3RRight;

@property (nonatomic, strong) UIView        *ui_4RLeft;
@property (nonatomic, strong) UIImageView   *imv_4R1LineY;
@property (nonatomic, strong) UIView        *ui_4RCenter;
@property (nonatomic, strong) UIImageView   *imv_4R2LineY;
@property (nonatomic, strong) UIView        *ui_4RRight;

@property (nonatomic, strong) UIButton      *btn_cancel;
@property (nonatomic, strong) UIButton      *btn_friend;

@property (nonatomic, strong) UILabel       *lb_subject_sex;
@property (nonatomic, strong) UILabel       *lb_sex;
@property (nonatomic, strong) UILabel       *lb_subject_age;
@property (nonatomic, strong) UILabel       *lb_age;
@property (nonatomic, strong) UILabel       *lb_subject_addr;
@property (nonatomic, strong) UILabel       *lb_addr;

@property (nonatomic, strong) UILabel       *lb_subject_games;
@property (nonatomic, strong) UILabel       *lb_games;
@property (nonatomic, strong) UILabel       *lb_subject_wins;
@property (nonatomic, strong) UILabel       *lb_wins;
@property (nonatomic, strong) UILabel       *lb_subject_rate;
@property (nonatomic, strong) UILabel       *lb_rate;

@property (nonatomic, strong) UILabel       *lb_subject_score;
@property (nonatomic, strong) UILabel       *lb_score;
@property (nonatomic, strong) UILabel       *lb_subject_mvp;
@property (nonatomic, strong) UILabel       *lb_mvp;
@property (nonatomic, strong) UILabel       *lb_subject_more;

@end

@implementation PlayerAlertView

+ (PlayerAppearance *)appearances{
    
    static PlayerAppearance* appearance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [[PlayerAppearance alloc] init];
    });
    
    return appearance;
}

+ (void)showWithDictionary:(NSDictionary*)m_dict andBlacklistAction:(CommitAction)blacklistAction andFriendAction:(CommitAction)friendAction{
    [[PlayerAlertView appearances]setViewInfo:m_dict];
    PlayerAlertView* alertView = [[PlayerAlertView alloc]initViewWithAction:blacklistAction andAction:friendAction];
    
    [alertView show];
    
}

- (id)initViewWithAction:(CommitAction)blacklistAction andAction:(CommitAction)friendAction{
    
    if (self = [super init]){
        [self setAllViewWithAction:blacklistAction andAction:friendAction];
        [self setAutoLayout];
    }
    
    return self;
}

-(void)setAllViewWithAction:(CommitAction)blacklistAction andAction:(CommitAction)friendAction{
   
    // 背景前景式布局
    {
        //初始化窗体 背景区域
        self.backgroundColor = [PlayerAlertView appearances].DlgMaskViewColor;
        self.frame = FullScreen;
        self.userInteractionEnabled = YES;
        
        
        //显示区域
        self.alertView = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [PlayerAlertView appearances].DlgViewColor;
            view.layer.cornerRadius = [PlayerAlertView appearances].DlgViewCornerRadius;
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
            lb.text = @"玩家信息";
            lb;
        });
        self.ui_1Row = ({
            UIImageView*imagev = [[UIImageView alloc] init];
            imagev.backgroundColor = [UIColor clearColor];
            imagev.userInteractionEnabled = YES;
            imagev;
        });
        self.ui_2Row = ({
            UIImageView*imagev = [[UIImageView alloc] init];
            imagev.backgroundColor = [UIColor clearColor];
            imagev.userInteractionEnabled = YES;
            imagev;
        });
        self.ui_3Row = ({
            UIImageView*imagev = [[UIImageView alloc] init];
            imagev.backgroundColor = [UIColor clearColor];
            imagev.userInteractionEnabled = YES;
            imagev;
        });
        self.ui_4Row = ({
            UIImageView*imagev = [[UIImageView alloc] init];
            imagev.backgroundColor = [UIColor clearColor];
            imagev.userInteractionEnabled = YES;
            imagev;
        });
        self.ui_5Row = ({
            UIImageView*imagev = [[UIImageView alloc] init];
            imagev.backgroundColor = [UIColor clearColor];
            imagev.userInteractionEnabled = YES;
            imagev;
        });
        
        [self.alertView addSubview:self.lb_title];
        [self.alertView addSubview:self.ui_1Row];
        [self.alertView addSubview:self.ui_2Row];
        [self.alertView addSubview:self.ui_3Row];
        [self.alertView addSubview:self.ui_4Row];
        [self.alertView addSubview:self.ui_5Row];
        
        // 横线分隔
        self.imv_0lineX = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_1lineX = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_2lineX = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_3lineX = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_4lineX = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        
        [self.ui_1Row addSubview:self.imv_0lineX];
        [self.ui_1Row addSubview:self.imv_1lineX];
        [self.ui_2Row addSubview:self.imv_2lineX];
        [self.ui_3Row addSubview:self.imv_3lineX];
        [self.ui_4Row addSubview:self.imv_4lineX];
    }
    
    // 第一行布局（title 为 第 0 行）
    {
        self.imv_icon = ({
            UIImageView*icon     = [[UIImageView alloc] init];
            icon.backgroundColor = [UIColor clearColor];
            icon.image           = [UIImage imageNamed:@"[甲]"];
            icon.clipsToBounds   = YES;
            //圆角设置
            icon.layer.cornerRadius= 135/2/2;//(值越大，角就越圆)
            icon.layer.masksToBounds= YES;
            //边框宽度及颜色设置
            [icon.layer setBorderWidth:lineH];
            [icon.layer setBorderColor:[UIColor clearColor].CGColor];  //设置边框为蓝色
            icon;
        });
        self.lb_nick = ({
            UILabel* nick = [[UILabel alloc] init];
            nick.font = Text_Helvetica(12.0f);
            nick.textColor = [UIColor blackColor];
            nick.backgroundColor = [UIColor clearColor];
            nick.textAlignment = NSTextAlignmentRight;
            nick.text = @"未命名";
            nick;
        });
        self.btn_blacklist = ({
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor redColor];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(),(CGFloat[]){ 0, 0, 0, 1 });
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"黑名单" forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(12);
            [btn handleControlEvent:UIControlEventTouchUpInside withBlock:blacklistAction];
            [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        [self.ui_1Row addSubview:self.imv_icon];
        [self.ui_1Row addSubview:self.lb_nick];
        [self.ui_1Row addSubview:self.btn_blacklist];
    }
    // 第二行布局
    {
        self.ui_2RLeft = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        self.ui_2RCenter = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        self.ui_2RRight = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        [self.ui_2Row addSubview:self.ui_2RLeft];
        [self.ui_2Row addSubview:self.ui_2RCenter];
        [self.ui_2Row addSubview:self.ui_2RRight];
        
        // 竖线分隔
        self.imv_2R1LineY = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_2R2LineY = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        [self.ui_2RLeft addSubview:self.imv_2R1LineY];
        [self.ui_2RCenter addSubview:self.imv_2R2LineY];
        
        //填充内容资料
        self.lb_subject_sex = ({
            UILabel* lb_subject_sex = [[UILabel alloc] init];
            lb_subject_sex.font = Text_Helvetica(11.0f);
            lb_subject_sex.textColor = [UIColor blackColor];
            lb_subject_sex.backgroundColor = [UIColor clearColor];
            lb_subject_sex.textAlignment = NSTextAlignmentRight;
            lb_subject_sex.text = CustomLocalizedString(@"性别", nil);
            lb_subject_sex;
        });
        
        self.lb_sex = ({
            UILabel* lb_sex = [[UILabel alloc] init];
            lb_sex.font = Text_Helvetica(11.0f);
            lb_sex.textColor = [UIColor orangeColor];
            lb_sex.backgroundColor = [UIColor clearColor];
            lb_sex.textAlignment = NSTextAlignmentRight;
            lb_sex.text = @"男";
            lb_sex;
        });
        
        self.lb_subject_age = ({
            UILabel* lb_subject_age = [[UILabel alloc] init];
            lb_subject_age.font = Text_Helvetica(11.0f);
            lb_subject_age.textColor = [UIColor blackColor];
            lb_subject_age.backgroundColor = [UIColor clearColor];
            lb_subject_age.textAlignment = NSTextAlignmentRight;
            lb_subject_age.text = CustomLocalizedString(@"年龄", nil);
            lb_subject_age;
        });
        
        self.lb_age = ({
            UILabel* lb_age = [[UILabel alloc] init];
            lb_age.font = Text_Helvetica(11.0f);
            lb_age.textColor = [UIColor orangeColor];
            lb_age.backgroundColor = [UIColor clearColor];
            lb_age.textAlignment = NSTextAlignmentRight;
            lb_age.text = @"100";
            lb_age;
        });
        
        self.lb_subject_addr = ({
            UILabel* lb_subject_addr = [[UILabel alloc] init];
            lb_subject_addr.font = Text_Helvetica(11.0f);
            lb_subject_addr.textColor = [UIColor blackColor];
            lb_subject_addr.backgroundColor = [UIColor clearColor];
            lb_subject_addr.textAlignment = NSTextAlignmentRight;
            lb_subject_addr.text = CustomLocalizedString(@"地区", nil);
            lb_subject_addr;
        });
        
        self.lb_addr = ({
            UILabel* lb_user = [[UILabel alloc] init];
            lb_user.font = Text_Helvetica(11.0f);
            lb_user.textColor = [UIColor orangeColor];
            lb_user.backgroundColor = [UIColor clearColor];
            lb_user.textAlignment = NSTextAlignmentRight;
            lb_user.text = @"北京";
            lb_user;
        });
        
        [self.ui_2RLeft addSubview:self.lb_subject_sex];
        [self.ui_2RLeft addSubview:self.lb_sex];
        [self.ui_2RCenter addSubview:self.lb_subject_age];
        [self.ui_2RCenter addSubview:self.lb_age];
        [self.ui_2RRight addSubview:self.lb_subject_addr];
        [self.ui_2RRight addSubview:self.lb_addr];
    }
    
    // 第三行布局
    {
        self.ui_3RLeft = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        self.ui_3RCenter = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        self.ui_3RRight = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        [self.ui_3Row addSubview:self.ui_3RLeft];
        [self.ui_3Row addSubview:self.ui_3RCenter];
        [self.ui_3Row addSubview:self.ui_3RRight];
        
        // 竖线分隔
        self.imv_3R1LineY = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_3R2LineY = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        [self.ui_3RLeft addSubview:self.imv_3R1LineY];
        [self.ui_3RCenter addSubview:self.imv_3R2LineY];
        
        //填充内容资料
        self.lb_subject_games = ({
            UILabel* lb_subject_games = [[UILabel alloc] init];
            lb_subject_games.font = Text_Helvetica(11.0f);
            lb_subject_games.textColor = [UIColor blackColor];
            lb_subject_games.backgroundColor = [UIColor clearColor];
            lb_subject_games.textAlignment = NSTextAlignmentRight;
            lb_subject_games.text = CustomLocalizedString(@"总局数", nil);
            lb_subject_games;
        });
        
        self.lb_games = ({
            UILabel* lb_games = [[UILabel alloc] init];
            lb_games.font = Text_Helvetica(11.0f);
            lb_games.textColor = [UIColor orangeColor];
            lb_games.backgroundColor = [UIColor clearColor];
            lb_games.textAlignment = NSTextAlignmentRight;
            lb_games.text = @"100";
            lb_games;
        });
        self.lb_subject_wins = ({
            UILabel* lb_subject_wins = [[UILabel alloc] init];
            lb_subject_wins.font = Text_Helvetica(11.0f);
            lb_subject_wins.textColor = [UIColor blackColor];
            lb_subject_wins.backgroundColor = [UIColor clearColor];
            lb_subject_wins.textAlignment = NSTextAlignmentRight;
            lb_subject_wins.text = CustomLocalizedString(@"胜局数", nil);
            lb_subject_wins;
        });
        self.lb_wins = ({
            UILabel* lb_wins = [[UILabel alloc] init];
            lb_wins.font = Text_Helvetica(11.0f);
            lb_wins.textColor = [UIColor orangeColor];
            lb_wins.backgroundColor = [UIColor clearColor];
            lb_wins.textAlignment = NSTextAlignmentRight;
            lb_wins.text = @"99";
            lb_wins;
        });
        self.lb_subject_rate = ({
            UILabel* lb_subject_rate = [[UILabel alloc] init];
            lb_subject_rate.font = Text_Helvetica(11.0f);
            lb_subject_rate.textColor = [UIColor blackColor];
            lb_subject_rate.backgroundColor = [UIColor clearColor];
            lb_subject_rate.textAlignment = NSTextAlignmentRight;
            lb_subject_rate.text = CustomLocalizedString(@"胜率", nil);
            lb_subject_rate;
        });
        self.lb_rate = ({
            UILabel* lb_rate = [[UILabel alloc] init];
            lb_rate.font = Text_Helvetica(11.0f);
            lb_rate.textColor = [UIColor orangeColor];
            lb_rate.backgroundColor = [UIColor clearColor];
            lb_rate.textAlignment = NSTextAlignmentRight;
            lb_rate.text = @"99%";
            lb_rate;
        });
        
        [self.ui_3RLeft addSubview:self.lb_subject_games];
        [self.ui_3RLeft addSubview:self.lb_games];
        [self.ui_3RCenter addSubview:self.lb_subject_wins];
        [self.ui_3RCenter addSubview:self.lb_wins];
        [self.ui_3RRight addSubview:self.lb_subject_rate];
        [self.ui_3RRight addSubview:self.lb_rate];
    }
    
    // 第四行布局
    {
        self.ui_4RLeft = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        self.ui_4RCenter = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        self.ui_4RRight = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES;
            view;
        });
        [self.ui_4Row addSubview:self.ui_4RLeft];
        [self.ui_4Row addSubview:self.ui_4RCenter];
        [self.ui_4Row addSubview:self.ui_4RRight];
        
        // 竖线分隔
        self.imv_4R1LineY = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_4R2LineY = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        [self.ui_4RLeft addSubview:self.imv_4R1LineY];
        [self.ui_4RCenter addSubview:self.imv_4R2LineY];
        
        //填充内容资料
        self.lb_subject_score = ({
            UILabel* lb_subject_score = [[UILabel alloc] init];
            lb_subject_score.font = Text_Helvetica(11.0f);
            lb_subject_score.textColor = [UIColor blackColor];
            lb_subject_score.backgroundColor = [UIColor clearColor];
            lb_subject_score.textAlignment = NSTextAlignmentRight;
            lb_subject_score.text = CustomLocalizedString(@"总分", nil);
            lb_subject_score;
        });
        self.lb_score = ({
            UILabel* lb_score = [[UILabel alloc] init];
            lb_score.font = Text_Helvetica(11.0f);
            lb_score.textColor = [UIColor orangeColor];
            lb_score.backgroundColor = [UIColor clearColor];
            lb_score.textAlignment = NSTextAlignmentRight;
            lb_score.text = @"1000";
            lb_score;
        });
        self.lb_subject_mvp = ({
            UILabel* lb_subject_mvp = [[UILabel alloc] init];
            lb_subject_mvp.font = Text_Helvetica(11.0f);
            lb_subject_mvp.textColor = [UIColor blackColor];
            lb_subject_mvp.backgroundColor = [UIColor clearColor];
            lb_subject_mvp.textAlignment = NSTextAlignmentRight;
            lb_subject_mvp.text = CustomLocalizedString(@"MVP次数", nil);
            lb_subject_mvp;
        });
        
        self.lb_mvp = ({
            UILabel* lb_mvp = [[UILabel alloc] init];
            lb_mvp.font = Text_Helvetica(11.0f);
            lb_mvp.textColor = [UIColor orangeColor];
            lb_mvp.backgroundColor = [UIColor clearColor];
            lb_mvp.textAlignment = NSTextAlignmentRight;
            lb_mvp.text = @"10";
            lb_mvp;
        });
        self.lb_subject_more = ({
            UILabel* lb_subject_more = [[UILabel alloc] init];
            lb_subject_more.font = Text_Helvetica(11.0f);
            lb_subject_more.textColor = [UIColor blackColor];
            lb_subject_more.backgroundColor = [UIColor clearColor];
            lb_subject_more.textAlignment = NSTextAlignmentRight;
            lb_subject_more.text = CustomLocalizedString(@"更多", nil);
            lb_subject_more;
        });
        
        [self.ui_4RLeft addSubview:self.lb_subject_score];
        [self.ui_4RLeft addSubview:self.lb_score];
        [self.ui_4RCenter addSubview:self.lb_subject_mvp];
        [self.ui_4RCenter addSubview:self.lb_mvp];
        [self.ui_4RRight addSubview:self.lb_subject_more];
    }
    
    // 第5行布局
    {
        self.btn_cancel = ({
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.backgroundColor = [UIColor greenColor];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(),(CGFloat[]){ 0, 0, 0, 1 });
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(16);
            [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        self.btn_friend = ({
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor orangeColor];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(),(CGFloat[]){ 0, 0, 0, 1 });
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"加好友" forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(16);
            [btn handleControlEvent:UIControlEventTouchUpInside withBlock:friendAction];
            [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        [self.ui_5Row addSubview:self.btn_cancel];
        [self.ui_5Row addSubview:self.btn_friend];
    }
    
}

- (void)setAutoLayout{
   
    WS(ws);
    // 确定 alertView 的frame
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(PlayerAlertWidth, PlayerAlertHeight));
        make.centerY.equalTo(ws.centerY);
        make.centerX.equalTo(ws.centerX);
    }];
    
    // alertview 内分行布局
    {
        // 分行布局
        [self.lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(ws.alertView).with.offset(0);
            make.height.equalTo(AlertTitleHeight);
        }];
        [self.ui_1Row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.lb_title.bottom).offset(0);
            make.height.equalTo(AlertTopRowHeight);
        }];
        [self.ui_2Row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.ui_1Row.bottom).offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.ui_3Row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.ui_2Row.bottom).offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.ui_4Row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.ui_3Row.bottom).offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.ui_5Row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.ui_4Row.bottom).offset(0);
            make.height.equalTo(AlertBottomRowHeight);
        }];
        
        
        // 横线分隔
        [self.imv_0lineX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_1Row.top).with.offset(lineH);
            make.left.right.equalTo(ws.ui_1Row).with.offset(0);
            make.height.equalTo(lineH);
        }];
        [self.imv_1lineX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_1Row.bottom).with.offset(-lineH);
            make.left.right.equalTo(ws.ui_1Row).with.offset(0);
            make.height.equalTo(lineH);
        }];
        [self.imv_2lineX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_2Row.bottom).with.offset(-lineH);
            make.left.right.equalTo(ws.ui_2Row).with.offset(0);
            make.height.equalTo(lineH);
        }];
        [self.imv_3lineX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_3Row.bottom).with.offset(-lineH);
            make.left.right.equalTo(ws.ui_3Row).with.offset(0);
            make.height.equalTo(lineH);
        }];
        [self.imv_4lineX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_4Row.bottom).with.offset(-lineH);
            make.left.right.equalTo(ws.ui_4Row).with.offset(0);
            make.height.equalTo(lineH);
        }];
        
     

    }
    
    // 第一行布局（title 为 第 0 行）
    {
        [self.imv_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_1Row).with.offset(0);
            make.left.equalTo(ws.ui_1Row).with.offset(10);
            make.size.equalTo(CGSizeMake(AlertTopRowHeight-16, AlertTopRowHeight-16));
        }];
        [self.lb_nick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_1Row).with.offset(0);
            make.left.equalTo(ws.imv_icon.right).offset(10);
            make.height.equalTo(14);
        }];
        [self.btn_blacklist mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_1Row).with.offset(0);
            make.right.equalTo(ws.ui_1Row).offset(-8);
            make.size.equalTo(CGSizeMake(80, AlertTopRowHeight/4));
        }];
    }
    
    // 第二行布局
    {
        [self.ui_2RLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_2Row.bottom).with.offset(-lineH);
            make.left.top.equalTo(ws.ui_2Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        [self.ui_2RCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_2Row).with.offset(lineH);
            make.bottom.equalTo(ws.ui_2Row.bottom).with.offset(-lineH);
            make.centerX.equalTo(ws.ui_2Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        [self.ui_2RRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(ws.ui_2Row).with.offset(-lineH);
            make.top.equalTo(ws.ui_2Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        
        // 竖线分隔
        [self.imv_2R1LineY mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_2RLeft.centerY).with.offset(0);
            make.right.equalTo(ws.ui_2RLeft).with.offset(-lineH);
            make.size.equalTo(CGSizeMake(lineH, AlertRowHeight-8));
        }];
        [self.imv_2R2LineY mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_2RCenter.centerY).with.offset(0);
            make.right.equalTo(ws.ui_2RCenter.right).with.offset(-lineH);
            make.size.equalTo(CGSizeMake(lineH, AlertRowHeight-8));
        }];
        
        //填充内容资料
        [self.lb_subject_sex mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_2RLeft.centerY).with.offset(7);
            make.centerX.equalTo(ws.ui_2RLeft.centerX).with.offset(0);
            make.height.equalTo(12);
        }];
        [self.lb_sex mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_2RLeft.centerY).with.offset(-7);
            make.centerX.equalTo(ws.ui_2RLeft.centerX).with.offset(0);
            make.height.equalTo(12);
        }];
        
        [self.lb_subject_age mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_2RCenter.centerX).with.offset(0);
            make.top.equalTo(ws.ui_2RCenter.centerY).with.offset(7);
            make.height.equalTo(12);
        }];
        [self.lb_age mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_2RCenter.centerX).with.offset(0);
            make.bottom.equalTo(ws.ui_2RCenter.centerY).with.offset(-7);
            make.height.equalTo(12);
        }];
        
        
        [self.lb_subject_addr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_2RRight.centerX).with.offset(0);
            make.top.equalTo(ws.ui_2RRight.centerY).with.offset(7);
            make.height.equalTo(12);
        }];
        [self.lb_addr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_2RRight.centerX).with.offset(0);
            make.bottom.equalTo(ws.ui_2RRight.centerY).with.offset(-7);
            make.height.equalTo(12);
        }];
        
    }
    
    // 第三行布局
    {
        [self.ui_3RLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_3Row.bottom).with.offset(-lineH);
            make.left.top.equalTo(ws.ui_3Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        [self.ui_3RCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_3Row).with.offset(lineH);
            make.bottom.equalTo(ws.ui_3Row.bottom).with.offset(-lineH);
            make.centerX.equalTo(ws.ui_3Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        [self.ui_3RRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(ws.ui_3Row).with.offset(-lineH);
            make.top.equalTo(ws.ui_3Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        
        // 竖线分隔
        [self.imv_3R1LineY mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_3RLeft.centerY).with.offset(0);
            make.right.equalTo(ws.ui_3RLeft.right).with.offset(-lineH);
            make.size.equalTo(CGSizeMake(lineH, AlertRowHeight-8));
        }];
        [self.imv_3R2LineY mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_3RCenter.centerY).with.offset(0);
            make.right.equalTo(ws.ui_3RCenter.right).with.offset(-lineH);
            make.size.equalTo(CGSizeMake(lineH, AlertRowHeight-8));
        }];
        
        //填充内容资料
        [self.lb_subject_games mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_3RLeft.centerY).with.offset(7);
            make.centerX.equalTo(ws.ui_3RLeft.centerX).with.offset(0);
            make.height.equalTo(12);
        }];
        [self.lb_games mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_3RLeft.centerY).with.offset(-7);
            make.centerX.equalTo(ws.ui_3RLeft.centerX).with.offset(0);
            make.height.equalTo(12);
        }];
        
        [self.lb_subject_wins mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_3RCenter.centerX).with.offset(0);
            make.top.equalTo(ws.ui_3RCenter.centerY).with.offset(7);
            make.height.equalTo(12);
        }];
        [self.lb_wins mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_3RCenter.centerX).with.offset(0);
            make.bottom.equalTo(ws.ui_3RCenter.centerY).with.offset(-7);
            make.height.equalTo(12);
        }];
        
        
        [self.lb_subject_rate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_3RRight.centerX).with.offset(0);
            make.top.equalTo(ws.ui_3RRight.centerY).with.offset(7);
            make.height.equalTo(12);
        }];
        [self.lb_rate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_3RRight.centerX).with.offset(0);
            make.bottom.equalTo(ws.ui_3RRight.centerY).with.offset(-7);
            make.height.equalTo(12);
        }];
    }
    
    // 第四行布局
    {
        [self.ui_4RLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_4Row.bottom).with.offset(-lineH);
            make.left.top.equalTo(ws.ui_4Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        [self.ui_4RCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_4Row).with.offset(lineH);
            make.bottom.equalTo(ws.ui_4Row.bottom).with.offset(-lineH);
            make.centerX.equalTo(ws.ui_4Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        [self.ui_4RRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(ws.ui_4Row).with.offset(-lineH);
            make.top.equalTo(ws.ui_4Row).with.offset(0);
            make.width.equalTo(PlayerAlertWidth/3);
        }];
        
        // 竖线分隔
        [self.imv_4R1LineY mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_4RLeft.centerY).with.offset(0);
            make.right.equalTo(ws.ui_4RLeft.right).with.offset(-lineH);
            make.size.equalTo(CGSizeMake(lineH, AlertRowHeight-8));
        }];
        [self.imv_4R2LineY mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_4RCenter.centerY).with.offset(0);
            make.right.equalTo(ws.ui_4RCenter.right).with.offset(-lineH);
            make.size.equalTo(CGSizeMake(lineH, AlertRowHeight-8));
        }];
        
        
        //填充内容资料
        [self.lb_subject_score mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_4RLeft.centerY).with.offset(7);
            make.centerX.equalTo(ws.ui_4RLeft.centerX).with.offset(0);
            make.height.equalTo(12);
        }];
        [self.lb_score mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_4RLeft.centerY).with.offset(-7);
            make.centerX.equalTo(ws.ui_4RLeft.centerX).with.offset(0);
            make.height.equalTo(12);
        }];
        
        [self.lb_subject_mvp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_4RCenter.centerX).with.offset(0);
            make.top.equalTo(ws.ui_4RCenter.centerY).with.offset(7);
            make.height.equalTo(12);
        }];
        [self.lb_mvp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_4RCenter.centerX).with.offset(0);
            make.bottom.equalTo(ws.ui_4RCenter.centerY).with.offset(-7);
            make.height.equalTo(12);
        }];
        
        
        [self.lb_subject_more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.ui_4RRight.centerX).with.offset(0);
            make.centerY.equalTo(ws.ui_4RRight.centerY).with.offset(0);
            make.height.equalTo(12);
        }];

    }
    
    // 第5行布局
    {
        [self.btn_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_5Row).with.offset(0);
            make.left.equalTo(ws.ui_5Row).offset(32);
            make.size.equalTo(CGSizeMake(PlayerAlertWidth/2 -32*2, PlayerAlertBtnHeight));
        }];
        [self.btn_friend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_5Row).with.offset(0);
            make.right.equalTo(ws.ui_5Row).offset(-32);
            make.size.equalTo(CGSizeMake(PlayerAlertWidth/2 -32*2, PlayerAlertBtnHeight));
        }];
    }
    
}

@end


