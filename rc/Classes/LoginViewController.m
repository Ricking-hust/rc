//
//  LoginViewController.m
//  rc
//
//  Created by 余笃 on 16/3/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "LoginViewController.h"

static CGFloat const kContainViewYNormal = 120.0;

@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton    *closeButton;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UILabel     *logoLabel;
@property (nonatomic, strong) UILabel     *descriptionLabel;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton    *loginButton;
@property (nonatomic,strong) UIButton *registeButton;

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


-(void)loadView{
    [super loadView];
    
    [self configureViews];
    [self configureTextField];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Layout

-(void)viewWillLayoutSubviews{
    
    self.backgroundImageView.frame = self.view.frame;
    self.closeButton.frame = (CGRect){10,20,44,44};
    
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,400};
    self.logoLabel.center = (CGPoint){kScreenWidth/2,30};
    self.descriptionLabel.frame = (CGRect){20, 60, kScreenWidth - 20,70};
    self.usernameField.frame = (CGRect){60, 150, kScreenWidth - 120, 30};
    self.passwordField.frame = (CGRect){60, 190, kScreenWidth - 120, 30};
    self.loginButton.center = (CGPoint){kScreenWidth/2, 270};
    self.registeButton.center = (CGPoint){kScreenWidth/2,330};
    
}

#pragma mark - Configure Views

-(void)configureViews{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568_blurred"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.closeButton setTintColor:[UIColor whiteColor]];
    self.closeButton.alpha = 0.5;
    [self.view addSubview:self.closeButton];
    
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];
    
    self.logoLabel = [[UILabel alloc] init];
    self.logoLabel.text = @"日常";
    self.logoLabel.font = [UIFont fontWithName:@"Kailasa" size:36];
    self.logoLabel.textColor = [UIColor blackColor];
    [self.logoLabel sizeToFit];
    [self.containView addSubview:self.logoLabel];
    
    self.descriptionLabel = [[UILabel alloc] init];
    //    self.descriptionLabel.text = @"A community of start-ups, designers, developers and creative people.";
    self.descriptionLabel.text = @"打造有知阶层的公众生活";
    self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    self.descriptionLabel.textColor = [UIColor blackColor];
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.containView addSubview:self.descriptionLabel];
}

- (void)configureTextField{
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    self.usernameField.textColor = [UIColor blackColor];
    self.usernameField.font = [UIFont systemFontOfSize:18];
    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.836 alpha:1.000],
                                                                                            NSFontAttributeName:[UIFont italicSystemFontOfSize:18]}];
    self.usernameField.keyboardType = UIKeyboardTypeEmailAddress;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.containView addSubview:self.usernameField];
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.textColor = [UIColor blackColor];
    self.passwordField.font = [UIFont systemFontOfSize:18];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.836 alpha:1.000],
                                                                                                                    NSFontAttributeName:[UIFont italicSystemFontOfSize:18]}];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordField.returnKeyType = UIReturnKeyGo;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.containView addSubview:self.passwordField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    self.loginButton.viewSize = CGSizeMake(180, 44);
    self.loginButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.loginButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.loginButton];
    
    self.registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registeButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.registeButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    self.registeButton.viewSize = CGSizeMake(180, 44);
    self.registeButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.registeButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.registeButton];

}

@end
