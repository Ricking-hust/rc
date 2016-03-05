//
//  CZScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZScheduleViewController.h"
#import "Masonry.h"
#import "CZAddScheduleViewController.h"
#import "CZDateView.h"
#import "CZScheduleInfoView.h"
#include <sys/sysctl.h>
typedef NS_ENUM(NSInteger, CurrentDevice)
{
    IPhone5     = 0,    //4寸    568 X 320
    IPhone6     = 1,    //4.7寸  667 X 375
    Iphone6Plus = 2     //5.5寸  736 X 414
};
@interface CZScheduleViewController ()
@property (nonatomic, assign) CurrentDevice device;
@end

@implementation CZScheduleViewController

#pragma mark - 懒加载顶部imgview
- (NSArray *)array
{
    if (!_array)
    {
        _array = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    }
    return _array;
}
- (CZScheduleInfoView *)scInfoView
{
    if (!_scInfoView)
    {
        _scInfoView = [[CZScheduleInfoView alloc]init];
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewInfo:)];
        [_scInfoView addGestureRecognizer:click];
        [self.view addSubview:_scInfoView];

        UIImage *image = [UIImage imageNamed:@"bg_background1"];
        _scInfoView.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
        _scInfoView.layer.backgroundColor = [UIColor clearColor].CGColor;
        NSLog(@"");
        [_scInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rigthScrollView.mas_centerY);
            make.centerX.equalTo(self.rigthScrollView.mas_centerX);
            make.width.mas_equalTo(image.size.width);
            make.height.mas_equalTo(image.size.height);
        }];
    }
    return _scInfoView;
}
- (UIImageView *)timeLine
{
    if (!_timeLine)
    {
        _timeLine = [[UIImageView alloc]init];
        _timeLine.image = [UIImage imageNamed:@"more"];
        [self.view addSubview:_timeLine];
        [_timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(28);
            make.top.equalTo(self.view.mas_top).offset(64);
            make.size.mas_equalTo(_timeLine.image.size);
        }];
    }
    return _timeLine;
}
- (UIScrollView *)leftScrollView
{
    if (!_leftScrollView)
    {
        _leftScrollView = [[UIScrollView alloc]init];
        _leftScrollView.scrollEnabled = NO;
        [self.view addSubview:_leftScrollView];
        [_leftScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64+35);
            make.left.equalTo(self.view.mas_left);
            make.height.mas_equalTo(self.view.frame.size.height - 64 - 35-49);
            make.width.mas_equalTo(75);
        }];
    }
    return _leftScrollView;
}
- (UIScrollView *)rigthScrollView
{
    if (!_rigthScrollView)
    {
        _rigthScrollView = [[UIScrollView alloc]init];
        _rigthScrollView.delegate = self;
        [self.view addSubview:_rigthScrollView];
        [_rigthScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftScrollView.mas_top);
            make.left.equalTo(self.leftScrollView.mas_right);
            make.height.mas_equalTo(self.view.frame.size.height - 64 - 35-49);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _rigthScrollView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.device = [self currentDeviceSize];
    NSLog(@"test data %f",self.timeLine.frame.size.width);
    self.rigthScrollView.contentSize = CGSizeMake(0, 1000);
    [self displaySchedule];
    NSLog(@"%@",self.scInfoView);

}
- (void)displaySchedule
{

    CGFloat padding;
    if (self.device == IPhone5)
    {
        //根据个数创建point和point的上线和下线
        padding = 84;
        [self createTimePoint:padding];
    }else if (self.device == IPhone6)
    {
        
    }else
    {
        padding = 84;
        [self createTimePoint:padding];
    }

}
- (void)createTimePoint:(CGFloat)padding
{
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    for (int i = 0; i < self.array.count; i++)
    {
        UIView *point = [[UIView alloc]init];
        point.backgroundColor = color;
        point.layer.cornerRadius = 7;
        point.tag = (i+1)*10;
        UIView *upLine = [[UIView alloc]init];
        upLine.backgroundColor = color;
        upLine.tag = (i+1)*10+1;
        UIView *downLine = [[UIView alloc]init];
        downLine.backgroundColor = color;
        downLine.tag = (i+1)*10 + 2;
        
        [self.leftScrollView addSubview:point];
        [self.leftScrollView addSubview:upLine];
        [self.leftScrollView addSubview:downLine];
        CGFloat upLineTopPadding = (padding + 14)*i + 10 *i;
        CGFloat downLineTopPadding = (padding  + 14 ) * (i+1) + 10*i;
        [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftScrollView.mas_top).offset(upLineTopPadding);
            make.left.equalTo(self.leftScrollView.mas_left).offset(62);
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(padding);
        }];
        [point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(upLine.mas_bottom);
            make.left.equalTo(upLine.mas_left).offset(-6);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(point.mas_bottom);
            make.left.equalTo(upLine.mas_left);
            make.width.equalTo(upLine.mas_width);
            if (i == self.array.count - 1)
            {
                make.height.mas_equalTo(80);
            }else
            {
                make.height.mas_equalTo(10);
            }
        }];
        CZDateView *dateView = [[CZDateView alloc]init];
        [self.leftScrollView addSubview:dateView];
        [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(point.mas_left).offset(-5);
            make.top.equalTo(point.mas_top).offset(-10);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(40);
        }];
        dateView.month.text = @"12.29";
        dateView.week.text = @"星期一";
        [dateView addSubViewConstraint];
    }
    

}
- (void)didViewInfo:(UITapGestureRecognizer *)clickGesture
{
    NSLog(@"click");
}
- (void)test
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor redColor];
    [self.leftScrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftScrollView.mas_top);
        make.left.equalTo(self.leftScrollView.mas_left).offset(62);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(self.view.frame.size.height - 64-35-49);
    }];
    UIView *p1 = [[UIView alloc]init];
    p1.layer.cornerRadius = 7;
    p1.backgroundColor = [UIColor redColor];
    [self.leftScrollView addSubview:p1];
    UIView *p2 = [[UIView alloc]init];
        p2.backgroundColor = [UIColor redColor];
        p2.layer.cornerRadius = 7;
    [self.leftScrollView addSubview:p2];
    UIView *p3 = [[UIView alloc]init];
        p3.backgroundColor = [UIColor redColor];
        p3.layer.cornerRadius = 7;
    [self.leftScrollView addSubview:p3];
    
    UIView *p4 = [[UIView alloc]init];
    p4.backgroundColor = [UIColor redColor];
    p4.layer.cornerRadius = 7;
    [self.leftScrollView addSubview:p4];
    
    [p1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftScrollView.mas_top).offset(84);
        make.left.equalTo(self.leftScrollView.mas_left).offset(55);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    [p2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(p1.mas_top).offset(84);
        make.left.equalTo(self.leftScrollView.mas_left).offset(55);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];

    
    [p3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(p2.mas_top).offset(84);
        make.left.equalTo(self.leftScrollView.mas_left).offset(55);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];

    [p4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(p3.mas_top).offset(84);
        make.left.equalTo(self.leftScrollView.mas_left).offset(55);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    self.leftScrollView.contentSize = CGSizeMake(0, 420+84*4);
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(100, 300, 40, 40)];
    contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [contentView addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addSchedule:(id)sender
{
    CZAddScheduleViewController *addSchedule = [[CZAddScheduleViewController alloc]init];
    [self.navigationController pushViewController:addSchedule animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.leftScrollView.contentOffsetY = scrollView.contentOffset.y;
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

@end
