//
//  CZCityViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZCityViewController.h"
#import "Masonry.h"
#import "CZCityView.h"
#import "CZHomeViewController.h"
#include <sys/sysctl.h>

@interface CZCityViewController ()

@end

@implementation CZCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self setNavigation];
    [self addSubViewToSuperView];
}
- (void)setNavigation
{
    self.title = @"城市选择";
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(didCancelSelection)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
}
#pragma mark - 刷新数据
- (void)viewWillAppear:(BOOL)animated
{
    [self locateCity];
}
//取消城市选择直接返回上一个视图控制器
- (void)didCancelSelection
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 城市选择按钮点击事件
- (void)onClickCity:(UIButton *)btn
{
    UILabel *label = [btn.superview viewWithTag:10];
    if ([label.text isEqualToString:@"北京"])
    {
        UIImageView *locationImageView = [btn.superview viewWithTag:11];
        locationImageView.hidden = NO;
        self.wuhan.locationImage.hidden = YES;
        self.guangzhou.locationImage.hidden = YES;
        self.shanghai.locationImage.hidden = YES;
        self.city = Beijing;
    }else if ([label.text isEqualToString:@"广州"])
    {
        UIImageView *locationImageView = [btn.superview viewWithTag:11];
        locationImageView.hidden = NO;
        self.beijing.locationImage.hidden = YES;
        self.shanghai.locationImage.hidden = YES;
        self.wuhan.locationImage.hidden = YES;
        self.city = Guangzhou;
    }else if ([label.text isEqualToString:@"上海"])
    {
        UIImageView *locationImageView = [btn.superview viewWithTag:11];
        locationImageView.hidden = NO;
        self.beijing.locationImage.hidden = YES;
        self.guangzhou.locationImage.hidden = YES;
        self.wuhan.locationImage.hidden = YES;
        self.city = Shanghai;
    }else
    {
        UIImageView *locationImageView = [btn.superview viewWithTag:11];
        locationImageView.hidden = NO;
        self.beijing.locationImage.hidden = YES;
        self.guangzhou.locationImage.hidden = YES;
        self.shanghai.locationImage.hidden = YES;
        self.city = Wuhan;
    }
    long int count = self.navigationController.viewControllers.count;
    CZHomeViewController *homePage = (CZHomeViewController *)self.navigationController.viewControllers[count - 2];
    homePage.city = self.city;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)locateCity
{
    if (_city == Wuhan)
    {
        self.wuhan.locationImage.hidden = NO;
    }else if (_city == Shanghai)
    {
        self.shanghai.locationImage.hidden = NO;
    }else if (_city == Beijing)
    {
        self.beijing.locationImage.hidden = NO;
    }else
    {
        self.guangzhou.locationImage.hidden = NO;
    }
}

- (id)init
{
    if (self = [super init])
    {
        self.bgView = [[UIView alloc]init];
        self.beijing = [[CZCityView alloc]initName:@"北京" WithImageString:@"Beijing_Icon"];
        self.shanghai = [[CZCityView alloc]initName:@"上海" WithImageString:@"Shanghai_Icon"];
        self.guangzhou = [[CZCityView alloc]initName:@"广州" WithImageString:@"Guangzhou_Icon"];;
        self.wuhan = [[CZCityView alloc]initName:@"武汉" WithImageString:@"Wuhan_Icon"];;
        self.device = [self currentDeviceSize];
        [self.shanghai.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
        [self.guangzhou.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
        [self.wuhan.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
        [self.beijing.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)addSubViewToSuperView
{
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.beijing];
    [self.bgView addSubview:self.shanghai];
    [self.bgView addSubview:self.guangzhou];
    [self.bgView addSubview:self.wuhan];
    //创建赋值
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.left.and.right.bottom.equalTo(self.view);
    }];
    CGFloat wuhanH = self.wuhan.cityBtn.imageView.image.size.height + 18 + 11 +10;
    CGFloat padding = (kScreenWidth - 240)/4;
    [self.wuhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(padding);
        make.top.equalTo(self.bgView.mas_top).offset(28);
        make.height.mas_equalTo(wuhanH);
        make.width.mas_equalTo(80);
    }];
    [self.wuhan setConstraints];
    
    CGFloat beijingH = self.beijing.cityBtn.imageView.image.size.height + 18 + 11 +10;
    [self.beijing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wuhan.mas_right).offset(padding);
        make.top.equalTo(self.wuhan.mas_top);
        make.height.mas_equalTo(beijingH);
        make.width.mas_equalTo(80);
    }];
    [self.beijing setConstraints];
    
    CGFloat shanghaiH = self.beijing.cityBtn.imageView.image.size.height + 18 + 11 +10;
    [self.shanghai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beijing.mas_right).offset(padding);
        make.top.equalTo(self.wuhan.mas_top);
        make.height.mas_equalTo(shanghaiH);
        make.width.mas_equalTo(80);
    }];
    [self.shanghai setConstraints];
    
    CGFloat guangzhouH = self.beijing.cityBtn.imageView.image.size.height + 18 + 11 +10;
    [self.guangzhou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wuhan.mas_bottom).offset(35);
        make.left.equalTo(self.bgView.mas_left).offset(padding);
        make.height.mas_equalTo(guangzhouH);
        make.width.mas_equalTo(80);
    }];
    [self.guangzhou setConstraints];
}
//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"])
    {
        return IPhone6;
    }else
    {
        return Iphone6Plus;
    }
}
//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

#pragma mark - 左侧取消按钮点击事件
- (IBAction)cancelSelect:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}
@end
