//
//  LoginViewController.m
//  rc
//
//  Created by 余笃 on 16/3/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "LoginViewController.h"
#import "MyTextField.h"
#import "RegisteViewController.h"
#import "CZHomeViewController.h"

static CGFloat const kContainViewYNormal = 70.0;
static CGFloat const kContainViewYEditing = 60.0;

@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UILabel     *logoLabel;
//@property (nonatomic, strong) UILabel     *descriptionLabel;

@property (nonatomic, strong) MyTextField *usernameField;
@property (nonatomic, strong) MyTextField *passwordField;
@property (nonatomic,strong) UIImageView *leftUsernameView;
@property (nonatomic,strong) UIImageView *leftPasswdView;
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
    
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,400};
    self.logoLabel.center = (CGPoint){kScreenWidth/2,80};
    //self.descriptionLabel.frame = (CGRect){20, 60, kScreenWidth - 20,70};
    self.usernameField.frame = (CGRect){50, 214, kScreenWidth - 100, 30};
    self.passwordField.frame = (CGRect){50, 254, kScreenWidth - 100, 30};
    self.loginButton.center = (CGPoint){kScreenWidth/2, 350};
    
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
    
//    self.descriptionLabel = [[UILabel alloc] init];
//    self.descriptionLabel.text = @"打造有知阶层的公众生活";
//    self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
//    self.descriptionLabel.textColor = [UIColor blackColor];
//    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.descriptionLabel.numberOfLines = 0;
//    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
//    [self.containView addSubview:self.descriptionLabel];
}

- (void)configureTextField{
    
    self.usernameField = [[MyTextField alloc] init];
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    self.usernameField.textColor = [UIColor blackColor];
    self.usernameField.font = [UIFont systemFontOfSize:18];
    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.836 alpha:1.000],
                                                                                            NSFontAttributeName:[UIFont italicSystemFontOfSize:18]}];
    self.usernameField.keyboardType = UIKeyboardTypeEmailAddress;
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
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundColor:RGB(0xFD8529, 1)];
    self.loginButton.viewSize = CGSizeMake(300, 45);
    self.loginButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.loginButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.loginButton];
    
    [self.usernameField addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventEditingDidBegin];
    [self.usernameField addTarget:self action:@selector(goPassword) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordField addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventEditingDidBegin];
    [self.passwordField addTarget:self action:@selector(login) forControlEvents:UIControlEventEditingDidEndOnExit];
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
        [self hideKeyboard];
        
        [[DataManager manager] UserLoginOrRegisteWithUserphone:self.usernameField.text password:self.passwordField.text op_type:@"1" success:^(UserModel *user) {
            [DataManager manager].user = user;
            [self endLogin];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSString *reasonString;
            
            if (error.code < 700) {
                reasonString = @"请检查网络状态";
            } else {
                reasonString = @"请检查用户名或密码";
            }
        }];

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
            self.loginButton.y      -= 14;
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
            self.loginButton.y      += 14;
        } completion:^(BOOL finished) {
        }];
    }
    
}

-(void)goPassword{
    [self.passwordField becomeFirstResponder];
}

- (void)logBackToMyInfoViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)turnToRegisteViewController{
    RegisteViewController *registeViewController = [[RegisteViewController alloc]init];
    [self.navigationController pushViewController:registeViewController animated:YES];
}

@end
