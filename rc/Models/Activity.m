//
//  Activity.m
//  日常
//
//  Created by AlanZhang on 16/1/8.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "Activity.h"

@implementation Activity


+ (instancetype) activity
{
    Activity *activity = [[Activity alloc]init];

    return activity;
}

- (void)setSubViewsContent
{
    self.ac_id = 1111;
    self.ac_poster = @"activityImage";
    self.ac_title = @"2015年沸雪北京世界单板滑雪赛与现场音乐会";
    self.ac_time = @"时间：2015.1.1 14:00 AM";
    self.ac_place = @"地点：光谷体育馆";
    self.ac_tags = @"相亲 单身";
    self.ac_collect_num = 11111;
    self.ac_praise_num = 22222;
    self.ac_read_num = 33333;
}





@end
