//
//  LoginViewController.m
//  rc
//
//  Created by 余笃 on 16/3/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "LoginViewController.h"
#import "MyTextField.h"
#import "RCUtils.h"
#import "NSString+MD5.h"
#import "Masonry.h"
#import "RegisteViewController.h"
#import "ResetPasswordViewController.h"
#import "CZHomeViewController.h"
#import "RCNetworkingRequestOperationManager.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
static CGFloat const kContainViewYNormal = 70.0;

@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UILabel     *logoLabel;
//@property (nonatomic, strong) UILabel     *descriptionLabel;

@property (nonatomic, strong) MyTextField *usernameField;
@property (nonatomic, strong) MyTextField *passwordField;
@property (nonatomic,strong) UIImageView *leftUsernameView;
@property (nonatomic,strong) UIImageView *leftPasswdView;
@property (nonatomic,strong) UIButton *forgetPwdButton;
@property (nonatomic, strong) UIButton    *loginButton;

@property (nonatomic, assign) BOOL isKeyboardShowing;
@property (nonatomic, assign) BOOL isLogining;

@end

@implementation LoginViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.isKeyboardShowing = NO;
        self.isLogining = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cross_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(logBackToMyInfoViewController)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(turnToRegisteViewController)];
    
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
    
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,kScreenHeight};
    self.logoLabel.center = (CGPoint){kScreenWidth/2,80};
    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGSize maxSize = CGSizeMake(screenSize.width * 0.5, MAXFLOAT);
    CGSize forgetSize = [self sizeWithText:@"忘记密码？" maxSize:maxSize fontSize:12];
    [self.usernameField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.containView.mas_top).offset(162);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
    [self.passwordField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.usernameField.mas_bottom).offset(20);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
    
    [self.forgetPwdButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordField.mas_right);
        make.top.equalTo(self.passwordField.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(forgetSize.width+1, forgetSize.height+1));
    }];
    
    [self.loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.top.equalTo(self.passwordField.mas_bottom).offset(60);
        make.height.equalTo(@45);
    }];
    
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
    self.usernameField.font = [UIFont systemFontOfSize:14];
    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
                                                                                            NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
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
    
    self.passwordField = [[MyTextField alloc] init];
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.textColor = [UIColor blackColor];
    self.passwordField.font = [UIFont systemFontOfSize:14];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
                                                                                                                    NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
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
    
    self.forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forgetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.forgetPwdButton setTitleColor:RGB(0xFD8529, 1) forState:UIControlStateNormal];
    self.forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.forgetPwdButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    self.forgetPwdButton.layer.borderWidth = 0;
    [self.containView addSubview:self.forgetPwdButton];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundColor:RGB(0xFD8529, 1)];
    self.loginButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.loginButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.loginButton];
    
    //[self.usernameField addTarget:self action:@selector(changePhoneIcon) forControlEvents:UIControlEventEditingDidBegin];
    [self.usernameField addTarget:self action:@selector(goPassword) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[self.passwordField addTarget:self action:@selector(changePwdIcon) forControlEvents:UIControlEventEditingDidBegin];
    [self.passwordField addTarget:self action:@selector(login) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.forgetPwdButton addTarget:self action:@selector(goResetPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - Private Methods

-(void)beginLogin{
    self.isLogining = YES;
    
    self.usernameField.enabled = NO;
    self.passwordField.enabled = NO;
}

-(void)endLogin{
    self.usernameField.enabled = YES;
    self.passwordField.enabled = YES;
    
    self.isLogining = NO;
}

-(void)login{
    if (!self.isLogining) {
        //NSString *password = [self.passwordField.text MD5];
        [[DataManager manager] UserLoginOrRegisteWithUserphone:self.usernameField.text password:self.passwordField.text op_type:@"1" success:^(UserModel *user) {
            [DataManager manager].user = user;
            [self endLogin];
            [self connectToRCIM];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSString *reasonString;
            
            if (error.code < 700) {
                reasonString = @"请检查网络状态";
            } else {
                reasonString = @"请检查用户名或密码";
            }
            UIAlertController *alterLgnFailControl = [UIAlertController alertControllerWithTitle:@"登录失败" message:reasonString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *configureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self endLogin];
            }];
            [alterLgnFailControl addAction:configureAction];
            [self presentViewController:alterLgnFailControl animated:YES completion:nil];
            
        }];

    }
}
#pragma mark - 用户登录后，请求token，用token连接融云服务器
- (void)connectToRCIM
{
    NSString *urlStr = @"http://appv2.myrichang.com/Home/Message/getToken";
    NetWorkingRequestType type = POST;
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSString *usr_pic = [userDefaults objectForKey:@"userPic"];
    NSString *usr_name = [userDefaults objectForKey:@"userName"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",usr_name, @"usr_name",usr_pic, @"usr_pic",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSNumber *code = [dict valueForKey:@"code"];
        if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:200]])//msg = 获取成功
        {
            
            NSString *token = [dict valueForKey:@"token"];
            [userDefaults setObject:token forKey:@"token"];
            static dispatch_once_t pred;
            dispatch_once(&pred, ^{
                
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                } error:^(RCConnectErrorCode status) {
                    
                } tokenIncorrect:^{
                    
                }];
            });
        }else//msg = 获取失败
        {
            ;
        }
                
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];

        
}
-(void)goPassword{
    [self.passwordField becomeFirstResponder];
}

-(void)goResetPwd{
    ResetPasswordViewController *resetViewController = [[ResetPasswordViewController alloc]init];
    [self.navigationController pushViewController:resetViewController animated:YES];
}

- (void)logBackToMyInfoViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)turnToRegisteViewController{
    RegisteViewController *registeViewController = [[RegisteViewController alloc]init];
    [self.navigationController pushViewController:registeViewController animated:YES];
}

/**
 *  计算字符串的长度
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

@end
