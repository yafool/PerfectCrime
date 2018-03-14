//
//  WhisperView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/13.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "WhisperView.h"
#import "MYCoreTextLabel.h"
#import "NSString+extension.h"


@interface WhisperView ()

@property (nonatomic, strong) UIImageView  *imv_back;
@property (nonatomic, strong) UILabel      *lb_title;
@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, strong) UIView *lastView;
@end

@implementation WhisperView

@synthesize delegate = _delegate;

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
        imv_back.backgroundColor = [UIColor clearColor];
        imv_back.userInteractionEnabled = YES;
        //阴影
        imv_back.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        imv_back.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); //[水平偏移, 垂直偏移]
        imv_back.layer.shadowOpacity = 1.0f; //0.0 ~ 1.0 的值
        imv_back.layer.shadowRadius = 10.0f; // 阴影发散的程度
        
        imv_back;
    });
    self.lb_title = ({
        UILabel*lb_title     = [[UILabel alloc] init];
        lb_title.font = Text_Helvetica(12.0f);
        lb_title.textColor = [UIColor blackColor];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.textAlignment = NSTextAlignmentLeft;
        lb_title.text = CustomLocalizedString(@"警察或匪徒夜晚交流区", nil);
        lb_title;
    });
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor lightGrayColor];
        scrollView.showsHorizontalScrollIndicator = NO;//不显示水平滑动条
        scrollView.showsVerticalScrollIndicator = NO;//不显示垂直滑动条
        [scrollView setPagingEnabled:YES];//开启分页，也就是不允许滑动到一半
        scrollView.alwaysBounceVertical = NO;
        scrollView.alwaysBounceHorizontal = NO;
        [scrollView setBounces:NO];
        scrollView.delegate = self;
        scrollView;
    });
    
    
    
    [self addSubview:self.imv_back];
    
    [self.imv_back addSubview:self.lb_title];
    [self.imv_back addSubview:self.scrollView];
    
}

- (void)setAutoLayout{
    WS(ws);
    [self.imv_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.lb_title makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws.imv_back).with.offset(4);
        make.right.equalTo(ws.imv_back).with.offset(-4);
        make.height.equalTo(14);
    }];
    
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.imv_back).with.offset(4);
        make.top.equalTo(self.lb_title.bottom).with.offset(4);
        make.right.equalTo(ws.imv_back).with.offset(-4);
        make.bottom.equalTo(ws.imv_back).offset(-8);
    }];
    
    
    
}

#pragma mark --- delegate
- (void)pillowTalk:(PlayerInfo*)player andWhisper:(NSString*)whisper{
    NSString *speaker = [NSString stringWithFormat:@"%@ : ",  (player.nickName?player.nickName:player.num)];
    CGSize speakerSize = [speaker sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, 14)];
    if (80<speakerSize.width) {
        speakerSize.width=80;
    }
    
    CGRect frame = self.scrollView.frame;
    CGFloat constWidth = frame.size.width - speakerSize.width - 4;
    CGSize whisperBound = CGSizeMake(constWidth, CGFLOAT_MAX);
    CGSize whisperSize = [whisper sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:whisperBound lineBreakMode:UILineBreakModeWordWrap];
   
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor clearColor];
    if (self.lastView) {
        CGPoint origin = self.lastView.frame.origin;
        CGSize size = self.lastView.frame.size;
        contentView.frame = CGRectMake(origin.x, origin.y+size.height, frame.size.width, whisperSize.height);
    } else {
        contentView.frame = CGRectMake(0, 0, frame.size.width, whisperSize.height);
    }
    self.lastView = contentView;
    
    MYCoreTextLabel *speakerLable = [[MYCoreTextLabel alloc]init];
    speakerLable.textFont = Text_Helvetica(13);
    speakerLable.textColor = [UIColor orangeColor];
    speakerLable.hiddenNormalLink = YES;
    speakerLable.lineSpacing = 3;
    [speakerLable setText:speaker customLinks:nil keywords:nil];
    speakerLable.frame = CGRectMake(0, 0, speakerSize.width, speakerSize.height);
    [contentView addSubview:speakerLable];
    
    MYCoreTextLabel *whisperLable = [[MYCoreTextLabel alloc]init];
    whisperLable.textFont = Text_Helvetica(13);
    whisperLable.textColor = [UIColor whiteColor];
    whisperLable.hiddenNormalLink = YES;
    whisperLable.lineSpacing = 3;
    [whisperLable setText:whisper customLinks:nil keywords:nil];
    whisperLable.frame = CGRectMake(frame.size.width-constWidth, 0, whisperSize.width, whisperSize.height);
    [contentView addSubview:whisperLable];
    //刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView addSubview:contentView];
        CGSize contentSize = self.scrollView.frame.size;
        contentSize.height = self.lastView.frame.origin.y + self.lastView.frame.size.height;
        [self.scrollView setContentSize:contentSize];

    });
    
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    if (_delegate && [_delegate respondsToSelector:@selector(OnWhisperViewDidScroll)])
    {
        [_delegate OnWhisperViewDidScroll];
    }
}

@end
