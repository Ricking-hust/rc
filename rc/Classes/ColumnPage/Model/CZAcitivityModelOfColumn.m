//
//  CZAcitivityModelOfColumn.m
//  rc
//
//  Created by AlanZhang on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZAcitivityModelOfColumn.h"

@implementation CZAcitivityModelOfColumn

+ (instancetype)activity
{
    CZAcitivityModelOfColumn *activity = [[CZAcitivityModelOfColumn alloc]init];
#pragma mark - 测试数据
    [activity setData];
    return activity;
}

-(void) setData
{
    self.ac_id = 1111;
    self.ac_poster = @"activityImage";
    self.ac_title = @"2015年苹果开发都大会";
    self.ac_time = @"时间：2015.1.1 14:00 AM";
    self.ac_place = @"地点：光谷体育馆";
    self.ac_tags = @"相亲 单身";
    self.ac_collect_num = 11111;
    self.ac_praise_num = 22222;
    self.ac_read_num = 33333;
}

@end
