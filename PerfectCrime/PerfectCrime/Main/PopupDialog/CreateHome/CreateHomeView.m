//
//  CreateHomeView.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/18.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "CreateHomeView.h"
#import "HomeAppearance.h"
#import "KxMenu.h"

//AlertViewWidth
#define AlertTitleHeight        DlgTitleHeight
#define AlertRowHeight          40
#define AlertBottomRowHeight    DlgBottomRowHeight

#define CreateHomeWidth    DlgWidth
#define CreateHomeHeight   (AlertTitleHeight + AlertBottomRowHeight + AlertRowHeight*6)
//按钮默认高度
#define CreateHomeBtnHeight DlgBtnHeight

// UITextField tag
typedef NS_ENUM(NSUInteger, TextFieldTAG) {
    TextFieldTAGName,
    TextFieldTAGGrade,
    TextFieldTAGPasswd1,
    TextFieldTAGPasswd2
};
// button tag
typedef NS_ENUM(NSUInteger, ButtonPopmenuTAG) {
    ButtonPopmenuTAGGrade = 0,
    ButtonPopmenuTAGSpeed,
    ButtonPopmenuTAGLimit
};

#define pushMenuItemQuick  kHomeSpeed_quick
#define pushMenuItemNormal kHomeSpeed_normal
#define pushMenuItemSlow   kHomeSpeed_slow

#define pushMenuItemLimit8   @"8"
#define pushMenuItemLimit10  @"10"
#define pushMenuItemLimit12  @"12"
#define pushMenuItemLimit16  @"16"

#pragma mark --- CreateHomeView
@interface CreateHomeView () <UITextFieldDelegate>
{
    HomeAppearance *homeAppearance;
}
//@property (nonatomic, strong) PlayerAppearance *appearance;

@property (nonatomic, strong) UILabel       *lb_title;
@property (nonatomic, strong) UIImageView   *ui_edit;
@property (nonatomic, strong) UIImageView   *ui_button;

@property (nonatomic, strong) UIImageView   *imv_lineTop;
@property (nonatomic, strong) UIImageView   *imv_lineBottom;

@property (nonatomic, strong) UILabel       *lb_name;
@property (nonatomic, strong) UITextField   *tf_name;

@property (nonatomic, strong) UILabel       *lb_grade;
@property (nonatomic, strong) UIButton      *btn_grade;

@property (nonatomic, strong) UILabel       *lb_speed;
@property (nonatomic, strong) UIButton      *btn_speed;

@property (nonatomic, strong) UILabel       *lb_limit;
@property (nonatomic, strong) UIButton      *btn_limit;

@property (nonatomic, strong) UILabel       *lb_passwd1;
@property (nonatomic, strong) UITextField   *tf_passwd1;

@property (nonatomic, strong) UILabel       *lb_passwd2;
@property (nonatomic, strong) UITextField   *tf_passwd2;

@property (nonatomic, strong) UIButton      *btn_cancel;
@property (nonatomic, strong) UIButton      *btn_create;

@end

@implementation CreateHomeView

+ (HomeAppearance *)appearances{
    
    static HomeAppearance* appearance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [[HomeAppearance alloc] init];
    });
    
    return appearance;
}

+ (void)showWithCreateAction:(CommitAction)createAction{
    CreateHomeView* alertView = [[CreateHomeView alloc]initViewWithAction:createAction];
    
    [alertView show];
    
}

- (id)initViewWithAction:(CommitAction)createAction{
    
    if (self = [super init]){
        [self setAllViewWithAction:createAction];
        [self setAutoLayout];
        [self initData];
    }
    
    return self;
}

-(void)setAllViewWithAction:(CommitAction)createAction{
   
    // 背景前景式布局
    {
        //初始化窗体 背景区域
        self.backgroundColor = [CreateHomeView appearances].DlgMaskViewColor;
        self.frame = FullScreen;
        self.userInteractionEnabled = YES;
        
        
        //显示区域
        self.alertView = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [CreateHomeView appearances].DlgViewColor;
            view.layer.cornerRadius = [CreateHomeView appearances].DlgViewCornerRadius;
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
            lb.text = @"创建房间";
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
        self.lb_name = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.font = Text_Helvetica(13.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"房间名称：";
            lb;
        });
        self.tf_name = ({
            UITextField*tf =[[UITextField alloc]init];
            tf.layer.cornerRadius = 3.0;
            tf.backgroundColor =[UIColor whiteColor];
            tf.delegate =self;
            tf.tag =TextFieldTAGName;
            tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            tf.leftViewMode = UITextFieldViewModeAlways;//设置显示模式为永远显示(默认不显示)
            tf.placeholder = CustomLocalizedString(@"房间名称", nil);
            tf.clearButtonMode =UITextFieldViewModeWhileEditing;
            tf.keyboardType =UIKeyboardTypeASCIICapable;
            tf.returnKeyType =UIReturnKeyDone;
            tf.font = Text_Helvetica(13);
            [tf setValue:Text_Helvetica(13) forKeyPath:@"_placeholderLabel.font"];
            tf;
        });
        [self.ui_edit addSubview:self.lb_name];
        [self.ui_edit addSubview:self.tf_name];
        
        // 编辑房间等级
        self.lb_grade = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.font = Text_Helvetica(13.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"房间等级：";
            lb;
        });
        self.btn_grade = ({
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = [CustomColorRGB colorWithHexString:kLineColor].CGColor;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(14);
            btn.tag=ButtonPopmenuTAGGrade;
            [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self.ui_edit addSubview:self.lb_grade];
        [self.ui_edit addSubview:self.btn_grade];
        
        // 编辑房速
        self.lb_speed = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.font = Text_Helvetica(13.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"房速：";
            lb;
        });
        self.btn_speed = ({
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = [CustomColorRGB colorWithHexString:kLineColor].CGColor;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(14);
            btn.tag=ButtonPopmenuTAGSpeed;
            [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });

        [self.ui_edit addSubview:self.lb_speed];
        [self.ui_edit addSubview:self.btn_speed];
        
        // 编辑人数限制
        self.lb_limit = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.font = Text_Helvetica(13.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"人数限制：";
            lb;
        });
        self.btn_limit = ({
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = [CustomColorRGB colorWithHexString:kLineColor].CGColor;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(14);
            btn.tag=ButtonPopmenuTAGLimit;
            [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self.ui_edit addSubview:self.lb_limit];
        [self.ui_edit addSubview:self.btn_limit];
        
        // 编辑密码
        self.lb_passwd1 = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.font = Text_Helvetica(13.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"密码：";
            lb;
        });
        self.tf_passwd1 = ({
            UITextField*tf =[[UITextField alloc]init];
            tf.layer.cornerRadius = 3.0;
            tf.backgroundColor =[UIColor whiteColor];
            tf.delegate =self;
            tf.secureTextEntry =YES; //密码
            tf.tag =TextFieldTAGPasswd1;
            tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            tf.leftViewMode = UITextFieldViewModeAlways;//设置显示模式为永远显示(默认不显示)
            tf.placeholder = @"输入密码";
            tf.clearButtonMode =UITextFieldViewModeWhileEditing;
            tf.returnKeyType =UIReturnKeyDone;
            tf.font = Text_Helvetica(14);
            [tf setValue:Text_Helvetica(14) forKeyPath:@"_placeholderLabel.font"];
            tf;
        });
        [self.ui_edit addSubview:self.lb_passwd1];
        [self.ui_edit addSubview:self.tf_passwd1];
        
        // 编辑密码
        self.lb_passwd2 = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.font = Text_Helvetica(13.0f);
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"确认：";
            lb;
        });
        self.tf_passwd2 = ({
            UITextField*tf =[[UITextField alloc]init];
            tf.layer.cornerRadius = 3.0;
            tf.backgroundColor =[UIColor whiteColor];
            tf.delegate =self;
            tf.secureTextEntry =YES; //密码
            tf.tag =TextFieldTAGPasswd2;
            tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            tf.leftViewMode = UITextFieldViewModeAlways;//设置显示模式为永远显示(默认不显示)
            tf.placeholder = @"确认密码";
            tf.clearButtonMode =UITextFieldViewModeWhileEditing;
            tf.returnKeyType =UIReturnKeyDone;
            tf.font = Text_Helvetica(14);
            [tf setValue:Text_Helvetica(14) forKeyPath:@"_placeholderLabel.font"];
            tf;
        });
        [self.ui_edit addSubview:self.lb_passwd2];
        [self.ui_edit addSubview:self.tf_passwd2];
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
            [btn setTitle:@"创建" forState:UIControlStateNormal];
            btn.titleLabel.font = Text_Helvetica(16);
            [btn addTarget:self action:@selector(onCreateHome) forControlEvents:UIControlEventTouchUpInside];
            [btn handleControlEvent:UIControlEventTouchUpInside withBlock:createAction];
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
        make.size.equalTo(CGSizeMake(CreateHomeWidth, CreateHomeHeight));
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
            make.height.equalTo(AlertRowHeight*6);
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
        [self.lb_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.ui_edit.top).with.offset(lineH);
            make.left.equalTo(ws.ui_edit).with.offset(10);
            make.size.equalTo(CGSizeMake(100, AlertRowHeight));
        }];
        [self.tf_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_name.centerY).with.offset(0);
            make.left.equalTo(ws.lb_name.right).offset(10);
            make.right.equalTo(ws.ui_edit.right).offset(-10);
            make.height.equalTo(32);
        }];
        
        [self.lb_grade mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.lb_name.bottom).with.offset(lineH);
            make.left.right.equalTo(ws.lb_name).with.offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.btn_grade mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_grade.centerY).with.offset(0);
            make.left.right.equalTo(ws.tf_name).offset(0);
            make.height.equalTo(32);
        }];
        
        [self.lb_speed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.lb_grade.bottom).with.offset(lineH);
            make.left.right.equalTo(ws.lb_name).with.offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.btn_speed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_speed.centerY).with.offset(0);
            make.left.right.equalTo(ws.tf_name).offset(0);
            make.height.equalTo(32);
        }];
        
        [self.lb_limit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.lb_speed.bottom).with.offset(lineH);
            make.left.right.equalTo(ws.lb_name).with.offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.btn_limit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_limit.centerY).with.offset(0);
            make.left.right.equalTo(ws.tf_name).offset(0);
            make.height.equalTo(32);
        }];
        
        [self.lb_passwd1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.lb_limit.bottom).with.offset(lineH);
            make.left.right.equalTo(ws.lb_name).with.offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.tf_passwd1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_passwd1.centerY).with.offset(0);
            make.left.right.equalTo(ws.tf_name).offset(0);
            make.height.equalTo(32);
        }];
        
        [self.lb_passwd2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.lb_passwd1.bottom).with.offset(lineH);
            make.left.right.equalTo(ws.lb_name).with.offset(0);
            make.height.equalTo(AlertRowHeight);
        }];
        [self.tf_passwd2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.lb_passwd2.centerY).with.offset(0);
            make.left.right.equalTo(ws.tf_name).offset(0);
            make.height.equalTo(32);
        }];
    }
    
    // button 布局
    {
        [self.btn_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_button).with.offset(0);
            make.left.equalTo(ws.ui_button).offset(32);
            make.size.equalTo(CGSizeMake(CreateHomeWidth/2 -32*2, CreateHomeBtnHeight));
        }];
        [self.btn_create mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_button).with.offset(0);
            make.right.equalTo(ws.ui_button).offset(-32);
            make.size.equalTo(CGSizeMake(CreateHomeWidth/2 -32*2, CreateHomeBtnHeight));
        }];
    }
    
}

-(void)initData{
    NSString *init_grade = kHomeGrade_rookie;
    NSString *init_speed = kHomeSpeed_slow;
    NSString *init_limit = @"16";
    
    [self.btn_grade setTitle:init_grade forState:UIControlStateNormal];
    [self.btn_speed setTitle:init_speed forState:UIControlStateNormal];
    [self.btn_limit setTitle:init_limit forState:UIControlStateNormal];
    
    [[CreateHomeView appearances]setGrade:init_grade];
    [[CreateHomeView appearances]setSpeed:init_speed];
    [[CreateHomeView appearances]setLimit:init_limit];
}

-(void)onCreateHome{
    if ([CustomStringFunc isBlankString:self.tf_name.text]) {
        [MBProgressHUD showInfoMessage:@"请编辑房间名称！"];
        [[CreateHomeView appearances]setCreateValid:NO];
        return;
    }
    
    if ([CustomStringFunc isBlankString:self.tf_passwd1.text]
        && [CustomStringFunc isBlankString:self.tf_passwd2.text]) {
        [[CreateHomeView appearances]setCreateValid:YES];
        [self dismiss];
    }else if([self.tf_passwd1.text isEqualToString:self.tf_passwd2.text]){
        [[CreateHomeView appearances]setCreateValid:YES];
        [self dismiss];
    }else{
        [MBProgressHUD showInfoMessage:@"密码不一致"];
        [[CreateHomeView appearances]setCreateValid:NO];
    }
}

- (void)showMenu:(UIButton *)sender
{
    switch (sender.tag) {
        case ButtonPopmenuTAGGrade:{
            NSArray *menuItems =
            @[
              [KxMenuItem menuItem:kHomeGrade_rookie
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              
              [KxMenuItem menuItem:kHomeGrade_master
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              ];
            
            [KxMenu showMenuInView:self.alertView
                          fromRect:sender.frame
                         menuItems:menuItems];
            break;
        }
        case ButtonPopmenuTAGSpeed:{
            NSArray *menuItems =
            @[
              [KxMenuItem menuItem:pushMenuItemQuick
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              
              [KxMenuItem menuItem:pushMenuItemNormal
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              
              [KxMenuItem menuItem:pushMenuItemSlow
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              ];
            
            [KxMenu showMenuInView:self.alertView
                          fromRect:sender.frame
                         menuItems:menuItems];
            break;
        }
        case ButtonPopmenuTAGLimit:{
            NSArray *menuItems =
            @[
              [KxMenuItem menuItem:pushMenuItemLimit8
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              
              [KxMenuItem menuItem:pushMenuItemLimit10
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              
              [KxMenuItem menuItem:pushMenuItemLimit12
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              [KxMenuItem menuItem:pushMenuItemLimit16
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)]
              ];
            
            [KxMenu showMenuInView:self.alertView
                          fromRect:sender.frame
                         menuItems:menuItems];
            break;
        }
        default:
            break;
    }
}

- (void) pushMenuItem:(id)sender
{
    if ([kHomeGrade_rookie isEqualToString:[sender title]]) {// 新手
        [self.btn_grade setTitle:kHomeGrade_rookie forState:UIControlStateNormal];
        [[CreateHomeView appearances]setGrade:kHomeGrade_rookie];
    }else if([kHomeGrade_master isEqualToString:[sender title]]){// 高手
        [self.btn_grade setTitle:kHomeGrade_master forState:UIControlStateNormal];
        [[CreateHomeView appearances]setGrade:kHomeGrade_master];
    }else if([pushMenuItemQuick isEqualToString:[sender title]]){// 快速
        [self.btn_speed setTitle:pushMenuItemQuick forState:UIControlStateNormal];
        [[CreateHomeView appearances]setSpeed:pushMenuItemQuick];
    }else if([pushMenuItemNormal isEqualToString:[sender title]]){// 正常
        [self.btn_speed setTitle:pushMenuItemNormal forState:UIControlStateNormal];
        [[CreateHomeView appearances]setSpeed:pushMenuItemNormal];
    }else if([pushMenuItemSlow isEqualToString:[sender title]]){// 慢速
        [self.btn_speed setTitle:pushMenuItemSlow forState:UIControlStateNormal];
        [[CreateHomeView appearances]setSpeed:pushMenuItemSlow];
    }else if([pushMenuItemLimit8 isEqualToString:[sender title]]){// 8人
        [self.btn_limit setTitle:pushMenuItemLimit8 forState:UIControlStateNormal];
        [[CreateHomeView appearances]setLimit:pushMenuItemLimit8];
    }else if([pushMenuItemLimit10 isEqualToString:[sender title]]){// 10人
        [self.btn_limit setTitle:pushMenuItemLimit10 forState:UIControlStateNormal];
        [[CreateHomeView appearances]setLimit:pushMenuItemLimit10];
    }else if([pushMenuItemLimit12 isEqualToString:[sender title]]){// 12人
        [self.btn_limit setTitle:pushMenuItemLimit12 forState:UIControlStateNormal];
        [[CreateHomeView appearances]setLimit:pushMenuItemLimit12];
    }else if([pushMenuItemLimit16 isEqualToString:[sender title]]){// 16人
        [self.btn_limit setTitle:pushMenuItemLimit16 forState:UIControlStateNormal];
        [[CreateHomeView appearances]setLimit:pushMenuItemLimit16];
    }
}


#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{

    switch (textField.tag) {
            
        case TextFieldTAGName:{
            [[CreateHomeView appearances]setName:textField.text];
            break;
        }
        case TextFieldTAGGrade:{
            [[CreateHomeView appearances]setGrade:textField.text];
            break;
        }
        case TextFieldTAGPasswd1:{
            if ([self.tf_passwd1.text isEqualToString:self.tf_passwd2.text]) {
                [[CreateHomeView appearances]setPasswd:textField.text];
            }else{
                [[CreateHomeView appearances]setPasswd:nil];
            }
            break;
        }
        case TextFieldTAGPasswd2:{
            if ([self.tf_passwd2.text isEqualToString:self.tf_passwd1.text]) {
                [[CreateHomeView appearances]setPasswd:textField.text];
            }else{
                [[CreateHomeView appearances]setPasswd:nil];
            }
            break;
        }
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

@end


