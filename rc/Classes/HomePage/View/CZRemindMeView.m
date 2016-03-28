//
//  CZRemindMeView.m
//  rc
//
//  Created by AlanZhang on 16/1/27.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZRemindMeView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "Masonry.h"
#import "CZRemindTimeButton.h"


@implementation CZRemindMeView

+ (instancetype)remindMeView
{
    CGFloat heigth = 210;
    CZRemindMeView *remindMe =[[CZRemindMeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, heigth)];
    remindMe.backgroundColor = [UIColor whiteColor];
    remindMe.label = [[UILabel alloc]init];
    [remindMe addSubview:remindMe.label];
    
    //创建提醒按钮
    remindMe.notRemind = [[CZRemindTimeButton alloc]init];
    remindMe.notRemind.tag = 10;
    [remindMe addSubview:remindMe.notRemind];
    
    remindMe.remindBeforeOneHour = [[CZRemindTimeButton alloc]init];
    [remindMe.remindBeforeOneHour setTag:11];
    [remindMe addSubview:remindMe.remindBeforeOneHour];
    
    remindMe.remindBeforeTwoDay = [[CZRemindTimeButton alloc]init];
    [remindMe.remindBeforeTwoDay setTag:12];
    
    [remindMe addSubview:remindMe.remindBeforeTwoDay];
    remindMe.remindBeforeThreeDay = [[CZRemindTimeButton alloc]init];
    [remindMe.remindBeforeThreeDay setTag:13];
    [remindMe addSubview:remindMe.remindBeforeThreeDay];
    
    //创建上分割线
    remindMe.topSegmentView = [[UIView alloc]init];
    [remindMe addSubview:remindMe.topSegmentView];
    
    //创建下分割线
    remindMe.bottomSegmentView = [[UIView alloc]init];
    [remindMe addSubview:remindMe.bottomSegmentView];
    
    //创建确定按钮
    remindMe.OKbtn = [[UIButton alloc]init];
    [remindMe addSubview:remindMe.OKbtn];
    [remindMe.OKbtn setTag:14];
    
    return remindMe;
}

- (void)setSubView
{
    CGFloat btnTittleSize = 12;
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 9, 0, 0);
    NSString *str = @"选择提醒时间";
    self.label.text = str;
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0  blue:33.0/255.0  alpha:1.0];
    
    self.topSegmentView.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:0.5];
    
    //中部时间提醒按钮-----------------
    self.notRemind.titleLabel.font = [UIFont systemFontOfSize:btnTittleSize];
    [self.notRemind setTitle:@"不提醒" forState:UIControlStateNormal];
    [self.notRemind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.notRemind setImage:[UIImage imageNamed:@"iconNormal"] forState:UIControlStateNormal];
    [self.notRemind setImage:[UIImage imageNamed:@"iconSelected"] forState:UIControlStateSelected];
    [self.notRemind setTitleEdgeInsets:edge];
    
    self.remindBeforeOneHour.titleLabel.font = [UIFont systemFontOfSize:btnTittleSize];
    [self.remindBeforeOneHour setTitle:@"前一小时" forState:UIControlStateNormal];
    [self.remindBeforeOneHour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.remindBeforeOneHour setImage:[UIImage imageNamed:@"iconNormal"] forState:UIControlStateNormal];
    [self.remindBeforeOneHour setImage:[UIImage imageNamed:@"iconSelected"] forState:UIControlStateSelected];
    [self.remindBeforeOneHour setTitleEdgeInsets:edge];
    
    self.remindBeforeTwoDay.titleLabel.font = [UIFont systemFontOfSize:btnTittleSize];
    [self.remindBeforeTwoDay setTitle:@"提前两天" forState:UIControlStateNormal];
    [self.remindBeforeTwoDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.remindBeforeTwoDay setImage:[UIImage imageNamed:@"iconNormal"] forState:UIControlStateNormal];
    [self.remindBeforeTwoDay setImage:[UIImage imageNamed:@"iconSelected"] forState:UIControlStateSelected];
    [self.remindBeforeTwoDay setTitleEdgeInsets:edge];
    
    self.remindBeforeThreeDay.titleLabel.font = [UIFont systemFontOfSize:btnTittleSize];
    [self.remindBeforeThreeDay setTitle:@"提前三天" forState:UIControlStateNormal];
    [self.remindBeforeThreeDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.remindBeforeThreeDay setImage:[UIImage imageNamed:@"iconNormal"] forState:UIControlStateNormal];
    [self.remindBeforeThreeDay setImage:[UIImage imageNamed:@"iconSelected"] forState:UIControlStateSelected];
    [self.remindBeforeThreeDay setTitleEdgeInsets:edge];
    
    //底部分割线-----------------
    self.bottomSegmentView.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:0.5];
    
    //底部确定按钮-----------------
    [self.OKbtn setTitle:@"确定" forState:UIControlStateNormal];
    self.OKbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.OKbtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:129.0/255.0 blue:3.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    //设置子控件的约束
    [self setConstraints];
}
- (void)setConstraints
{
    CGSize btnSize = CGSizeMake(80, 20);
    CGFloat topSegmentViewY = self.frame.size.height * 0.18;
    CGFloat letfPadding = 10;
    CGFloat btnTopPadding = self.frame.size.height * 0.8 * 0.09;
    CGFloat OfbtnPadding = self.frame.size.height * 0.8 * 0.15;
    CGFloat OKHeigth = self.frame.size.height * 0.18;
    CGFloat bottomSegY = self.self.frame.size.height * 0.8;
    CGSize lableSize = [self.label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    CGFloat labelY = (self.frame.size.height * 0.18 - lableSize.height)/2;
    //标签约束-----------------
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.size.mas_equalTo(lableSize);
    }];
    
    [self.topSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).with.offset(topSegmentViewY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1));
    }];
    
    //时间按钮-----------------
    [self.notRemind mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.topSegmentView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(btnSize);
    }];
    [self.remindBeforeOneHour mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.notRemind.mas_bottom).offset(10);
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.remindBeforeTwoDay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remindBeforeOneHour.mas_left);
        make.top.equalTo(self.remindBeforeOneHour.mas_bottom).with.offset(10);
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.remindBeforeThreeDay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remindBeforeOneHour.mas_left);
        make.top.equalTo(self.remindBeforeTwoDay.mas_bottom).with.offset(10);
        make.size.mas_equalTo(btnSize);
    }];
    
    //底部分割线-----------------
    [self.bottomSegmentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).with.offset(bottomSegY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 2));
    }];
    
    //底部确定按钮-----------------
    [self.OKbtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(OKHeigth);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

@end
