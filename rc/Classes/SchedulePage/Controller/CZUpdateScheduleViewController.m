//
//  CZUpdateScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZUpdateScheduleViewController.h"

@interface CZUpdateScheduleViewController ()
@property (strong, nonatomic) UIView *themeView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIImageView *tagimageView;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UIButton *moreTagButton;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UITextField *contentTextField;
@property (strong, nonatomic) UILabel *limitedLabel;

@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *timeInfo;
@property (strong, nonatomic) UIButton *moreTimeButton;

@property (strong, nonatomic) UIView *remindView;
@property (strong, nonatomic) UILabel *remindLabel;
@property (strong, nonatomic) UILabel *remindInfo;
@property (strong, nonatomic) UIButton *moreRemindButton;


@end

@implementation CZUpdateScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的左右按钮
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(OK)];
    [self.navigationItem setRightBarButtonItem:rigthButton];
    
    self.title = @"修改行程";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)OK
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
