//
//  LoginViewController.m
//  rc
//
//  Created by 余笃 on 16/3/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "LoginViewController.h"

static CGFloat const kContainViewYNormal = 120.0;
static CGFloat const kContainViewYEditing = 60.0;

@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton    *closeButton;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UILabel     *logoLabel;
@property (nonatomic, strong) UILabel     *descriptionLabel;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
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


-(void)loadView{
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Layout

-(void)viewWillLayoutSubviews{
    
    self.backgroundImageView.frame = self.view.frame;
    self.closeButton.frame = (CGRect){10,20,44,44};
    
    self.containView.frame = (CGRect){0,kContainViewYNormal,[UIScreen mainScreen].bounds.size.width,300};
    
}

@end
