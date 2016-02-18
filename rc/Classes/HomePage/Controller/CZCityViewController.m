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
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    [self createCityView];

}

- (void)createCityView
{
    NSString *str;
    UIImage *img;

    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.left.and.right.bottom.equalTo(self.view);
    }];
    //city -- 北京
    _beijing = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",1];
    img = [UIImage imageNamed:str];
    _beijing.locationImage.image = [UIImage imageNamed:@"location"];
    [_beijing.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    //[_beijing.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.beijing.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
    _beijing.cityNameLabel.text = @"北京";
    [_beijing setConstraints];
    [_bgView addSubview:_beijing];
    
    //city -- 广州
    _guangzhou = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",2];
    img = [UIImage imageNamed:str];
    _guangzhou.locationImage.image = [UIImage imageNamed:@"location"];
    [_guangzhou.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    //[_guangzhou.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    _guangzhou.cityNameLabel.text = @"广州";
    [_guangzhou setConstraints];
    [_bgView addSubview:_guangzhou];
    [self.guangzhou.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];

    //city -- 上海
    _shanghai = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",3];
    img = [UIImage imageNamed:str];
    _shanghai.locationImage.image = [UIImage imageNamed:@"location"];
    [_shanghai.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    //[_shanghai.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    _shanghai.cityNameLabel.text = @"上海";
    [_shanghai setConstraints];
    [_bgView addSubview:_shanghai];
    [self.shanghai.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];
    
    //city -- 武汉
    _wuhan = [CZCityView cityView];
    str = [NSString stringWithFormat:@"city_%d",4];
    img = [UIImage imageNamed:str];
    _wuhan.locationImage.image = [UIImage imageNamed:@"location"];
    [_wuhan.cityBtn setBackgroundImage:img forState:UIControlStateNormal];
    //[_wuhan.cityBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    _wuhan.cityNameLabel.text = @"武汉";
    [_wuhan setConstraints];
    [_bgView addSubview:_wuhan];
    [self.wuhan.cityBtn addTarget:self action:@selector(onClickCity:) forControlEvents:UIControlEventTouchUpInside];

    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGFloat leftPaddig = 58.0/2.0;
    CGFloat topPadding = 56.0/2.0 + 64;
    CGFloat paddingX = screenSize.width * 0.10;
    CGFloat paddingY = screenSize.width * 0.09;
    CGFloat cityViewW = screenSize.width * 0.21;
    CGFloat cityViewH = cityViewW + cityViewW * 0.5;
    CGSize size = CGSizeMake(cityViewW, cityViewH);
    
    [_beijing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView.mas_left).with.offset(leftPaddig);
        make.top.equalTo(_bgView.mas_top).with.offset(topPadding-64);
        make.size.mas_equalTo(size);
    }];
    [_guangzhou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beijing.mas_right).with.offset(paddingX);
        make.top.equalTo(_beijing.mas_top);
        make.size.mas_equalTo(size);
    }];
    [_shanghai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_guangzhou.mas_right).with.offset(paddingX);
        make.top.equalTo(_beijing.mas_top);
        make.size.mas_equalTo(size);
    }];
    [_wuhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beijing.mas_left);
        make.top.equalTo(_beijing.mas_bottom).with.offset(paddingY);
        make.size.mas_equalTo(size);
    }];
}
#pragma mark - 左侧取消按钮点击事件
- (IBAction)cancelSelect:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 城市选择按钮点击事件
- (void)onClickCity:(UIButton *)btn
{
#pragma mark - 测试语句
    UILabel *label = [btn.superview viewWithTag:10];
    NSLog(@"%@",label.text);
}


@end
