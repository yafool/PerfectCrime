//
//  HomeConfirmView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/24.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "HomeConfirmView.h"

#define AlertTitleHeight        DlgTitleHeight
#define AlertRowHeight          40
#define AlertBottomRowHeight    DlgBottomRowHeight

#define ConfirmViewWidth    DlgWidth
#define ConfirmViewHeight   (AlertTitleHeight + AlertBottomRowHeight + AlertRowHeight)
//按钮默认高度
#define ConfirmViewBtnHeight DlgBtnHeight


@interface HomeConfirmView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel       *lb_title;
@property (nonatomic, strong) UIImageView   *ui_edit;
@property (nonatomic, strong) UIImageView   *ui_button;

@property (nonatomic, strong) UIImageView   *imv_lineTop;
@property (nonatomic, strong) UIImageView   *imv_lineBottom;

@property (nonatomic, strong) UILabel       *lb_pwd;
@property (nonatomic, strong) UITextField   *tf_pwd;

@property (nonatomic, strong) UIButton      *btn_cancel;
@property (nonatomic, strong) UIButton      *btn_create;
@end


@implementation HomeConfirmView

+ (ConfirmAppearance *)appearances{
    
    static ConfirmAppearance* appearance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [[ConfirmAppearance alloc] init];
    });
    
    return appearance;
}

+ (void)showWithHome:(NSDictionary*)home_dict andAction:(CommitAction)confirmAction{
    [[HomeConfirmView appearances]initConfirm:home_dict];
    HomeConfirmView* alertView = [[HomeConfirmView alloc]initViewWithAction:confirmAction];
    
    [alertView show];
    
}

- (id)initViewWithAction:(CommitAction)confirmAction{
    
    if (self = [super init]){
        [self setAllViewWithAction:confirmAction];
        [self setAutoLayout];
    }
    
    return self;
}

-(void)setAllViewWithAction:(CommitAction)confirmAction{
    
    // 背景前景式布局
    {
        //初始化窗体 背景区域
        self.backgroundColor = [HomeConfirmView appearances].DlgMaskViewColor;
        self.frame = FullScreen;
        self.userInteractionEnabled = YES;
        
        
        //显示区域
        self.alertView = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [HomeConfirmView appearances].DlgViewColor;
            view.layer.cornerRadius = [HomeConfirmView appearances].DlgViewCornerRadius;
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
            lb.text = [[HomeConfirmView appearances]getHomeName];
            lb;
        });
        self.ui_edit = ({
            UIImageView*imagev = [[UIImageView alloc] init];
            imagev.backgroundColor = [UIColor clearColor];
            imagev.userInteractionEnabled = YES;
            imagev;
        });
        
        self.ui_button = ({
            UIImageView*imagev = [[UIImageView alloc] init];
            imagev.backgroundColor = [UIColor clearColor];
            imagev.userInteractionEnabled = YES;
            imagev;
        });
        
        [self.alertView addSubview:self.lb_title];
        [self.alertView addSubview:self.ui_edit];
        [self.alertView addSubview:self.ui_button];
        
        // 横线分隔
        self.imv_lineTop = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        self.imv_lineBottom = ({
            UIImageView*line     = [[UIImageView alloc] init];
            line.backgroundColor = [CustomColorRGB colorWithHexString:kLineColor];
            line;
        });
        
        [self.ui_edit addSubview:self.imv_lineTop];
        [self.ui_edit addSubview:self.imv_lineBottom];
    }
    
    // edit 区域
    {
        // 编辑房间名称
        self.lb_pwd = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.font = Text_Helvetica(13.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"房间密码：";
            lb;
        });
        self.tf_pwd = ({
            UITextField*tf =[[UITextField alloc]init];
            tf.layer.cornerRadius = 3.0;
            tf.backgroundColor =[UIColor whiteColor];
            tf.delegate =self;
            tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            tf.leftViewMode = UITextFieldViewModeAlways;//设置显示模式为永远显示(默认不显示)
            tf.placeholder = @"请输入正确的房间密码";
            tf.clearButtonMode =UITextFieldViewModeWhileEditing;
            tf.keyboardType =UIKeyboardTypeASCIICapable;
            tf.returnKeyType =UIReturnKeyDone;
            tf.font = Text_Helvetica(13);
            [tf setValue:Text_Helvetica(13) forKeyPath:@"_placeholderLabel.font"];
            tf;
        });
        [self.ui_edit addSubview:self.lb_pwd];
        [self.ui_edit addSubview:self.tf_pwd];
    }
    
    // button 区
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
        self.btn_create = ({
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor greenColor];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(),(CGFloat[]){ 0, 0, 0, 1 });
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"确认" forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(16);
            [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            [btn handleControlEvent:UIControlEventTouchUpInside withBlock:confirmAction];
            btn;
        });
        
        [self.ui_button addSubview:self.btn_cancel];
        [self.ui_button addSubview:self.btn_create];
    }
    
}

- (void)setAutoLayout{
    
    WS(ws);
    // 确定 alertView 的frame
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(ConfirmViewWidth, ConfirmViewHeight));
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
        [self.ui_edit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.lb_title.bottom).offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.ui_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.top.equalTo(ws.ui_edit.bottom).offset(0);
            make.height.equalTo(AlertBottomRowHeight);
        }];
        
        
        // 横线分隔
        [self.imv_lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_edit.top).with.offset(0);
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.height.equalTo(lineH);
        }];
        [self.imv_lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.ui_edit.bottom).with.offset(-lineH);
            make.left.right.equalTo(ws.alertView).with.offset(0);
            make.height.equalTo(lineH);
        }];
    }
    
    // edit 区
    {
        // lable 定位
        [self.lb_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_edit.top).with.offset(lineH);
            make.left.equalTo(ws.ui_edit).with.offset(10);
            make.size.equalTo(CGSizeMake(100, AlertRowHeight));
        }];
        [self.tf_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_pwd.centerY).with.offset(0);
            make.left.equalTo(ws.lb_pwd.right).offset(10);
            make.right.equalTo(ws.ui_edit.right).offset(-10);
            make.height.equalTo(32);
        }];
        
    }
    
    // button 布局
    {
        [self.btn_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_button).with.offset(0);
            make.left.equalTo(ws.ui_button).offset(32);
            make.size.equalTo(CGSizeMake(ConfirmViewWidth/2 -32*2, ConfirmViewBtnHeight));
        }];
        [self.btn_create mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_button).with.offset(0);
            make.right.equalTo(ws.ui_button).offset(-32);
            make.size.equalTo(CGSizeMake(ConfirmViewWidth/2 -32*2, ConfirmViewBtnHeight));
        }];
    }
    
}

#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[HomeConfirmView appearances]setInputPwd:textField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
@end
