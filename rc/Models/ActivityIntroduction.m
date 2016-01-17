//
//  ActivityIntroduction.m
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "ActivityIntroduction.h"

@implementation ActivityIntroduction


+ (instancetype) acIntroduction
{
    ActivityIntroduction *acIntroduction = [[ActivityIntroduction alloc]init];

    return acIntroduction;
}


#pragma mark - 测试数据
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
    self.ac_size = @"规模：100-200人";
    self.ac_pay = @"费用：免费";
    self.ac_desc = @"”在clone完成之后，Git 会自动为你将此远程仓库命名为origin（origin只相当于一个别名，运行git remote –v或者查看.git/config可以看到origin的含义），并下载其中所有的数据，建立一个指向它的master 分支的指针，我们用(远程仓库名)/(分支名) 这样的形式表示远程分支，所以origin/master指向的是一个remote branch（从那个branch我们clone数据到本地）“";
    
}
@end
