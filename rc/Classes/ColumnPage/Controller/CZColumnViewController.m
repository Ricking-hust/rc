//
//  SecondViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/17.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "CZColumnViewController.h"
#import "CZToolButton.h"
#import "Masonry.h"
#import "CZAcitivityModelOfColumn.h"
#import "CZActivityOfColumn.h"
#import "CZTagViewController.h"
#include <sys/sysctl.h>

@interface CZColumnViewController ()

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *toolScrollView;

#pragma mark - 测试数据
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *activities;
@end

@implementation CZColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *temp = [[UIView alloc]init];
    [self.view addSubview:temp];
    self.activities = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
#pragma mark - 测试数据
    [self getData];
    
    //创建子控件
    [self createSubView];
    

}
#pragma mark - 懒加载，创建主题色
- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        _selectedColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:3.0/255.0 alpha:1.0];
    }
    return _selectedColor;
}
#pragma mark - 懒加载，创建toolScrollView
- (UIScrollView *)toolScrollView
{
    if (!_toolScrollView) {
         CGRect rect = [[UIScreen mainScreen]bounds];
        _toolScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 68, rect.size.width, 35)];
        _toolScrollView.backgroundColor = [UIColor whiteColor];
        //设置分布滚动，去掉水平和垂直滚动条
        _toolScrollView.showsHorizontalScrollIndicator = NO;
        _toolScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_toolScrollView ];
    }
    return _toolScrollView;
}
#pragma mark - 懒加载，创建scrollView
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        //创建滚动条
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_scrollView];
        CGRect rect = [[UIScreen mainScreen]bounds];
        CGSize scrollSize = CGSizeMake(rect.size.width, rect.size.height - 103);
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(_toolScrollView.mas_bottom).with.offset(20/2);
            make.size.mas_equalTo(scrollSize);
        }];
#pragma mark - 测试语句
        //设置滚动条
        _scrollView.contentSize = CGSizeMake(0, scrollSize.height*2);
    }
    return _scrollView;
}

#pragma mark - 懒加载，测试数据
- (NSArray *)array
{
    if (!_array) {
        _array = [NSArray arrayWithObjects:@"创业", @"讲座", @"金融",@"设计",@"资讯",@"联网",@"设计",@"资讯",@"联网" ,nil];
    }
    return  _array;
}
#pragma mark - 创建子控件，显示数据
- (void) createSubView
{
    //创建工具条按钮
    [self showToolButtons];

    //将活动添加到滚动条中
    [self showActivityView];

}
//创建工具条按钮
- (void)showToolButtons
{
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat leftPadding = 10;
    CGFloat topPadding = (self.toolScrollView.frame.size.height - 30)/2;
    CGFloat padding = rect.size.width * 0.07;
    
    //设置工具条的水平滚动范围
    CGFloat horizontalContentSize = self.array.count*30 + (self.array.count - 1)*padding + leftPadding + 10;
    self.toolScrollView.contentSize = CGSizeMake(horizontalContentSize, 0);
    for (int i = 0; i<self.array.count; i++)
    {
        CZToolButton *btn = [[CZToolButton alloc]initWithTittle:self.array[i]];
        [btn setFrame:CGRectMake(0, 5, 30, 30)];
        CGFloat ofButtonPadding = i * (padding+btn.frame.size.width) + leftPadding;
        [btn addTarget:self action:@selector(onClickTooBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolScrollView addSubview:btn];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolScrollView.mas_left).with.offset(ofButtonPadding);
            make.top.equalTo(self.toolScrollView.mas_top).with.offset(topPadding);
        }];

    }
}
#pragma mark - 模拟取得数据
- (void)getData
{
    CZAcitivityModelOfColumn *activity = [CZAcitivityModelOfColumn activity];
    [self.activities addObject:activity];
    
    CZAcitivityModelOfColumn *activity2 = [CZAcitivityModelOfColumn activity];
   [self.activities addObject:activity2];
    
    CZAcitivityModelOfColumn *activity3 = [CZAcitivityModelOfColumn activity];
    [self.activities addObject:activity3];
    
}
- (void)onClickTooBtn:(UIButton *)btn
{
    NSLog(@"%@", btn.titleLabel.text);
}

- (void)onClickAcView:(UIView *)view
{
    CZTagViewController *tagViewController = [[CZTagViewController alloc]init];
    tagViewController.title = @"专栏";
    [self.navigationController pushViewController:tagViewController animated:YES];
}

#pragma mark -
- (void) showActivityView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickAcView:)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickAcView:)];
    CZActivityOfColumn *acView = [CZActivityOfColumn activityView];
    acView.activity = self.activities[0];
    [self.scrollView addSubview:acView];
    [acView addGestureRecognizer:tapGesture];

    CZActivityOfColumn *acView2 = [CZActivityOfColumn activityView];
    acView2.activity = self.activities[0];
    [self.scrollView addSubview:acView2];
    [acView2 addGestureRecognizer:tapGesture2];
    
    CZActivityOfColumn *acView3 = [CZActivityOfColumn activityView];
    acView3.activity = self.activities[0];
    [self.scrollView addSubview:acView3];
    
    //CGFloat letfPadding = 15;
    CGFloat padding;
    CGFloat topPadding;
    //根据设备调整布局
    if ([[self getCurrentDeviceModel]isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel]isEqualToString:@"iPhone 5"] )
    {//设备为iphone4与iphone 5时
        padding = 10;
    }else if([[self getCurrentDeviceModel]isEqualToString:@"iPhone 6"] ||
             [[self getCurrentDeviceModel]isEqualToString:@"iPhone Simulator"])
    {//设备为iphone 6时
        padding = 15;
        topPadding = 10;
    }else
    {//设备为iphone 6 plus时
        padding = 20;
    }
    
    [acView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.scrollView.mas_left).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(acView.width, acView.heigth));
    }];
    
    [acView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(acView.mas_top);
        make.left.equalTo(acView.mas_right).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(acView2.width, acView2.heigth));
    }];
    [acView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(acView.mas_bottom).with.offset(topPadding);
        make.left.equalTo(self.scrollView).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(acView3.width, acView3.heigth));
    }];

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

////设置界面顶部的工具栏
//- (void)createToolView
//{
////    //添加四个边阴影
////    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
////    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){200/255 ,199/255,204/255,0.8});
////    self.toolView.layer.shadowColor = color;//阴影颜色
////    self.toolView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
////    self.toolView.layer.shadowOpacity = 0.7;//不透明度
////    self.toolView.layer.shadowRadius = 5.0;//半径
//    
//    self.all = [CZToolView toolView:@"全部"];
//    [self.all.btn setTag:0];
//    [self.all.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.all.btn.selected = YES;
//    self.all.btn.tintColor = self.selectedColor;
//    self.all.segmentView.hidden = NO;
//    [self.toolView addSubview:self.all];
//    
//    self.finance = [CZToolView toolView:@"金融"];
//    [self.finance.btn setTag:1];
//    [self.finance.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.finance];
//    
//    self.media = [CZToolView toolView:@"传媒"];
//    [self.media .btn setTag:2];
//    [self.media .btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.media ];
//    
//    
//    self.bStarup = [CZToolView toolView:@"创业"];
//    [self.bStarup.btn setTag:3];
//    [self.bStarup.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.bStarup];
//    
//    self.net = [CZToolView toolView:@"互联网"];
//    [self.net.btn setTag:4];
//    [self.net.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.net];
//    
//    self.design = [CZToolView toolView:@"设计"];
//    [self.design.btn setTag:5];
//    [self.design.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.design];
//    
//    self.more = [CZToolView toolView:@""];
//    [self.more.btn setTag:6];
//    [self.more.btn setImage:[UIImage imageNamed:@"moreTag"] forState:UIControlStateNormal];
//    [self.more .btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.more ];
//}
//- (void)addConstraints
//{
//    CGFloat padding;
//    if ([[self getCurrentDeviceModel]isEqualToString:@"iPhone 4"] ||
//        [[self getCurrentDeviceModel]isEqualToString:@"iPhone 5"] )
//    {
//        padding = 45;
//    }else if ([[self getCurrentDeviceModel]isEqualToString:@"iPhone 6"] ||
//              [[self getCurrentDeviceModel]isEqualToString:@"iPhone Simulator"])
//    {
//        padding = 52;
//    }else
//    {
//        padding = 60;
//    }
//
//    [self.all mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.toolView.mas_top);
//        make.left.equalTo(self.toolView.mas_left).with.offset(10);
//    }];
//    
//    [self.finance mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.all.mas_right).with.offset(padding);
//    }];
//    [self.media mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.finance.mas_right).with.offset(padding);
//    }];
//    [self.bStarup mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.media.mas_right).with.offset(padding);
//    }];
//    [self.design mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.bStarup.mas_right).with.offset(padding);
//    }];
//    [self.net mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.design.mas_right).with.offset(padding - 10);
//        //make.size.mas_equalTo(CGSizeMake(45, 30));
//    }];
//    [self.more mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.net.mas_right).with.offset(padding - 10);
//    }];
//
//}
//- (void)onClick:(UIButton *)btn
//{
//    if (btn.selected == YES) {
//        NSLog(@"selected");
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
