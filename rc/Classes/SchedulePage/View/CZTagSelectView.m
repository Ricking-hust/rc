//
//  CZTagSelectView.m
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTagSelectView.h"
#import "CZTagWithLabelView.h"
#import "Masonry.h"

@implementation CZTagSelectView

+ (instancetype)tagSelectView
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat viewH = rect.size.width * 0.50;
    CZTagSelectView *view = [[CZTagSelectView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, viewH)];
    view.backgroundColor = [UIColor whiteColor];

    view.meetingTag = [view createTagImage:[UIImage imageNamed:@"meetingIcon"] WithTittle:@"会议"];
    [view addSubview:view.meetingTag];
    
    view.appointmentTag = [view createTagImage:[UIImage imageNamed:@"appointmentIcon"] WithTittle:@"约会"];
    [view addSubview:view.appointmentTag];

    view.businessTag = [view createTagImage:[UIImage imageNamed:@"businessIcon"] WithTittle:@"出差"];
    [view addSubview:view.businessTag];

    view.sportTag = [view createTagImage:[UIImage imageNamed:@"sportIcon"] WithTittle:@"运动"];;
    [view addSubview:view.sportTag];

    view.shoppingTag = [view createTagImage:[UIImage imageNamed:@"shoppingIcon"] WithTittle:@"购物"];;
    [view addSubview:view.shoppingTag];
    
    view.entertainmentTag = [view createTagImage:[UIImage imageNamed:@"entertainmentIcon"] WithTittle:@"娱乐"];;
    [view addSubview:view.entertainmentTag];
    
    view.partTag = [view createTagImage:[UIImage imageNamed:@"partIcon"] WithTittle:@"聚会"];;
    [view addSubview:view.partTag];
    
    view.otherTag = [view createTagImage:[UIImage imageNamed:@"otherIcon"] WithTittle:@"其他"];
    [view addSubview:view.otherTag];
    
    [view addSubviewConstraints];
    
    return view;
}
- (void)addSubviewConstraints
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat topPadding = rect.size.width * 0.05;
    CGFloat leftPadding = rect.size.width * 0.07;
    CGFloat bottomPadding = rect.size.width * 0.04;
    
    CGFloat paddingToMeeting = rect.size.width * 0.16;      //约会距离会议的右边距
    CGFloat paddingToAppointment = rect.size.width * 0.17;  //出差距离约会的右边距
    CGFloat paddingToBusiness = rect.size.width * 0.14;     //运动距离出差的右边距
    CGFloat paddingToShopping = rect.size.width * 0.15;     //娱乐距离购物的右边距
    CGFloat paddingToEntertainment = rect.size.width * 0.17;//聚会距离娱乐的右边距
    CGFloat paddingToPart = rect.size.width * 0.14;         //其他距离聚会的右边距
    
    [self.meetingTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(topPadding);
        make.left.equalTo(self.mas_left).with.offset(leftPadding);
    }];
    
    [self.appointmentTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.meetingTag.mas_top);
        make.left.equalTo(self.meetingTag.mas_right).with.offset(paddingToMeeting);
    }];
    [self.businessTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.meetingTag.mas_top);
        make.left.equalTo(self.appointmentTag.mas_right).with.offset(paddingToAppointment);;
    }];
    [self.sportTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.meetingTag.mas_top);
        make.left.equalTo(self.businessTag.mas_right).with.offset(paddingToBusiness);
    }];
    [self.shoppingTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.meetingTag.mas_left);
        make.bottom.equalTo(self.mas_bottom).with.offset(-bottomPadding);
    }];
    [self.entertainmentTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.meetingTag.mas_right).with.offset(paddingToShopping);
        make.bottom.equalTo(self.shoppingTag.mas_bottom);
    }];
    [self.partTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entertainmentTag.mas_right).with.offset(paddingToEntertainment);
        make.bottom.equalTo(self.shoppingTag.mas_bottom);
    }];
    [self.otherTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.partTag.mas_right).with.offset(paddingToPart);
        make.bottom.equalTo(self.shoppingTag.mas_bottom);
    }];
    
}
- (CZTagWithLabelView *)createTagImage:(UIImage *)img WithTittle:(NSString *)tittle
{
    CZTagWithLabelView *tag = [[CZTagWithLabelView alloc]initWithImage:img andTittle:tittle];
    return tag;
}
@end
