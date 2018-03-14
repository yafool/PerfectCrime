//
//  EditNickView
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "EditNickView.h"
#import "AccountServer.h"

#define AlertTitleHeight        DlgTitleHeight
#define AlertRowHeight          40
#define AlertBottomRowHeight    DlgBottomRowHeight

#define EditNickViewWidth    DlgWidth
#define EditNickViewHeight   (AlertTitleHeight + AlertBottomRowHeight + AlertRowHeight)
//按钮默认高度
#define EditNickViewBtnHeight DlgBtnHeight

@interface EditNickView () <UITextFieldDelegate, AccountServerDelegate>
{
    NSMutableDictionary *weiAccount;
    EditNickSucessBlock sucessBlock;
    EditNickCancelBlock cancelBlock;
    NSString *nick;
}
@property (nonatomic, strong) UILabel       *lb_title;
@property (nonatomic, strong) UIImageView   *ui_edit;
@property (nonatomic, strong) UIImageView   *ui_button;

@property (nonatomic, strong) UIImageView   *imv_lineTop;
@property (nonatomic, strong) UIImageView   *imv_lineBottom;

@property (nonatomic, strong) UILabel       *lb_nick;
@property (nonatomic, strong) UITextField   *tf_nick;

@property (nonatomic, strong) UIButton      *btn_cancel;
@property (nonatomic, strong) UIButton      *btn_create;

@property (nonatomic, strong) AccountServer *AccountServer;
@end

@implementation EditNickView

- (AccountServer*)AccountServer{
    if (!_AccountServer) {
        _AccountServer = [[AccountServer alloc]init];
        _AccountServer.delegate = self;
    }
    
    return _AccountServer;
}

+ (DlgAppearance *)appearances{
    
    static DlgAppearance* appearance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [[DlgAppearance alloc] init];
    });
    
    return appearance;
}

+ (void)showWithRegister:(NSDictionary*)weiAccount andSucessBlock:(EditNickSucessBlock)sucess andCancelBlock:(EditNickCancelBlock)cancel{
    EditNickView* alertView = [[EditNickView alloc]_initViewWithSucessBlock:sucess andCancelBlock:(EditNickCancelBlock)cancel];
    //对于联合登陆来说，需要记录微信帐号
    [alertView _initWeiAccount:weiAccount];
    [alertView show];
}

+ (void)showWithSucessBlock:(EditNickSucessBlock)sucess andCancelBlock:(EditNickCancelBlock)cancel{
    EditNickView* alertView = [[EditNickView alloc]_initViewWithSucessBlock:sucess andCancelBlock:(EditNickCancelBlock)cancel];
    //对于编辑昵称来说，把微信帐号参数置为空
    [alertView _initWeiAccount:nil];
    [alertView show];
}

- (void)_initWeiAccount:(NSDictionary*)m_dict{
    if (!m_dict) {
        weiAccount = nil;
    } else {
        weiAccount = [[NSMutableDictionary alloc]initWithDictionary:m_dict];
    }
}

- (id)_initViewWithSucessBlock:(EditNickSucessBlock)sucess andCancelBlock:(EditNickCancelBlock)cancel{
    
    if (self = [super init]){
        [self _initBlock:sucess andCancelBlock:cancel];
        [self _setAllView];
        [self _setAutoLayout];
    }
    
    return self;
}

- (void)_initBlock:(EditNickSucessBlock)sucess andCancelBlock:(EditNickCancelBlock)cancel{
    sucessBlock = sucess;
    cancelBlock = cancel;
}

-(void)_setAllView{
    
    // 背景前景式布局
    {
        //初始化窗体 背景区域
        self.backgroundColor = [EditNickView appearances].DlgMaskViewColor;
        self.frame = FullScreen;
        self.userInteractionEnabled = YES;
        
        
        //显示区域
        self.alertView = ({
            UIView*view = [[UIView alloc] init];
            view.backgroundColor = [EditNickView appearances].DlgViewColor;
            view.layer.cornerRadius = [EditNickView appearances].DlgViewCornerRadius;
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
            lb.text = @"编辑昵称";
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentCenter;
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
        // 编辑昵称
        self.lb_nick = ({
            UILabel* lb = [[UILabel alloc] init];
            lb.numberOfLines = 0;
            lb.font = Text_Helvetica(16.0f);
            lb.text = @"昵称：";
            lb.textColor = [UIColor blackColor];
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb;
        });
        self.tf_nick = ({
            UITextField*tf =[[UITextField alloc]init];
            tf.layer.cornerRadius = 3.0;
            tf.layer.borderColor = [CustomColorRGB colorWithHexString:kLineColor].CGColor;
            tf.layer.borderWidth = 1.0f;
            tf.backgroundColor =[UIColor whiteColor];
            tf.placeholder = @"昵称只允许编辑一次哟～";
            tf.delegate =self;
            tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            tf.leftViewMode = UITextFieldViewModeAlways;//设置显示模式为永远显示(默认不显示)
            tf.clearButtonMode =UITextFieldViewModeWhileEditing;
            tf.keyboardType =UIKeyboardTypeASCIICapable;
            tf.returnKeyType =UIReturnKeyDone;
            tf.font = Text_Helvetica(13);
            [tf setValue:Text_Helvetica(13) forKeyPath:@"_placeholderLabel.font"];
            tf;
        });
        
        [self.ui_edit addSubview:self.lb_nick];
        [self.ui_edit addSubview:self.tf_nick];
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
            [btn addTarget:self action:@selector(_onCancel) forControlEvents:UIControlEventTouchUpInside];
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
            [btn addTarget:self action:@selector(_onConfirm) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        [self.ui_button addSubview:self.btn_cancel];
        [self.ui_button addSubview:self.btn_create];
    }
    
}

- (void)_setAutoLayout{
    
    WS(ws);
    // 确定 alertView 的frame
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(EditNickViewWidth, EditNickViewHeight));
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
        [self.lb_nick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_edit).with.offset(0);
            make.left.equalTo(ws.ui_edit).offset(10);
            make.size.equalTo(CGSizeMake(56, 32));
        }];
        
        [self.tf_nick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_edit).with.offset(0);
            make.left.equalTo(ws.lb_nick.right).offset(0);
            make.right.equalTo(ws.ui_edit.right).offset(-10);
            make.height.equalTo(32);
        }];
        
    }
    
    // button 布局
    {
        [self.btn_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_button).with.offset(0);
            make.left.equalTo(ws.ui_button).offset(32);
            make.size.equalTo(CGSizeMake(EditNickViewWidth/2 -32*2, EditNickViewBtnHeight));
        }];
        [self.btn_create mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.ui_button).with.offset(0);
            make.right.equalTo(ws.ui_button).offset(-32);
            make.size.equalTo(CGSizeMake(EditNickViewWidth/2 -32*2, EditNickViewBtnHeight));
        }];
    }
    
}

-(void)_onCancel{
    cancelBlock();
    [self dismiss];
}
-(void)_onConfirm{
    if ([CustomStringFunc isBlankString:nick]) {
        [MBProgressHUD showErrorMessage:@"请编辑您的昵称！"];
    } else if (nil != weiAccount){//联合登陆
        [weiAccount setValue:nick forKey:@"nickName"];
        [self.AccountServer requestCologin:weiAccount];
    } else {//编辑昵称
        NSString *userId = [SettingsManager sharedSettingsManager].userId;
        NSString *nickName = nick;
        NSString *picFrame = [SettingsManager sharedSettingsManager].picFrame;
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
        [postDict setValue:userId forKey:@"userId"];
        [postDict setValue:nickName forKey:@"nickName"];
        [postDict setValue:picFrame forKey:@"picFrame"];
        [self.AccountServer requestGetUserInfo:postDict];
    }
}
#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    nick = textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark --- AccountServerDelegate
-(void)responseModify:(NSDictionary*)m_dict{
    NSInteger code = [[m_dict valueForKey:@"code"]integerValue];
    NSString *msg = [m_dict valueForKey:@"msg"];
    if (200 == code) {
        NSString *nickName = [m_dict valueForKey:@"nickName"];
        [[SettingsManager sharedSettingsManager]setNickName:nickName];
        sucessBlock(nil);
        [self dismiss];
    } else if(-2 == code) {
        [MBProgressHUD showErrorMessage:@"昵称重复！"];
    } else if(-3 == code) {
        [MBProgressHUD showErrorMessage:@"您已经不能再修改昵称了"];
    } else {
        [MBProgressHUD showErrorMessage:msg];
    }
}
-(void)responseCologin:(NSDictionary*)m_dict{
    NSInteger code = [[m_dict valueForKey:@"code"]integerValue];
    NSString *msg = [m_dict valueForKey:@"msg"];
    if (200 == code) {
        NSString *userId = [NSString stringWithFormat:@"%@",[m_dict valueForKey:@"userId"]];
        [weiAccount setValue:userId forKey:@"userId"];
        [weiAccount setValue:nick forKey:@"nickName"];
        sucessBlock(weiAccount);
        [self dismiss];
    } else if(-2 == code) {
        [MBProgressHUD showErrorMessage:@"昵称重复！"];
    } else if(-3 == code) {
        [MBProgressHUD showErrorMessage:@"您已经不能再修改昵称了"];
    } else {
        [MBProgressHUD showErrorMessage:msg];
    }
}

@end
