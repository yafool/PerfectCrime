//
//  PlayerGameInfoView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/21.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "PlayerGameInfoView.h"

@interface PlayerGameInfoView ()
@property (nonatomic, strong) UIImageView *imv_back;
@property (nonatomic, strong) UILabel     *lb_title;

@property (nonatomic, strong) UIImageView *imv_info;
@property (nonatomic, strong) UIImageView *imv_lineX1;
@property (nonatomic, strong) UIImageView *imv_lineX2;

@property (nonatomic, strong) UIImageView *upLeftView;
@property (nonatomic, strong) UIImageView *upCenterView;
@property (nonatomic, strong) UIImageView *upRightView;
@property (nonatomic, strong) UIImageView *imv_lineUpY1;
@property (nonatomic, strong) UIImageView *imv_lineUpY2;

@property (nonatomic, strong) UIImageView *downLeftView;
@property (nonatomic, strong) UIImageView *downCenterView;
@property (nonatomic, strong) UIImageView *downRightView;
@property (nonatomic, strong) UIImageView *imv_lineDownY1;
@property (nonatomic, strong) UIImageView *imv_lineDownY2;


@property (nonatomic, strong) UILabel     *lb_subject_games;
@property (nonatomic, strong) UILabel     *lb_games;

@property (nonatomic, strong) UILabel     *lb_subject_wins;
@property (nonatomic, strong) UILabel     *lb_wins;

@property (nonatomic, strong) UILabel     *lb_subject_rate;
@property (nonatomic, strong) UILabel     *lb_rate;

@property (nonatomic, strong) UILabel     *lb_subject_score;
@property (nonatomic, strong) UILabel     *lb_score;

@property (nonatomic, strong) UILabel     *lb_subject_mvp;
@property (nonatomic, strong) UILabel     *lb_mvp;

@property (nonatomic, strong) UILabel     *lb_subject_more;

@end

@implementation PlayerGameInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setAllView];
        [self setAutoLayout];
    }
    return self;
}

-(void)setAllView{
    
    self.imv_back = ({
        UIImageView*imv_back     = [[UIImageView alloc] init];
        imv_back.backgroundColor = [UIColor whiteColor];
        imv_back.userInteractionEnabled = YES;
        imv_back;
    });
    self.lb_title = ({
        UILabel* lb_title = [[UILabel alloc] init];
        lb_title.font = Text_Helvetica(11.0f);
        lb_title.textColor = [UIColor blackColor];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.textAlignment = NSTextAlignmentRight;
        lb_title.text = CustomLocalizedString(@"历史战绩", nil);
        lb_title;
    });
    self.imv_info = ({
        UIImageView*imv_info = [[UIImageView alloc] init];
        imv_info.backgroundColor = [UIColor clearColor];
        imv_info.userInteractionEnabled = YES;
        imv_info;
    });
    self.imv_lineX1 = ({
        UIImageView*imv_lineX1     = [[UIImageView alloc] init];
        imv_lineX1.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineX1;
    });
    self.imv_lineX2 = ({
        UIImageView*imv_lineX2     = [[UIImageView alloc] init];
        imv_lineX2.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineX2;
    });
    self.upLeftView = ({
        UIImageView*upLeftView = [[UIImageView alloc] init];
        upLeftView.backgroundColor = [UIColor clearColor];
        upLeftView.userInteractionEnabled = YES;
        upLeftView;
    });
    self.upCenterView = ({
        UIImageView*upCenterView = [[UIImageView alloc] init];
        upCenterView.backgroundColor = [UIColor clearColor];
        upCenterView.userInteractionEnabled = YES;
        upCenterView;
    });
    self.upRightView = ({
        UIImageView*upRightView = [[UIImageView alloc] init];
        upRightView.backgroundColor = [UIColor clearColor];
        upRightView.userInteractionEnabled = YES;
        upRightView;
    });
    self.imv_lineUpY1 = ({
        UIImageView*imv_lineUpY1     = [[UIImageView alloc] init];
        imv_lineUpY1.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineUpY1;
    });
    self.imv_lineUpY2 = ({
        UIImageView*imv_lineUpY2     = [[UIImageView alloc] init];
        imv_lineUpY2.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineUpY2;
    });
    self.downLeftView = ({
        UIImageView*downLeftView = [[UIImageView alloc] init];
        downLeftView.backgroundColor = [UIColor clearColor];
        downLeftView.userInteractionEnabled = YES;
        downLeftView;
    });
    self.downCenterView = ({
        UIImageView*downCenterView = [[UIImageView alloc] init];
        downCenterView.backgroundColor = [UIColor clearColor];
        downCenterView.userInteractionEnabled = YES;
        downCenterView;
    });
    self.downRightView = ({
        UIImageView*downRightView = [[UIImageView alloc] init];
        downRightView.backgroundColor = [UIColor clearColor];
        downRightView.userInteractionEnabled = YES;
        downRightView;
    });
    self.imv_lineDownY1 = ({
        UIImageView*imv_lineDownY1     = [[UIImageView alloc] init];
        imv_lineDownY1.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineDownY1;
    });
    self.imv_lineDownY2 = ({
        UIImageView*imv_lineDownY2     = [[UIImageView alloc] init];
        imv_lineDownY2.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
        imv_lineDownY2;
    });
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
    
    
    // 立经建设纬
    [self addSubview:self.imv_back];
    
    [self.imv_back addSubview:self.lb_title];
    [self.imv_back addSubview:self.imv_info];
    
    [self.imv_info addSubview:self.imv_lineX1];
    [self.imv_info addSubview:self.imv_lineX2];
    
    [self.imv_info addSubview:self.upLeftView];
    [self.imv_info addSubview:self.upCenterView];
    [self.imv_info addSubview:self.upRightView];
    
    [self.imv_info addSubview:self.downLeftView];
    [self.imv_info addSubview:self.downCenterView];
    [self.imv_info addSubview:self.downRightView];
    
    //左上块儿
    [self.upLeftView addSubview:self.imv_lineUpY1];
    [self.upLeftView addSubview:self.lb_subject_games];
    [self.upLeftView addSubview:self.lb_games];
    //中上块儿
    [self.upCenterView addSubview:self.imv_lineUpY2];
    [self.upCenterView addSubview:self.lb_subject_wins];
    [self.upCenterView addSubview:self.lb_wins];
    //右上块儿
    [self.upRightView addSubview:self.lb_subject_rate];
    [self.upRightView addSubview:self.lb_rate];
    
    //左下块儿
    [self.downLeftView addSubview:self.imv_lineDownY1];
    [self.downLeftView addSubview:self.lb_subject_score];
    [self.downLeftView addSubview:self.lb_score];
    //中下块儿
    [self.downCenterView addSubview:self.imv_lineDownY2];
    [self.downCenterView addSubview:self.lb_subject_mvp];
    [self.downCenterView addSubview:self.lb_mvp];
    //右下块儿
    [self.downRightView addSubview:self.lb_subject_more];
}

- (void)setAutoLayout{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
  
    [self.lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws.imv_back).with.offset(2);
        make.height.equalTo(12);
    }];
    
    [self.imv_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(ws.imv_back).with.offset(0);
        make.top.equalTo(ws.lb_title.bottom).with.offset(10);
    }];
    
    [self.imv_lineX1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.imv_info.centerY).with.offset(0);
        make.left.equalTo(ws.imv_info).with.offset(0);
        make.right.equalTo(ws.imv_info).with.offset(0);
        make.height.equalTo(lineH);
    }];
    
    [self.imv_lineX2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_info.bottom).with.offset(-lineH);
        make.left.equalTo(ws.imv_info).with.offset(0);
        make.right.equalTo(ws.imv_info).with.offset(0);
        make.height.equalTo(lineH);
    }];
   
    [self.upLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(ws.imv_info).with.offset(0);
        make.bottom.equalTo(ws.imv_lineX1.top).with.offset(-1);
        make.width.equalTo(ViewFrame_bounds_width/3);
    }];
    [self.upCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_info).with.offset(0);
        make.centerX.equalTo(ws.imv_info.centerX).with.offset(0);
        make.bottom.equalTo(ws.imv_lineX1.top).with.offset(-1);
        make.width.equalTo(ViewFrame_bounds_width/3);
    }];
    [self.upRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(ws.imv_info).with.offset(0);
        make.bottom.equalTo(ws.imv_lineX1.top).with.offset(-1);
        make.width.equalTo(ViewFrame_bounds_width/3);
    }];
    
    [self.downLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(ws.imv_info).with.offset(0);
        make.top.equalTo(ws.imv_lineX1.bottom).with.offset(2);
        make.width.equalTo(ViewFrame_bounds_width/3);
    }];
    [self.downCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_info).with.offset(0);
        make.top.equalTo(ws.imv_lineX1.bottom).with.offset(2);
        make.centerX.equalTo(ws.imv_info.centerX).with.offset(0);
        make.width.equalTo(ViewFrame_bounds_width/3);
    }];
    [self.downRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(ws.imv_info).with.offset(0);
        make.top.equalTo(ws.imv_lineX1.bottom).with.offset(2);
        make.width.equalTo(ViewFrame_bounds_width/3);
    }];
    
    [self.imv_lineUpY1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.upLeftView).with.offset(8);
        make.bottom.equalTo(ws.upLeftView).with.offset(-8);
        make.right.equalTo(ws.upLeftView).with.offset(-1);
        make.width.equalTo(lineH);
    }];
    [self.lb_subject_games mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_lineUpY1.bottom).with.offset(0);
        make.centerX.equalTo(ws.upLeftView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    [self.lb_games mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_lineUpY1.top).with.offset(0);
        make.centerX.equalTo(ws.upLeftView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    
    [self.imv_lineUpY2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.upCenterView).with.offset(8);
        make.bottom.equalTo(ws.upCenterView).with.offset(-8);
        make.right.equalTo(ws.upCenterView).with.offset(-1);
        make.width.equalTo(lineH);
    }];
    [self.lb_subject_wins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_lineUpY2.bottom).with.offset(0);
        make.centerX.equalTo(ws.upCenterView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    [self.lb_wins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_lineUpY2.top).with.offset(0);
        make.centerX.equalTo(ws.upCenterView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
   
    [self.lb_subject_rate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_lineUpY2.bottom).with.offset(0);
        make.centerX.equalTo(ws.upRightView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    [self.lb_rate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_lineUpY2.top).with.offset(0);
        make.centerX.equalTo(ws.upRightView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    
    [self.imv_lineDownY1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.downLeftView).with.offset(8);
        make.bottom.equalTo(ws.downLeftView).with.offset(-8);
        make.right.equalTo(ws.downLeftView).with.offset(-1);
        make.width.equalTo(lineH);
    }];
    [self.lb_subject_score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_lineDownY1.bottom).with.offset(0);
        make.centerX.equalTo(ws.downLeftView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    [self.lb_score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_lineDownY1.top).with.offset(0);
        make.centerX.equalTo(ws.downLeftView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    
    
    [self.imv_lineDownY2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.downCenterView).with.offset(8);
        make.bottom.equalTo(ws.downCenterView).with.offset(-8);
        make.right.equalTo(ws.downCenterView).with.offset(-1);
        make.width.equalTo(lineH);
    }];
    [self.lb_subject_mvp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.imv_lineDownY2.bottom).with.offset(0);
        make.centerX.equalTo(ws.downCenterView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    [self.lb_mvp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.imv_lineDownY2.top).with.offset(0);
        make.centerX.equalTo(ws.downCenterView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
    
    [self.lb_subject_more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.downRightView.centerY).with.offset(0);
        make.centerX.equalTo(ws.downRightView.centerX).with.offset(0);
        make.height.equalTo(12);
    }];
}

-(void)initGameInfo:(NSDictionary*)m_dict{
 
    NSString * games = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"gamesNum"]];
    self.lb_games.text = games;
    
    NSString * wins = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"winsNum"]];
    self.lb_wins.text = wins;
    
    NSString * rate = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"winsRate"]];
    self.lb_rate.text = rate;
    
    NSString * score = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"gameScore"]];
    self.lb_score.text = score;
    
    NSString * mvp = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"mvpNum"]];
    self.lb_mvp.text = mvp;
}
@end
