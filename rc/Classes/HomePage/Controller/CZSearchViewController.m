//
//  CZSearchViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/28.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZSearchViewController.h"
#import "Masonry.h"
#include <sys/sysctl.h>

@interface CZSearchViewController ()
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIView *hotSearchView;
#pragma mark - 测试数据
@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation CZSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self addSearchBarConstraint];
    [self addHotSearchConstraint];

}
#pragma mark - 懒加载
- (NSMutableArray *)array
{
    if (!_array) {
        self.array = [[NSMutableArray alloc]initWithObjects:@"创业",@"互联网",@"金融",@"讲座",@"IT",@"Xcode", @"mac", nil];
    }
    return _array;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgView];
    }
    return _bgView;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"请输入搜索内容";
        
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_searchBar setTranslucent:YES];
        _searchBar.layer.masksToBounds = YES;
        
        _searchBar.layer.cornerRadius = 13.0;
        
        [_bgView addSubview:_searchBar];
    }
    return _searchBar;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_rightBtn];
        
    }
    return _rightBtn;
}
- (UIView *)hotSearchView
{
    if (!_hotSearchView) {
        _hotSearchView = [[UIView alloc]init];
        _hotSearchView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_hotSearchView];
    }
    return _hotSearchView;
}

#pragma mark - 搜索框约束
- (void)addSearchBarConstraint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat searchBarW = rect.size.width * 0.82;
    CGFloat searchBarH = 44;
    CGSize btnSize = CGSizeMake(30, 30);
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, 64));
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(0);
        make.top.equalTo(self.bgView.mas_top).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(searchBarW, searchBarH));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBar.mas_right).with.offset(10);
        make.top.equalTo(self.searchBar.mas_top).with.offset(8);
        make.size.mas_equalTo(btnSize);
    }];

    
    
}
#pragma mark - 点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}
#pragma mark - 热闹搜索约束
- (void) addHotSearchConstraint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat hotSearchH = rect.size.width * 0.54;
    [self.hotSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, hotSearchH));
    }];
    //图片
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"hotIcon"];
    CGSize imgSize = imgView.image.size;
    [self.hotSearchView addSubview:imgView];
    CGFloat imgViewTopPadding = (hotSearchH * 0.30 - imgSize.height)/2;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotSearchView.mas_left).with.offset(imgViewTopPadding);
        make.top.equalTo(self.hotSearchView.mas_top).with.offset(imgViewTopPadding);
        make.size.mas_equalTo(imgSize);
    }];
    
    //标签
    UILabel *label = [[UILabel alloc]init];
    label.text = @"热闹搜索";
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    [self.hotSearchView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_top);
        make.left.equalTo(imgView.mas_right).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    //分割线
    UIView *segView = [[UIView alloc]init];
    CGFloat segViewY = hotSearchH * 0.30;
    segView.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:202.0/255.0  blue:202.0/255.0  alpha:1.0];
    [self.hotSearchView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotSearchView.mas_left);
        make.top.equalTo(self.hotSearchView.mas_top).with.offset(segViewY);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, 1));
    }];
    
    //添加标签按钮
    [self addTagButton:segView];
    
}

#pragma mark - 根据设备大小添加标签按钮
- (void)addTagButton:(UIView *)view
{
    long int count = self.array.count;
    for (int i = 0; i < count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:self.array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.8] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTag:i + 10];
        [btn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [btn.layer setCornerRadius:3];
        [btn.layer setBorderWidth:1];//设置边界的宽度
        
        //设置按钮的边界颜色
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){38/255 ,40/255,50/255,0.8});
        [btn.layer setBorderColor:color];

        [btn addTarget:self action:@selector(onClickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.hotSearchView addSubview:btn];
    }
    if ([[self getCurrentDeviceModel]isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel]isEqualToString:@"iPhone 5"] ||
        [[self getCurrentDeviceModel]isEqualToString:@"iPhone Simulator"])
    {//设备为iphone 4，5时

        CGFloat horizontalPadding = 15; //水平间距
        CGFloat verticalPadding = 15;   //垂直间距
        CGSize btnSize = CGSizeMake(60, 30);
        int x = 0;
        int y = 0;
        for (int i = 0; i < self.array.count; i++)
        {
            UIButton *btn = (UIButton *)[self.hotSearchView viewWithTag:i + 10];

            int multipleY = (i+1)/5;
            CGFloat paddingY;
            CGFloat paddingX;
            int flag = (i+1)%5;

            if (flag == 0)
            {//换行

                x = 0;
                paddingY = (multipleY+1)*verticalPadding+(multipleY*btnSize.height);
                paddingX = (y+1)*horizontalPadding+(y*btnSize.width);
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.hotSearchView.mas_left).with.offset(paddingX);
                    make.top.equalTo(view.mas_bottom).with.offset(paddingY);
                    make.size.mas_equalTo(btnSize);
                }];
                y++;
                
            }else
            {//不换行
                 y = 0;
                paddingX = (x+1)*horizontalPadding+(x*btnSize.width);
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.hotSearchView.mas_left).with.offset(paddingX);
                    make.top.equalTo(view.mas_bottom).with.offset(verticalPadding);
                    make.size.mas_equalTo(btnSize);
                }];
                x++;

            }
        
        }
        
    }else if ([[self getCurrentDeviceModel]isEqualToString:@"iPhone 6"])
    {//设备为iphone 6时
        NSLog(@"iPhone 6");
    }else
    {//设备为iphone 6 plus时
        NSLog(@"iphone 6 plus");
    }
    
}

- (void)onClickTagBtn:(UIButton *)btn
{
    NSLog(@"%@",btn.titleLabel.text);
}
- (void)onClick:(UIButton *)btn {
    
    [self.searchBar resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
