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
#define NodeH 113
//每个节点的高度为113，即滚动113到下一个节点
@interface RCScheduleView()
@property (nonatomic, strong) NSString *nodexState;
@end
@implementation RCScheduleView

- (id)init
{
    if (self = [super init])
    {
        self.moreTimeImageiew = [[UIImageView alloc]init];
        self.timeNodeSV = [[RCScrollView alloc]init];
        self.timeNodeSV.tag = 99;
        self.scheduleTV = [[RCTableView alloc]init];
        self.planListRanged = [[NSMutableArray alloc]init];
        self.currentPoint = [[UIImageView alloc]init];
        self.nodexState = @"null";
        //注册通知，监听行程数据的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTimeNode:) name:@"timeNode" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNodeState:) name:@"nodeState" object:nil];
    }
    [self setContentView];
    return self;
}
- (void)getNodeState:(NSNotification *)notification
{
    self.nodexState = notification.object;
}
- (void)setPlanListRanged:(NSMutableArray *)planListRanged
{
    if (planListRanged.count !=0) {
        _planListRanged = planListRanged;
        
        self.timeNodeSV.planListRanged = _planListRanged;
        self.scheduleTV.planListRanged = _planListRanged;
//        self.scheduleTV.scArray = _planListRanged.firstObject;
//        [self.scheduleTV reloadData];
        //显示节点
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timeNode" object:planListRanged];
    }
}

- (void)createTimeNode:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *array = notification.object;
        for (UIView *view in self.timeNodeSV.subviews)
        {
            [view removeFromSuperview];
        }
        UIView *defaultLine = [self createDefaultUpLine];
        int latestIndex = 0;//保存距离当天最后的行程下标
        if (array.count != 0)
        {
            UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
            UIView *lastNode = [[UIView alloc]init];
            for (int i = 0; i<array.count; i++)
            {

                UIView *upLine = [self createLine];
                upLine.tag = 1 +i;
                
                UIView *point = [[UIView alloc]init];
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectTimeNode:)];
                [point addGestureRecognizer:gesture];
                point.tag = 100 + i;
                point.layer.cornerRadius = 7;
                point.backgroundColor = color;
                
                UIView *downLine = [self createLine];
                downLine.tag = 1000 +i;

                if (i == array.count -1)
                {
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
                
                dayLabel.text = [self dayLabelStr:array AtIndex:i];
                weekLabel.text = [self weekLabelStr:array AtIndex:i];
                
                //20为上线的高度，13为节点的高度，80为下线的高度
                CGFloat upLineTopPadding = 130 + (20 + 13 + 80 )* i;
                [upLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.timeNodeSV.mas_top).offset(upLineTopPadding);
                    make.left.equalTo(self.timeNodeSV.mas_left).offset(67);
                    make.width.mas_equalTo(2);
                    make.height.mas_equalTo(20);
                }];
                [point mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(upLine.mas_bottom);
                    make.left.equalTo(upLine.mas_left).offset(-5.5);
                    make.width.mas_equalTo(13);
                    make.height.mas_equalTo(13);
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
                //判断此行程是否已发生
                NSArray *temp = array[i];
                BOOL isHappened = [self isHappened:temp.firstObject];
                if (isHappened == YES)
                {
                    point.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0];
                    dayLabel.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
                    weekLabel.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];;
                }
            }
            lastNode.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
            CGFloat upLineTopPadding = 130 + (20 + 13 + 80 )* array.count;
            UIView *lastLine = [[UIView alloc]initWithFrame:CGRectMake(67, upLineTopPadding-70, 2, kScreenHeight - 64 - 35 -49 - (20 + 80 + 14))];
            lastLine.backgroundColor = [UIColor redColor];
            [self.timeNodeSV addSubview:lastLine];
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = lastLine.bounds;
            [lastLine.layer addSublayer:gradientLayer];
            
            //set gradient colors
            gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:224.0/255.0 alpha:1.0].CGColor];
            
            //set gradient start and end points
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 1);
            
#pragma mark - 设置Y方向上的滚动距离
            if (array.count == 1) {
                self.timeNodeSV.contentSize = CGSizeMake(0, 0);
            }else{
                CGFloat height = kScreenHeight - 64 - 35 -49 + (20 + 80 + 13) * array.count;
                self.timeNodeSV.contentSize = CGSizeMake(0, height);
            }
            if ([self.nodexState isEqualToString:@"null"])
            {
                latestIndex = [self indexOfNearlyToday:array];
                self.timeNodeSV.nodeIndex = [[NSNumber alloc]initWithInt:latestIndex];
            }else
            {
                self.nodexState = @"null";
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendTimeNodeScrollView" object:self.timeNodeSV.nodeIndex];
            self.timeNodeSV.upLine = [self.timeNodeSV viewWithTag:1+[self.timeNodeSV.nodeIndex intValue]];
            self.timeNodeSV.downLine = [self.timeNodeSV  viewWithTag:1000+[self.timeNodeSV.nodeIndex intValue]];
            self.timeNodeSV.point = [self.timeNodeSV  viewWithTag:100+[self.timeNodeSV.nodeIndex intValue]];
            [self.timeNodeSV.upLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(10);
            }];
            [self.timeNodeSV.downLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeNodeSV.point.mas_bottom).offset(10);
            }];
            [self.timeNodeSV.point mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeNodeSV.upLine.mas_bottom).offset(10);
            }];
            self.scheduleTV.scArray = array[[self.timeNodeSV.nodeIndex intValue]];
            [self.timeNodeSV setContentOffsetY:[self.timeNodeSV.nodeIndex intValue] *NodeH];
            [self.scheduleTV reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"timeNodeSV" object:self.timeNodeSV];
        }else
        {
            defaultLine.hidden = YES;
            self.currentPoint.hidden = YES;
        }
    });
}
#pragma mark - 返回距离当天最近的时间行程
- (int)indexOfNearlyToday:(NSMutableArray *)array
{

    NSDate * senddate = [NSDate date];
    NSDateFormatter  *dateformatter =[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyMMdd"];
    NSString *currentTimeStr = [dateformatter stringFromDate:senddate];
    int localTime = [currentTimeStr intValue];
    
    int index = 0;
    NSString *year;
    NSString *month;
    NSString *day;
    for (int i = 0;i < array.count; i++)
    {
        NSArray *scArray = array[i];
        PlanModel *model = scArray.firstObject;
        year = [model.planTime substringWithRange:NSMakeRange(0, 4)];
        month = [model.planTime substringWithRange:NSMakeRange(5, 2)];
        day = [model.planTime substringWithRange:NSMakeRange(8, 2)];
        NSString *timeStr = [NSString stringWithFormat:@"%@%@%@",year, month, day];
        int scTime = [timeStr intValue];
        
        if (localTime > scTime)
        {
            if (i != 0)
            {
                index = i -1;
                break;
            }else
            {
                index = 0;
                break;
            }
        }else if (localTime < scTime)
        {
            index = i;
        }else
        {
            index = i;
            break;
        }
    }
    return index;
}
#pragma mark - 判断指定的行程是否已经发生
- (BOOL)isHappened:(PlanModel *)plmodel
{
    
    
    NSString *year = [plmodel.planTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [plmodel.planTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [plmodel.planTime substringWithRange:NSMakeRange(8, 2)];
    NSString *strDate = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    NSInteger intDate = [strDate integerValue];//指定行程的日期

    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyyMMdd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSString *currentStrDate = [dateformat stringFromDate:date];
    NSInteger currentIntDate = [currentStrDate integerValue];//当前日期
    
    if (intDate > currentIntDate || intDate == currentIntDate)
    {
        return NO;
    }else
    {
        return YES;
    }

}
#pragma mark - 时间点的点击事件
- (void)didSelectTimeNode:(UITapGestureRecognizer *)gesture
{
    //1.获取tag
    NSInteger pointTag = gesture.view.tag;
    NSInteger upLineTag = pointTag - 100 + 1;
    NSInteger downLineTag = pointTag - 100 + 1000;
    if ([self.timeNodeSV.nodeIndex intValue] == upLineTag-1)
    {
        ;
    }else
    {
        //设置当前节点状态
        UIView *upLine = [self.timeNodeSV viewWithTag:upLineTag];
        UIView *point = [self.timeNodeSV viewWithTag:pointTag];
        UIView *downLine = [self.timeNodeSV viewWithTag:downLineTag];
        [self setNodeState:upLine WithPoint:point AnddownLine:downLine];
        
        //还原上个节点状态
        [self restoreNodeState:self.timeNodeSV.upLine WithPoint:self.timeNodeSV.point AnddownLine:self.timeNodeSV.downLine];
        self.timeNodeSV.upLine = upLine;
        self.timeNodeSV.point = point;
        self.timeNodeSV.downLine = downLine;
        //更新行程tableView
        //1.获取nodeIndex
        NSInteger index = pointTag - 100;
        //2.发送刷新数据通知
        NSNumber *nodexIndex = [[NSNumber alloc]initWithInt:(int)index];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:nodexIndex];
        //设置scrollView的nodeIndex
        //1.发送新节点下标通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendTimeNodeScrollView" object:nodexIndex];
        //2.设置scrollView的位移
        [UIView animateWithDuration:0.1 animations:^{
            [self.timeNodeSV setContentOffsetY:([nodexIndex intValue]) *NodeH];
        }];

    }
    
}
- (void)restoreNodeState:(UIView *)upLine WithPoint:(UIView *)point AnddownLine:(UIView *)downLine
{
    [upLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
    }];
    [downLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(point.mas_bottom);
    }];
    [point mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upLine.mas_bottom);
        
    }];
    
}
- (void)setNodeState:(UIView *)upLine WithPoint:(UIView *)point AnddownLine:(UIView *)downLine
{

    [upLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
    }];
    [downLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(point.mas_bottom).offset(10);
    }];
    [point mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upLine.mas_bottom).offset(10);
        
    }];
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
        make.size.mas_equalTo(CGSizeMake(2, 130));
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
