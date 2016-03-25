//
//  RegisteViewController.m
//  rc
//
//  Created by 余笃 on 16/3/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RegisteViewController.h"
#import "MyTextField.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"
#import "LoginViewController.h"

static CGFloat const kContainViewYNormal = 70.0;
static CGFloat const kContainViewYEditing = 60.0;

@interface RegisteViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UILabel     *logoLabel;

@property (nonatomic, strong) MyTextField *usernameField;
@property (nonatomic, strong) MyTextField *passwordField;
@property (nonatomic,strong) MyTextField *verifyCodeField;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic,strong) UIButton *verifyCodeButton;
@property (nonatomic,strong) UIImageView *leftUsernameView;
@property (nonatomic,strong) UIImageView *leftPasswdView;
@property (nonatomic,strong) UIImageView *leftVerifyCodeView;
@property (nonatomic, strong) UIButton    *registeButton;

@property (nonatomic,strong) NSString *MD5Str;
@property (nonatomic, assign) BOOL isKeyboardShowing;
@property (nonatomic,assign) BOOL isRegisting;

@end

@implementation RegisteViewController

-(NSString *)MD5Str{
    if (!_MD5Str) {
        _MD5Str = [[NSString alloc]init];
    }
    return _MD5Str;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.isKeyboardShowing = NO;
        self.isRegisting = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cross_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(regBackToForwardViewController)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(regBackToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [self configureViews];
    [self configureTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Layout

-(void)viewWillLayoutSubviews{
    
    self.backgroundImageView.frame = self.view.frame;
    
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,400};
    self.logoLabel.center = (CGPoint){kScreenWidth/2,80};
    self.usernameField.frame = (CGRect){50, 184, kScreenWidth - 100, 30};
    self.verifyCodeField.frame = (CGRect){50,224,kScreenWidth-220,30};
    self.verifyCodeButton.frame = (CGRect){kScreenWidth-150,224,100,30};
    self.passwordField.frame = (CGRect){50, 264, kScreenWidth - 100, 30};
    self.registeButton.center = (CGPoint){kScreenWidth/2, 350};
}


#pragma mark - Configure Views

-(void)configureViews{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568_blurred"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];
    
    self.logoLabel = [[UILabel alloc] init];
    self.logoLabel.text = @"日常";
    self.logoLabel.font = [UIFont fontWithName:@"Kailasa" size:36];
    self.logoLabel.textColor = [UIColor blackColor];
    [self.logoLabel sizeToFit];
    [self.containView addSubview:self.logoLabel];
    
}

- (void)configureTextField{
    
    self.usernameField = [[MyTextField alloc] init];
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    self.usernameField.textColor = [UIColor blackColor];
    self.usernameField.font = [UIFont systemFontOfSize:18];
    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.836 alpha:1.000],
                                                                                            NSFontAttributeName:[UIFont italicSystemFontOfSize:18]}];
    self.usernameField.keyboardType = UIKeyboardTypeNumberPad;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftUsernameView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_icon"]];
    self.usernameField.leftView = self.leftUsernameView;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    [self.containView addSubview:self.usernameField];
    
    
    self.verifyCodeField = [[MyTextField alloc] init];
    self.verifyCodeField.textAlignment = NSTextAlignmentCenter;
    self.verifyCodeField.textColor = [UIColor blackColor];
    self.verifyCodeField.font = [UIFont systemFontOfSize:18];
    self.verifyCodeField.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请输入验证码"
                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.836 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:18]}];
    self.verifyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCodeField.returnKeyType = UIReturnKeyNext;
    self.verifyCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.verifyCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyCodeField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftVerifyCodeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Pencil_icon"]];
    self.verifyCodeField.leftView = self.leftVerifyCodeView;
    self.verifyCodeField.leftViewMode = UITextFieldViewModeAlways;
    [self.containView addSubview:self.verifyCodeField];
    
    self.verifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.verifyCodeButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.verifyCodeButton setBackgroundColor:RGB(0xFD8529, 1)];
    self.verifyCodeButton.viewSize = CGSizeMake(110, 30);
    self.verifyCodeButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.verifyCodeButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.verifyCodeButton];
    
    self.passwordField = [[MyTextField alloc] init];
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.textColor = [UIColor blackColor];
    self.passwordField.font = [UIFont systemFontOfSize:18];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.836 alpha:1.000],
                                                                                                                       NSFontAttributeName:[UIFont italicSystemFontOfSize:18]}];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordField.returnKeyType = UIReturnKeyGo;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftPasswdView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_icon"]];
    self.passwordField.leftView = self.leftPasswdView;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    [self.containView addSubview:self.passwordField];
    
    self.registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registeButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registeButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.registeButton setBackgroundColor:RGB(0xFD8529, 1)];
    self.registeButton.viewSize = CGSizeMake(300, 45);
    self.registeButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.registeButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.registeButton];
    
    [self.usernameField addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventEditingDidBegin];
    [self.usernameField addTarget:self action:@selector(goVerify) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.verifyCodeField addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventEditingDidBegin];
    [self.verifyCodeField addTarget:self action:@selector(goPassWord) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.verifyCodeButton addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.passwordField addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventEditingDidBegin];
    [self.passwordField addTarget:self action:@selector(registe) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.registeButton addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - private methods

-(void)beginRegiste{
    self.isRegisting = YES;
    
    self.usernameField.enabled = NO;
    self.verifyCodeField.enabled = NO;
    self.verifyCodeButton.enabled = NO;
    self.passwordField.enabled = NO;
}

-(void)endLogin{
    self.usernameField.enabled = YES;
    self.verifyCodeField.enabled = YES;
    self.verifyCodeButton.enabled = YES;
    self.passwordField.enabled = YES;
    
    self.isRegisting = NO;
}

-(void)registe{
    if (!self.isRegisting) {
       @weakify(self)
        
        [self hideKeyboard];
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.HUD];
        [self.HUD showAnimated:YES];
        if ([self checkVerifyCode:self.verifyCodeField.text]) {
            @strongify(self);
            [[DataManager manager] UserLoginOrRegisteWithUserphone:self.usernameField.text password:self.passwordField.text op_type:@"2" success:^(UserModel *user) {
                @strongify(self);
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"注册成功";
                [self.HUD hideAnimated:YES afterDelay:0.6];
                [self regBackToForwardViewController];
            } failure:^(NSError *error) {
                @strongify(self);
                NSString *reasonString;
                
                if (error.code < 700) {
                    reasonString = @"请检查网络状态";
                } else {
                    reasonString = @"请检查用户名或密码";
                }
                UIAlertController *alterLgnFailControl = [UIAlertController alertControllerWithTitle:@"登录失败" message:reasonString preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *configureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //[self endLogin];
                }];
                [alterLgnFailControl addAction:configureAction];
                [self presentViewController:alterLgnFailControl animated:YES completion:nil];
                
            }];
        }
        else {
            @strongify(self);
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"验证码错误";
            [self.HUD hideAnimated:YES afterDelay:0.6];
        }
    }
}

-(void)sendVerifyCode{
    //生成随机六位验证码
    int num = (arc4random()%1000000);
    NSString *randomNumber = [[NSString alloc]initWithFormat:@"%.6d",num];
    NSString *tokenStr = [NSString stringWithFormat:@"%@sms",randomNumber];
    self.MD5Str = [tokenStr MD5];
    //发送验证码与注册信息
    [[DataManager manager] sendMobileMsgWithMobile:self.usernameField.text type:@"0" msg:randomNumber token:self.MD5Str success:^(NSString *code) {
        if ([code isEqualToString:@"200"]) {
            NSLog(@"send success");
        } else if ([code isEqualToString:@"210"]){
            NSLog(@"send failed");
        } else {
            NSLog(@"请求不合法");
        }
    } failure:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}

-(BOOL)checkVerifyCode:(NSString *)verifyStr{
    NSString *verifyText = [[NSString alloc]initWithFormat:@"%@sms",verifyStr];
    NSString *usrCode = [verifyText MD5];
    if ([usrCode isEqualToString:self.MD5Str]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showKeyboard {
    
    if (self.isKeyboardShowing) {
        ;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.containView.y      = kContainViewYEditing;
            self.usernameField.y    -= 10;
            self.passwordField.y    -= 12;
            self.verifyCodeField.y  -= 12;
            self.verifyCodeButton.y -= 12;
            self.registeButton.y      -= 14;
        }];
        self.isKeyboardShowing = YES;
    }
    
}

- (void)hideKeyboard {
    
    if (self.isKeyboardShowing) {
        self.isKeyboardShowing = NO;
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.containView.y      = kContainViewYNormal;
            self.usernameField.y    += 10;
            self.passwordField.y    += 12;
            self.verifyCodeField.y  += 12;
            self.verifyCodeButton.y += 12;
            self.registeButton.y      += 14;
        } completion:^(BOOL finished) {
        }];
    }
    
}

-(void)goVerify{
    [self.verifyCodeField becomeFirstResponder];
}

-(void)goPassWord{
    [self.passwordField becomeFirstResponder];
}

- (void)regBackToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
