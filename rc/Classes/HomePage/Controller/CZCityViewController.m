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
    [self createCityView];
}
- (void)setNavigation
{
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(didCancelSelection)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    UIBarButtonItem *rigthButton =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectCity)];
    [self.navigationItem setRightBarButtonItem:rigthButton];
    
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
//确定城市选择
- (void)didSelectCity
{
    long int count = self.navigationController.viewControllers.count;
    CZHomeViewController *homePage = (CZHomeViewController *)self.navigationController.viewControllers[count - 2];
    homePage.city = self.city;
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
        self.beijing = [CZCityView cityView];
        self.shanghai = [CZCityView cityView];
        self.guangzhou = [CZCityView cityView];
        self.wuhan = [CZCityView cityView];
        self.device = [self currentDeviceSize];
    }
    [self addSubViewToSuperView];
    return self;
}
- (void)addSubViewToSuperView
{
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.beijing];
    [self.bgView addSubview:self.shanghai];
    [self.bgView addSubview:self.guangzhou];
    [self.bgView addSubview:self.wuhan];
}
- (void)createCityView
{
    //创建赋值
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.left.and.right.bottom.equalTo(self.view);
    }];
    //布局
//    NSString *str;
//    UIImage *img;
//
//    _bgView = [[UIView alloc]init];
//    _bgView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_bgView];
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).with.offset(74);
//        make.left.and.right.bottom.equalTo(self.view);
//    }];
//    //city -- 北京
//    _beijing = [CZCityView cityView];
//    str = [NSString stringWithFormat:@"city_%d",1];
//    img = [UIImage imageNamed:str];
//    _beijing.locationImage.image = [UIImage imageNamed:@"location"];
//    [_beijing.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
//
//    [self.beijing.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
//    _beijing.cityNameLabel.text = @"北京";
//    [_beijing setConstraints];
//    [_bgView addSubview:_beijing];
//    
//    //city -- 广州
//    _guangzhou = [CZCityView cityView];
//    str = [NSString stringWithFormat:@"city_%d",2];
//    img = [UIImage imageNamed:str];
//    _guangzhou.locationImage.image = [UIImage imageNamed:@"location"];
//    [_guangzhou.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
//
//    _guangzhou.cityNameLabel.text = @"广州";
//    [_guangzhou setConstraints];
//    [_bgView addSubview:_guangzhou];
//    [self.guangzhou.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
//
//    //city -- 上海
//    _shanghai = [CZCityView cityView];
//    str = [NSString stringWithFormat:@"city_%d",3];
//    img = [UIImage imageNamed:str];
//    _shanghai.locationImage.image = [UIImage imageNamed:@"location"];
//    [_shanghai.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
//
//    _shanghai.cityNameLabel.text = @"上海";
//    [_shanghai setConstraints];
//    [_bgView addSubview:_shanghai];
//    [self.shanghai.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //city -- 武汉
//    _wuhan = [CZCityView cityView];
//    str = [NSString stringWithFormat:@"city_%d",4];
//    img = [UIImage imageNamed:str];
//    _wuhan.locationImage.image = [UIImage imageNamed:@"location"];
//    [_wuhan.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
//
//    _wuhan.cityNameLabel.text = @"武汉";
//    [_wuhan setConstraints];
//    [_bgView addSubview:_wuhan];
//    [self.wuhan.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
//
//    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
//    CGFloat leftPaddig = 58.0/2.0;
//    CGFloat topPadding = 56.0/2.0 + 64;
//    CGFloat paddingX = screenSize.width * 0.10;
//    CGFloat paddingY = screenSize.width * 0.09;
//    CGFloat cityViewW = screenSize.width * 0.21;
//    CGFloat cityViewH = cityViewW + cityViewW * 0.5;
//    CGSize size = CGSizeMake(cityViewW, cityViewH);
//    
//    [_beijing mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_bgView.mas_left).with.offset(leftPaddig);
//        make.top.equalTo(_bgView.mas_top).with.offset(topPadding-64);
//        make.size.mas_equalTo(size);
//    }];
//    [_guangzhou mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_beijing.mas_right).with.offset(paddingX);
//        make.top.equalTo(_beijing.mas_top);
//        make.size.mas_equalTo(size);
//    }];
//    [_shanghai mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_guangzhou.mas_right).with.offset(paddingX);
//        make.top.equalTo(_beijing.mas_top);
//        make.size.mas_equalTo(size);
//    }];
//    [_wuhan mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_beijing.mas_left);
//        make.top.equalTo(_beijing.mas_bottom).with.offset(paddingY);
//        make.size.mas_equalTo(size);
//    }];
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
