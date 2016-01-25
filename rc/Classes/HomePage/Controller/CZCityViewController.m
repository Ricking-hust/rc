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
#include <sys/sysctl.h>

@interface CZCityViewController ()

@end

@implementation CZCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCityView];
}

- (void)createCityView
{
    NSString *str;
    UIImage *img;
    CGFloat top = 200/2;
    CGFloat left = 58/2;
    CGFloat paddingW = 76/2;
    CGFloat paddingH = 70/2;
    CGSize size = CGSizeMake(80, 110);
    
    //city -- 北京
    CZCityView *beijing = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",1];
    img = [UIImage imageNamed:str];
    beijing.locationImage.image = [UIImage imageNamed:@"location"];
    [beijing.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    [beijing.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    beijing.cityNameLabel.text = @"北京";
    [self.view addSubview:beijing];

    
    //city -- 广州
    CZCityView *gangzhou = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",2];
    img = [UIImage imageNamed:str];
    gangzhou.locationImage.image = [UIImage imageNamed:@"location"];
    [gangzhou.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    [gangzhou.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    gangzhou.cityNameLabel.text = @"广州";
    [self.view addSubview:gangzhou];

    
    //city -- 上海
    CZCityView *shanghai = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",3];
    img = [UIImage imageNamed:str];
    shanghai.locationImage.image = [UIImage imageNamed:@"location"];
    [shanghai.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    [shanghai.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    shanghai.cityNameLabel.text = @"上海";
    [self.view addSubview:shanghai];

    
    //city -- 武汉
    CZCityView *wuhan = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",4];
    img = [UIImage imageNamed:str];
    wuhan.locationImage.image = [UIImage imageNamed:@"location"];
    [wuhan.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    [wuhan.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    wuhan.cityNameLabel.text = @"武汉";
    [self.view addSubview:wuhan];

    if ([[self getCurrentDeviceModel:self]isEqualToString:@"iPhone 4"] ||[[self getCurrentDeviceModel:self] isEqualToString:@"iPhone 5"] || [[self getCurrentDeviceModel:self]isEqualToString:@"iPhone Simulator"])
    {
        [beijing mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(left - 15);
            make.top.equalTo(self.view.mas_top).with.offset(top);
            make.size.mas_equalTo(size);
        }];
        [gangzhou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(beijing.mas_right).with.offset(paddingW - 15);
            make.top.equalTo(beijing.mas_top);
            make.size.mas_equalTo(size);
        }];
        [shanghai mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gangzhou.mas_right).with.offset(paddingW - 15);
            make.top.equalTo(beijing.mas_top);
            make.size.mas_equalTo(size);
        }];
        [wuhan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(left - 15);
            make.top.equalTo(beijing.mas_bottom).with.offset(paddingH);
            make.size.mas_equalTo(size);
        }];
    }else
    {
        [beijing mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(left);
            make.top.equalTo(self.view.mas_top).with.offset(top);
            make.size.mas_equalTo(size);
        }];
        [gangzhou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(beijing.mas_right).with.offset(paddingW);
            make.top.equalTo(beijing.mas_top);
            make.size.mas_equalTo(size);
        }];
        [shanghai mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gangzhou.mas_right).with.offset(paddingW);
            make.top.equalTo(beijing.mas_top);
            make.size.mas_equalTo(size);
        }];
        [wuhan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(left);
            make.top.equalTo(beijing.mas_bottom).with.offset(paddingH);
            make.size.mas_equalTo(size);
        }];

    }
}

//获得设备型号
- (NSString *)getCurrentDeviceModel:(UIViewController *)controller
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
- (IBAction)cancelSelect:(id)sender {
//    NSString *strModel  = [UIDevice currentDevice].model;
//    NSLog(@"%@", strModel);
    NSString *str = [self getCurrentDeviceModel:self];
    NSLog(@"%@", str);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
