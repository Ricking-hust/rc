//
//  CZTagSelectViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTagSelectViewController.h"
#import "Masonry.h"
#include <sys/sysctl.h>
#define buttonSize CGSizeMake(65, 30)
#define IPHONE5PADDING  12
#define IPHONE6PADDING  23
#define IPHONE6PLUSPADDING  30.8
typedef NS_ENUM(NSInteger, CurrentDevice)
{
    IPhone5     = 0,    //4寸    568 X 320
    IPhone6     = 1,    //4.7寸  667 X 375
    Iphone6Plus = 2     //5.5寸  736 X 414
};
@interface CZTagSelectViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, strong) UIView *myTaglabelView;
@property (nonatomic, strong) UIView *myTagButtonsView;
@property (nonatomic, assign) CGFloat myTagViewHeight;      //我的标签按钮的父容器视图的高度
@property (nonatomic, assign) CGFloat defaultTagViewHeight; //系统标签与按钮的父容器视图的高度
@property (nonatomic, strong) UIView *defaultTagView;
@property (nonatomic, strong) UIView *tagLabelView;
@property (nonatomic, strong) UIView *tagButtonsView;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *myTags;
@property (nonatomic, strong) NSMutableArray *myTagButton;
@property (nonatomic, strong) NSMutableArray *tagButtons;

@property (nonatomic, assign) BOOL isDirect;    //按钮的添加方式 yes为直接添加 no为改变mytagView的高度再添加 默认no
@end

@implementation CZTagSelectViewController

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left);
            make.width.mas_equalTo([[UIScreen mainScreen]bounds].size.width);
            make.height.mas_equalTo([[UIScreen mainScreen]bounds].size.height - 64);
        }];
    }
    return _scrollView;
}
#pragma mark - 界面加载完毕
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[[UIView alloc]init]];    //用于消除第一个被添加到self.view中的scroll被导航栏影响布局的问题
    self.isDirect = NO;
#pragma mark - test
    self.tags = [[NSMutableArray alloc]initWithObjects:@"创者", @"资讯",@"媒s",@"感如何",@"者", @"讯",@"媒",@"如何",
                 @"屁事快说",nil];
    self.myTags = [[NSMutableArray alloc]initWithObjects:@"创业者", @"新闻资讯",@"媒体",@"感觉如何",@"创业者", @"新闻资讯",@"媒体",nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigation];
    //获取当前的设备
    self.device = [self currentDeviceSize];

    [self createSubViews];
    self.scrollView.contentSize = CGSizeMake(0, self.myTagViewHeight + 30 + self.defaultTagViewHeight);
}
- (void)setNavigation
{
    self.navigationItem.title = @"标签选择";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popThisViewController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    UIBarButtonItem *rightButtont = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmTag)];
    [self.navigationItem setRightBarButtonItem:rightButtont];
}
- (void)createSubViews
{
    CGFloat labelLeftPadding = 12;
    //创建我的标签View
    [self myTagLabelWithPadding:labelLeftPadding];
    //创建我的标签按钮
    [self myTagView];
    //创建系统标签View
    [self tagLabelWithPadding:labelLeftPadding];
    //创建系统标签按钮
    [self tagsView];
    

}
//创建我的标签栏的View
- (void)myTagLabelWithPadding:(CGFloat)padding
{
    self.myTaglabelView = [[UIView alloc]init];
    [self.scrollView addSubview:self.myTaglabelView];
    self.myTaglabelView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.myTaglabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.scrollView.mas_top);
        make.width.equalTo(@([[UIScreen mainScreen]bounds].size.width));
        make.height.mas_equalTo(30);
    }];
    
    UILabel *myTageLabel = [[UILabel alloc]init];
    myTageLabel.text = @"我的标签";
    myTageLabel.font = [UIFont systemFontOfSize:12];
    myTageLabel.textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0  blue:140.0/255.0  alpha:1.0];
    [self.myTaglabelView addSubview:myTageLabel];
    [myTageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTaglabelView).offset(padding);
        make.centerY.equalTo(self.myTaglabelView);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}
/**
 *  创建我的标签按钮的父容器
 *
 */
- (void)myTagView
{
    self.myTagButtonsView = [[UIView alloc]init];
    self.myTagButtonsView.backgroundColor = [UIColor whiteColor];
    self.myTagButtonsView.tag = 1;
    [self.scrollView addSubview:self.myTagButtonsView];
    CGFloat heigth = [self heigthForTagButtonsView:self.myTagButtonsView];
    self.myTagViewHeight = heigth;
    [self.myTagButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTaglabelView.mas_bottom);
        make.left.equalTo(self.myTaglabelView.mas_left);
        make.width.equalTo(self.myTaglabelView.mas_width);
        make.height.mas_equalTo(self.myTagViewHeight);
    }];
    [self creatMyTagAtView:self.myTagButtonsView];
    
}
/**
 *  创建我的标签按钮
 *
 */
- (void)creatMyTagAtView:(UIView *)view
{
    int x = 0;
    int y = 0;
    CGFloat XPading = 0;
    CGFloat YPadding = 12;
    CGFloat padding;
    if (self.device == IPhone5)
    {
        padding = IPHONE5PADDING;
    }else if (self.device == IPhone6)
    {
        padding = IPHONE6PADDING;
    }else
    {
        padding = IPHONE6PLUSPADDING;
    }
    for (int i = 0; i < self.myTags.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [self setButton:btn WithTittle:self.myTags[i] AtView:view];
        [btn addTarget:self action:@selector(onClickOfTagButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        if ((i) % 4 == 0 && i != 0 )
        {
            x = 0;
            YPadding = 12 * (y + 2) + (y+1) * 30;
            y++;
        }
        XPading = padding * (x + 1) + x * 65;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myTagButtonsView .mas_left).with.offset(XPading);
            make.top.equalTo(self.myTagButtonsView .mas_top).with.offset(YPadding);
            make.size.mas_equalTo(buttonSize);
        }];
        x++;
    }
}
/**
 * 创建系统标签栏
 *
 */
- (void)tagLabelWithPadding:(CGFloat)padding
{
    self.tagLabelView = [[UIView alloc]init];
    self.defaultTagView = [[UIView alloc]init];
    
    [self.scrollView addSubview:_defaultTagView];

    self.defaultTagViewHeight = [self heigthForTagButtonsView:self.tagButtonsView] + 30;
    [self.defaultTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.myTagButtonsView.mas_bottom);
        make.width.mas_equalTo([[UIScreen mainScreen]bounds].size.width);
        make.height.mas_equalTo(self.defaultTagViewHeight);
    }];
    [self.defaultTagView addSubview:self.tagLabelView];
    self.tagLabelView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.tagLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.defaultTagView.mas_left);
        make.top.equalTo(self.defaultTagView.mas_top);
        make.width.equalTo(@([[UIScreen mainScreen]bounds].size.width));
        make.height.mas_equalTo(30);
    }];
    
    UILabel *myTageLabel = [[UILabel alloc]init];
    myTageLabel.text = @"点击添加标签";
    myTageLabel.font = [UIFont systemFontOfSize:12];
    myTageLabel.textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0  blue:140.0/255.0  alpha:1.0];
    [self.tagLabelView addSubview:myTageLabel];
    [myTageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabelView).offset(padding);
        make.centerY.equalTo(self.tagLabelView);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
}
/**
 *  创建系统标签按钮
 *
 */
- (void)tagsView
{
    self.tagButtonsView = [[UIView alloc]init];
    self.tagButtonsView.backgroundColor = [UIColor whiteColor];
    self.tagButtonsView.tag = 2;
    [self.defaultTagView addSubview:self.tagButtonsView];
    CGFloat heigth = [self heigthForTagButtonsView:self.tagButtonsView];

    [self.tagButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagLabelView.mas_bottom);
        make.left.equalTo(self.defaultTagView.mas_left);
        make.width.equalTo(self.tagLabelView.mas_width);
        make.height.mas_equalTo(heigth);
    }];

    [self creatTagAtView:self.tagButtonsView];
}

/**
 *  创建系统标签按钮
 *
 */
- (void)creatTagAtView:(UIView *)view
{
    int x = 0;
    int y = 0;
    CGFloat XPading = 0;
    CGFloat YPadding = 12;
    CGFloat padding;
    if (self.device == IPhone5)
    {
        padding = IPHONE5PADDING;
    }else if (self.device == IPhone6)
    {
        padding = IPHONE6PADDING;
    }else
    {
        padding = IPHONE6PLUSPADDING;
    }
    for (int i = 0; i < self.tags.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [self setButton:btn WithTittle:self.tags[i] AtView:view];
        [btn addTarget:self action:@selector(onClickOfTagButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        if ((i) % 4 == 0 && i != 0 )
        {
            x = 0;
            YPadding = 12 * (y + 2) + (y+1) * 30;
            y++;
        }
        XPading = padding * (x + 1) + x * 65;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).with.offset(XPading);
            make.top.equalTo(view.mas_top).with.offset(YPadding);
            make.size.mas_equalTo(buttonSize);
        }];
        x++;
    }
}
- (void)setButton:(UIButton *)button WithTittle:(NSString *)tittle AtView:(UIView *)view;
{
    if (view.tag == 1)
    {
        [button setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else
    {
        
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.8] forState:UIControlStateNormal];
        [button.layer setBorderWidth:1];    //设置边界的宽度
        //设置按钮的边界颜色
        //CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        //CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
        CGColorRef color =[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.8].CGColor;
        [button.layer setBorderColor:color];
    }
    [button setTitle:tittle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button.layer setCornerRadius:3];   //设置圆角
    
}

- (CGFloat)heigthForTagButtonsView:(UIView *)view
{
    if (view.tag == 1)
    {
        CGFloat row = self.myTags.count / 4.0;
        int height = (int)row;
        if (height == row)
        {
            return (height + 1) * 12 + height * 30;
        }else
        {
            height ++ ;
            return (height + 1) * 12 + height * 30;
        }
    }else
    {
        CGFloat row = self.tags.count / 4.0;
        int height = (int)row;
        if (height == row)
        {
            return (height + 1) * 12 + height * 30;
        }else
        {
            height ++ ;
            return (height + 1) * 12 + height * 30;
        }
    }

}
#pragma mark - 标签按钮的点击事件
- (void)onClickOfTagButton:(UIButton *)button
{

    UIView *view = button.superview;
    if (view.tag == 1)
    {//点击的是我的标签里的按钮


        
    }else
    {//点击的是系统标签按钮
        if (![self isRepeat:button])
        {
            if (self.myTags.count % 4 == 0)
            {//增加一行myTagView的高度
                self.isDirect = NO;
                self.myTagViewHeight = self.myTagViewHeight + 42;
                
                [UIView animateWithDuration:1 animations:^{
                    [self.myTagButtonsView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(self.myTagViewHeight);
                    }];
                    [self.defaultTagView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.myTagButtonsView.mas_bottom);
                    }];
                    
                    [self.view layoutIfNeeded];
                }];
                //添加按钮
                UIButton *tempBtn = [[UIButton alloc]init];
                [self.myTagButtonsView addSubview:tempBtn];
                [self addButton:tempBtn WithTittel:button.titleLabel.text];
            }else
            {//此时不用增加myTageView的高度
                self.isDirect = YES;
                //1.创建按钮
                UIButton *tempBtn = [[UIButton alloc]init];
                //2.添加按钮
                [self.myTagButtonsView addSubview:tempBtn];
                [self addButton:tempBtn WithTittel:button.titleLabel.text];
                
            }
            [self.myTags addObject:button.titleLabel.text];
            self.scrollView.contentSize = CGSizeMake(0, self.defaultTagViewHeight + self.myTagViewHeight + 30);
        }
    }
}
- (BOOL)isRepeat:(UIButton *)btn
{
    for (int i = 0; i < self.myTags.count; i++)
    {
        if ([self.myTags[i] isEqualToString:btn.titleLabel.text])
        {
            return YES;
        }
    }
    return NO;
}
- (void)addButton:(UIButton *)button WithTittel:(NSString *)tittle
{
    [button addTarget:self action:@selector(onClickOfTagButton:) forControlEvents:UIControlEventTouchUpInside];
    [self setButton:button WithTittle:tittle AtView:button.superview];
    CGFloat padding;
    if (self.device == IPhone5)
    {
        padding = IPHONE5PADDING;
    }else if (self.device == IPhone6)
    {
        padding = IPHONE6PADDING;
    }else
    {
        padding = IPHONE6PLUSPADDING;
    }
    
    if (self.isDirect)
    {//isDirect == no 改变mytagView的高度再添加
        //1.计算按钮所在列
        long int column = self.myTags.count % 4;
        //2.计算按钮所在行
        CGFloat count = (CGFloat)self.myTags.count;
        long int row = ((int)count / 4.0) + 1;
        CGFloat YPadding = row *12 + (row - 1)*30;
        CGFloat XPadding = (column+1)*padding + column * 65;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.superview.mas_top).offset(YPadding);
            make.left.equalTo(button.superview.mas_left).offset(XPadding);
            make.size.mas_equalTo(buttonSize);
        }];
        
    }else
    {//isDirect == yes 直接添加
        long int row = self.myTags.count /4;
        CGFloat YPadding = (row+1)*12 + row * 30;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myTagButtonsView.mas_left).offset(padding);
            make.top.equalTo(self.myTagButtonsView.mas_top).offset(YPadding);
            make.size.mas_equalTo(buttonSize);
        }];
    }

}

//导航栏左侧取消按钮
- (IBAction)onClickCancel:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//导航栏右侧确定按钮
- (IBAction)onClickConfirm:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)confirmTag
{
    
}
- (void)popThisViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
