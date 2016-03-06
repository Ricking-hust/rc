

//
//  CZScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZScheduleViewController.h"
#import "Masonry.h"
#import "CZTimeTableViewDelegate.h"
#import "CZScheduleTableViewDelegate.h"
#include <sys/sysctl.h>
@interface CZScheduleViewController ()
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation CZScheduleViewController

- (CurrentDevice)device
{
    if (!_device)
    {
        _device = [self currentDeviceSize];
    }
    return _device;
}
- (NSMutableArray *)array
{
    if (!_array)
    {
        _array = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    return _array;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addSubViews];
    [self displayTimeNode];
    
}
- (void)displayTimeNode
{
    self.timeDelegate.array = self.array;
    self.timeDelegate.device = self.device;
}
- (void)addSubViews
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.timeNodeTableView.backgroundColor = [UIColor clearColor];
    self.scTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.timeNodeTableView];
    [self.view addSubview:self.scTableView];
    self.timeNodeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.timeNodeTableView.showsVerticalScrollIndicator = NO;
    self.scTableView.showsVerticalScrollIndicator = NO;

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(28);
        make.size.mas_equalTo(self.imgView.image.size);
    }];
    [self.timeNodeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(kScreenHeight - 64 - self.imgView.image.size.height - 49);
    }];
    [self.scTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.timeNodeTableView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScreenHeight - 64 - self.imgView.image.size.height - 49 + 35);
    }];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.timeNodeTableView = [[UITableView alloc]init];
        self.scTableView = [[UITableView alloc]init];
        self.imgView = [[UIImageView alloc]init];
        self.imgView.image = [UIImage imageNamed:@"more"];
        self.timeDelegate = [[CZTimeTableViewDelegate alloc]init];
        self.timeNodeTableView.delegate = self.timeDelegate;
        self.timeNodeTableView.dataSource = self.timeDelegate;
        self.scDelegate = [[CZScheduleTableViewDelegate alloc]init];
        self.scTableView.delegate = self.scDelegate;
        self.scTableView.dataSource = self.scDelegate;
    }
    return self;
}
- (IBAction)addSchedule:(id)sender
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
