//
//  CZMoreRemindTimeViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMoreRemindTimeViewController.h"
#import "Masonry.h"
#import "CZRemindView.h"
#import "CZRemintTimeView.h"
#define FONTSIZE    14

@interface CZMoreRemindTimeViewController ()

@end

@implementation CZMoreRemindTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavigationItem];
    [self createSubView];

    [self addConstraintOfSubView];
    
}
- (void)createSubView
{
    self.notRemind = [[CZRemindView alloc]init];
    self.beforeOneDay = [[CZRemindView alloc]init];
    self.beforeThreeDay = [[CZRemindView alloc]init];
    self.beforeFiveDay = [[CZRemindView alloc]init];
    self.notRemind.label.text = @"不提醒";
    self.beforeOneDay.label.text = @"前一天";
    self.beforeThreeDay.label.text = @"前三天";
    self.beforeFiveDay.label.text = @"前五天";
    
    self.timeView = [[CZRemintTimeView alloc]init];
    
    [self.view addSubview:self.notRemind];
    [self.view addSubview:self.beforeOneDay];
    [self.view addSubview:self.beforeThreeDay];
    [self.view addSubview:self.beforeFiveDay];
    
    [self.view addSubview:self.timeView];
    
    UITapGestureRecognizer *notRemind = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didNotRemind:)];
    [self.notRemind addGestureRecognizer:notRemind];
    
    UITapGestureRecognizer *oneDay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectDay:)];
    [self.beforeOneDay addGestureRecognizer:oneDay];
    
    UITapGestureRecognizer *threeDay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectDay:)];
    [self.beforeThreeDay addGestureRecognizer:threeDay];
    UITapGestureRecognizer *fiveDay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectDay:)];
    [self.beforeFiveDay addGestureRecognizer:fiveDay];
}

//添加self.view子控件的约束
- (void)addConstraintOfSubView
{
    [self addConstraintOfRemindView:self.notRemind WithPadding:64+7];
    [self addConstraintOfRemindView:self.beforeOneDay WithPadding:64+7+40];
    [self addConstraintOfRemindView:self.beforeThreeDay WithPadding:64+7+40+40];
    [self addConstraintOfRemindView:self.beforeFiveDay WithPadding:64+7+40+40+40];
    self.beforeFiveDay.segline.hidden = YES;
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.beforeFiveDay.mas_bottom).offset(7);
        make.width.mas_equalTo([[UIScreen mainScreen]bounds].size.width);
        make.height.mas_equalTo(40);
    }];
    [self.timeView.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView.mas_left).offset(10);
        make.centerY.equalTo(self.timeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    CGSize timeSize = [self sizeWithText:self.timeView.time.text maxSize:CGSizeMake(MAXFLOAT, 20) fontSize:14];
    [self.timeView.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeView.mas_centerY);
        make.right.equalTo(self.timeView.img.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(timeSize.width+1, timeSize.height+1));
    }];
    [self.timeView.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeView.mas_right).offset(-10);
        make.centerY.equalTo(self.timeView.mas_centerY);
        make.size.mas_equalTo(self.timeView.img.image.size);
    }];
}
//添加remindView子控件的约束
- (void)addConstraintOfRemindView:(CZRemindView *)remindView WithPadding:(CGFloat)topPadding
{
    [remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(topPadding);
        make.width.mas_equalTo([[UIScreen mainScreen]bounds].size.width);
        make.height.mas_equalTo(40);
    }];
    [remindView.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remindView.mas_centerY);
        make.left.equalTo(remindView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [remindView.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remindView.mas_centerY);
        make.right.equalTo(remindView.mas_right).offset(-10);
        make.size.mas_equalTo(remindView.img.image.size);
    }];
    [remindView.segline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remindView.label.mas_left);
        make.top.equalTo(remindView.mas_bottom).offset(-1);
        make.right.equalTo(remindView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)didSelectDay:(UITapGestureRecognizer *)gesture
{
    CZRemindView *view = (CZRemindView *)gesture.view;
    view.img.hidden = NO;
    self.notRemind.img.hidden = YES;
}
- (void)didNotRemind:(UITapGestureRecognizer *)gesture
{
    CZRemindView *view = (CZRemindView *)gesture.view;
    view.img.hidden = NO;
    self.beforeOneDay.img.hidden = YES;
    self.beforeThreeDay.img.hidden = YES;
    self.beforeFiveDay.img.hidden = YES;
}
- (void)setNavigationItem
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backForwardController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
}
- (void)backForwardController
{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置标签的样式
- (CGSize)setLabelStyle:(UILabel *)label WithContent:(NSString *)content
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    label.font = [UIFont systemFontOfSize:FONTSIZE];
    label.numberOfLines = 0;
    label.text = content;
    label.alpha = 1.0;
    CGSize size = [self sizeWithText:content maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];
    
    return size;
}
/**
 *  计算字体的长和宽
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

@end
