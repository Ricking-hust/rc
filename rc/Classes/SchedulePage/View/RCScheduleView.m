//
//  RCScheduleView.m
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCScheduleView.h"
#import "Masonry.h"
#import "PlanModel.h"
#import "RCScrollView.h"
#import "RCTableView.h"
@implementation RCScheduleView

- (id)init
{
    if (self = [super init])
    {
        self.moreTimeImageiew = [[UIImageView alloc]init];
        self.timeNodeSV = [[RCScrollView alloc]init];
        self.timeNodeSV.tag = 99;
        self.scheduleTV = [[RCTableView alloc]init];
        self.planList = [[PlanList alloc]init];
        self.planListRanged = [[NSMutableArray alloc]init];
        self.currentPoint = [[UIImageView alloc]init];
        //注册通知，监听行程数据的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTimeNode:) name:@"timeNode" object:nil];
//        //发送timeNodeSV
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendTimeNodeScrollView" object:self.timeNodeSV];
    }
    [self setContentView];
    return self;
}
- (void)setPlanListRanged:(NSMutableArray *)planListRanged
{
    if (planListRanged.count !=0) {
        _planListRanged = planListRanged;
        self.timeNodeSV.planListRanged = _planListRanged;
        self.scheduleTV.planListRanged = _planListRanged;
        self.scheduleTV.scArray = _planListRanged.firstObject;
        [self.scheduleTV reloadData];
        //显示节点
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timeNode" object:planListRanged];
    }
}

- (void)createTimeNode:(NSNotification *)notification
{
    NSMutableArray *array = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
        UIView *defaultLine = [self createDefaultUpLine];
        UIView *lastNode = [[UIView alloc]init];
        if (array.count != 0) {
            for (int i = 0; i<array.count; i++) {
                UIView *upLine = [self createLine];
                upLine.tag = 1 +i;
                UIView *point = [[UIView alloc]init];
                point.tag = 100 + i;
                point.layer.cornerRadius = 7;
                point.backgroundColor = color;
                
                UIView *downLine = [self createLine];
                downLine.tag = 1000 +i;

                if (i == self.planListRanged.count -1) {
                    lastNode = downLine;
                    downLine.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0];
                    
                }
                
                UILabel *dayLabel = [[UILabel alloc]init];
                dayLabel.tag = 10000+i;
                dayLabel.textColor = color;
                
                UILabel *weekLabel = [[UILabel alloc]init];
                weekLabel.tag = 100000+i;
                weekLabel.textColor = color;
                weekLabel.font = [UIFont systemFontOfSize:10];
                dayLabel.font = [UIFont systemFontOfSize:13];
                [self.timeNodeSV addSubview:point];
                [self.timeNodeSV addSubview:dayLabel];
                [self.timeNodeSV addSubview:weekLabel];
                
                dayLabel.text = [self dayLabelStr:self.planListRanged AtIndex:i];
                weekLabel.text = [self weekLabelStr:self.planListRanged AtIndex:i];
                
                //10为上线的高度，14为节点的高度，60为下线的高度
                CGFloat upLineTopPadding = 130 + (20 + 14 + 80 )* i;
                [upLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.timeNodeSV.mas_top).offset(upLineTopPadding);
                    make.left.equalTo(self.timeNodeSV.mas_left).offset(67);
                    make.width.mas_equalTo(3);
                    make.height.mas_equalTo(20);
                }];
                [point mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(upLine.mas_bottom);
                    make.left.equalTo(upLine.mas_left).offset(-6);
                    make.width.mas_equalTo(14);
                    make.height.mas_equalTo(14);
                }];
                [downLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(point.mas_bottom);
                    make.height.mas_equalTo(80);
                    make.left.equalTo(upLine.mas_left);
                    make.width.equalTo(upLine.mas_width);
                }];
                [dayLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(point.mas_top).offset(-4);
                    make.right.equalTo(point.mas_left).offset(-12);
                    make.width.mas_equalTo(38);
                    make.height.mas_equalTo(16);
                }];
                [weekLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(dayLabel.mas_bottom);
                    make.left.equalTo(dayLabel.mas_left);
                    make.width.mas_equalTo(30);
                    make.height.mas_equalTo(12);
                }];
            }
            UIView *lastLine = [[UIView alloc]init];
            lastLine.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0];
            [self.timeNodeSV addSubview:lastLine];
            
            [lastLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastNode.mas_bottom);
                make.left.equalTo(lastNode.mas_left);
                make.width.equalTo(lastNode.mas_width);
                make.height.mas_equalTo(kScreenHeight - 64 - 35 -49 - (20 + 80 + 14));
            }];
            if (self.planListRanged.count > 1) {
                CGFloat height = kScreenHeight - 64 - 35 -49 + (20 + 80 + 14) * self.planListRanged.count;
                self.timeNodeSV.contentSize = CGSizeMake(0, height);
            }
        }else
        {
            defaultLine.hidden = YES;
            self.currentPoint.hidden = YES;
        }
        self.timeNodeSV.upLine = [self.timeNodeSV viewWithTag:1];
        self.timeNodeSV.downLine = [self.timeNodeSV  viewWithTag:1000];
        self.timeNodeSV.point = [self.timeNodeSV  viewWithTag:100 ];

        [self.timeNodeSV.upLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10);
        }];
        [self.timeNodeSV.downLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeNodeSV.point.mas_bottom).offset(10);
        }];
        [self.timeNodeSV.point mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeNodeSV.upLine.mas_bottom).offset(10);
        }];
        self.scheduleTV.scArray = array.firstObject;
//        self.timeNodeSV.nodeIndex = [[NSNumber alloc]initWithInt:0];
        [self.timeNodeSV setContentOffsetY:0];
        [self.scheduleTV reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timeNodeSV" object:self.timeNodeSV];
    });
}


- (NSString *)dayLabelStr:(NSMutableArray *)array AtIndex:(int)i
{
    
    NSArray *tempArray = array[i];
    PlanModel *plmodel = tempArray[0];
    NSString *str = [NSString stringWithFormat:@"%@.%@",[plmodel.planTime substringWithRange:NSMakeRange(5, 2)],[plmodel.planTime substringWithRange:NSMakeRange(8, 2)]];
    return str;
}
- (NSString *)weekLabelStr:(NSMutableArray *)array AtIndex:(int)i
{
    NSArray *tempArray = array[i];
    PlanModel *plmodel = tempArray[0];

    NSString *year = [plmodel.planTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [plmodel.planTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [plmodel.planTime substringWithRange:NSMakeRange(8, 2)];
    NSString *strWeek = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSDate *date = [dateformat dateFromString:strWeek];
    return [self weekStringFromDate:date];
    
}
- (UIView *)createLine
{
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    UIView *upLine = [[UIView alloc]init];
    upLine.backgroundColor = color;
    [self.timeNodeSV addSubview:upLine];
    return upLine;
}
- (UIView *)createDefaultUpLine
{
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = color;
    [self.timeNodeSV addSubview:view];
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeNodeSV.mas_top);
        make.left.equalTo(self.timeNodeSV).offset(67);
        make.size.mas_equalTo(CGSizeMake(3, 130));
    }];
    return view;
}

/**
 *  根据日期返回星期
 *
 * @param date 指定的日期
 *
 * @return 返回指定日期的星期
 */
-(NSString *)weekStringFromDate:(NSDate *)date
{
    NSArray *weeks = @[[NSNull null],@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSCalendar *calendar =[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone =[[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:calendarUnit fromDate:date];
    return [weeks objectAtIndex:components.weekday];
}

- (void)setContentView
{
    self.currentPoint.image = [UIImage imageNamed:@"currentPoint"];
    self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.timeNodeSV.backgroundColor = [UIColor clearColor];
    self.scheduleTV.backgroundColor = [UIColor clearColor];
    self.timeNodeSV.showsVerticalScrollIndicator = NO;
    self.scheduleTV.showsVerticalScrollIndicator = NO;
    self.timeNodeSV.delegate = self.timeNodeSV;
    self.scheduleTV.delegate = self.scheduleTV;
    self.scheduleTV.dataSource = self.scheduleTV;
    
    [self addSubview:self.moreTimeImageiew];
    [self addSubview:self.timeNodeSV];
    [self addSubview:self.scheduleTV];
    [self addSubview:self.currentPoint];
    self.moreTimeImageiew.image = [UIImage imageNamed:@"more"];
    [self.moreTimeImageiew mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(33);
        make.size.mas_equalTo(self.moreTimeImageiew.image.size);
    }];
    [self.timeNodeSV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreTimeImageiew.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.scheduleTV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.timeNodeSV.mas_right);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.currentPoint mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(140 + 35 + 2);
        make.left.equalTo(self.mas_left).offset(53);
        make.width.mas_equalTo(self.currentPoint.image.size.width);
        make.height.mas_equalTo(self.currentPoint .image.size.height);
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
