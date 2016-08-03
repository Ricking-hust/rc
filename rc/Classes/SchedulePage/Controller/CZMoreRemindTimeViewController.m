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
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#define FONTSIZE    14

@interface CZMoreRemindTimeViewController ()
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) PlanModel *model;
@property (nonatomic, strong) NSString *alarmOne;
@property (nonatomic, strong) NSString *alarmTwo;
@property (nonatomic, strong) NSString *alarmThree;
@end

@implementation CZMoreRemindTimeViewController
#pragma mark - 设置提醒时间代理
- (void)passModifySchedule:(id)schedule
{
    self.model = schedule;
    self.alarmOne = [NSString stringWithFormat:@"%@",self.model.plAlarmOne];
    self.alarmTwo = [NSString stringWithFormat:@"%@",self.model.plAlarmTwo];
    self.alarmThree = [NSString stringWithFormat:@"%@",self.model.plAlarmThree];

}
- (PlanModel *)model
{
    if (!_model)
    {
        _model = [[PlanModel alloc]init];
    }
    return _model;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationItem];
    [self createSubView];
    [self addConstraintOfSubView];
    [self.notRemind addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionNew context:nil];
#pragma mark - 后期实现
    self.timeView.hidden = YES;
}
- (void)dealloc
{
    [self.notRemind removeObserver: self forKeyPath:@"isSelected"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self setRemindView:self.beforeOneDay WithState:self.model.plAlarmOne];
    [self setRemindView:self.beforeTwoDay WithState:self.model.plAlarmTwo];
    [self setRemindView:self.beforeThreeDay WithState:self.model.plAlarmThree];
    if (self.beforeThreeDay.img.hidden && self.beforeOneDay.img.hidden && self.beforeTwoDay.img.hidden)
    {
        self.timeView.label.alpha = 0.3;
        self.timeView.time.alpha = 0.3;
        self.timeView.img.alpha = 0.3;
    }else
    {
        self.timeView.label.alpha = 1.0;
        self.timeView.time.alpha = 1.0;
        self.timeView.img.alpha = 1.0;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSetRemindTime:)];
        [self.timeView addGestureRecognizer:gesture];
    }
}
- (void)setRemindView:(CZRemindView *)view WithState:(NSString *)state
{
    if ([state isEqualToString:@"0"])
    {
        view.img.hidden = YES;
    }else if(state == nil)
    {
        ;
    }else
    {
        view.img.hidden = NO;
    }
}
#pragma mark - 弹出准确的时间点
- (void)didSetRemindTime:(UITapGestureRecognizer *)gesture
{
    

}

- (void)didSelectDay:(UITapGestureRecognizer *)gesture
{
    CZRemindView *view = (CZRemindView *)gesture.view;
    view.img.hidden = !view.img.hidden;
    if (view.img.hidden == YES)
    {
        if (view.tag == 1)
        {
            self.alarmOne = @"0";
        }else if (view.tag == 2)
        {
            self.alarmTwo = @"0";
        }else
        {
            self.alarmThree = @"0";
        }
    }else
    {
        if (view.tag == 1)
        {
            self.alarmOne = @"1";
        }else if (view.tag == 2)
        {
            self.alarmTwo = @"1";
        }else
        {
            self.alarmThree = @"1";
        }
        CZRemindView *view = [self.view viewWithTag:10];
        view.img.hidden = YES;
        [view setValue:@"YES" forKey:@"isSelected"];

    }
    
    CZRemindView *one = [self.view viewWithTag:1];
    CZRemindView *two = [self.view viewWithTag:2];
    CZRemindView *three = [self.view viewWithTag:3];
    if (one.img.hidden && two.img.hidden && three.img.hidden)
    {
        CZRemindView *view = [self.view viewWithTag:10];
        view.img.hidden = YES;
        [view setValue:@"NO" forKey:@"isSelected"];
    }
}
- (void)didNotRemind:(UITapGestureRecognizer *)gesture
{
    CZRemindView *view = (CZRemindView *)gesture.view;
    view.img.hidden = NO;
    self.beforeOneDay.img.hidden = YES;
    self.beforeTwoDay.img.hidden = YES;
    self.beforeThreeDay.img.hidden = YES;
    self.alarmOne = @"0";
    self.alarmTwo = @"0";
    self.alarmThree = @"0";
    [view setValue:@"NO" forKey:@"isSelected"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CZRemindView *notRemind = (CZRemindView *)object;
    if ([notRemind valueForKey:@"isSelected"] == [[NSNumber alloc]initWithBool:YES])
    {
        self.timeView.label.alpha = 1.0;
        self.timeView.time.alpha = 1.0;
        self.timeView.img.alpha = 1.0;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSetRemindTime:)];
        [self.timeView addGestureRecognizer:gesture];
    }else
    {
        self.timeView.label.alpha = 0.3;
        self.timeView.time.alpha = 0.3;
        self.timeView.img.alpha = 0.3;
        for (UIGestureRecognizer *gesture in self.timeView.gestureRecognizers)
        {
            [self.timeView removeGestureRecognizer:gesture];
        }

    }

    
}
- (void)setNavigationItem
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backForwardController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(didSelect)];
    [self.navigationItem setRightBarButtonItem:right];
    
}
#pragma mark - 确定选择
- (void)didSelect
{
    self.model.plAlarmOne = self.alarmOne;
    self.model.plAlarmTwo = self.alarmTwo;
    self.model.plAlarmThree = self.alarmThree;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backForwardController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createSubView
{
    self.notRemind = [[CZRemindView alloc]init];
    self.beforeOneDay = [[CZRemindView alloc]init];
    self.beforeTwoDay = [[CZRemindView alloc]init];
    self.beforeThreeDay = [[CZRemindView alloc]init];
    
    self.notRemind.label.text = @"不提醒";
    self.beforeOneDay.label.text = @"前一小时";
    self.beforeTwoDay.label.text = @"前二天";
    self.beforeThreeDay.label.text = @"前三天";
    
    self.notRemind.tag = 10;
    self.beforeOneDay.tag = 1;
    self.beforeTwoDay.tag = 2;
    self.beforeThreeDay.tag = 3;
    
    self.timeView = [[CZRemintTimeView alloc]init];
    
    [self.view addSubview:self.notRemind];
    [self.view addSubview:self.beforeOneDay];
    [self.view addSubview:self.beforeTwoDay];
    [self.view addSubview:self.beforeThreeDay];
    
    [self.view addSubview:self.timeView];
    
    UITapGestureRecognizer *notRemind = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didNotRemind:)];
    [self.notRemind addGestureRecognizer:notRemind];
    
    UITapGestureRecognizer *oneDay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectDay:)];
    [self.beforeOneDay addGestureRecognizer:oneDay];
    
    UITapGestureRecognizer *threeDay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectDay:)];
    [self.beforeTwoDay addGestureRecognizer:threeDay];
    UITapGestureRecognizer *fiveDay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectDay:)];
    [self.beforeThreeDay addGestureRecognizer:fiveDay];
}

//添加self.view子控件的约束
- (void)addConstraintOfSubView
{
    [self addConstraintOfRemindView:self.notRemind WithPadding:64+7];
    [self addConstraintOfRemindView:self.beforeOneDay WithPadding:64+7+40];
    [self addConstraintOfRemindView:self.beforeTwoDay WithPadding:64+7+40+40];
    [self addConstraintOfRemindView:self.beforeThreeDay WithPadding:64+7+40+40+40];
    self.beforeThreeDay.segline.hidden = YES;
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.beforeThreeDay.mas_bottom).offset(7);
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
