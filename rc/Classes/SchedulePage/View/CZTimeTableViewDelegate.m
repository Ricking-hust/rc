//
//  CZTimeTableViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTimeTableViewDelegate.h"
#import "CZTimeNodeCell.h"
#import "Masonry.h"
#import "CZTestData.h"
#import "PlanModel.h"

@interface CZTimeTableViewDelegate ()

@end
@implementation CZTimeTableViewDelegate

- (id)init
{
    if (self = [super init])
    {
        self.height = 0;
        self.isUp = NO;
        self.isDefualt = YES;
    }
    return self;
}
- (void)setDevice:(CurrentDevice)device
{
    _device = device;
    if (_device == IPhone5)
    {
        self.height = 105;
    }else if(_device == IPhone6)
    {
        self.height = 103.8;
    }else
    {
        self.height = 117.6;
        //self.height = 105;

    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.array.count)
    {
        CZTimeNodeCell *cell = [[CZTimeNodeCell alloc]init];
        //对cell进行赋值
        [self setValueOfCell:cell AtIndexPath:indexPath];
        //对cell进行布局
        [self addCellConstraint:cell AtIndexPath:indexPath];
        
        return cell;
    }else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.array.count == indexPath.row)
    {
        return kScreenHeight - self.height - 64 -35 - 49;
    }
    return self.height;
}
- (void)setValueOfCell:(CZTimeNodeCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tempArray = self.array[indexPath.row];
    PlanModel *plmodel = tempArray[0];
    
    //对cell进行赋值
    NSString *str = [NSString stringWithFormat:@"%@:%@",[plmodel.planTime substringWithRange:NSMakeRange(5, 2)],[plmodel.planTime substringWithRange:NSMakeRange(8, 2)]];
    cell.dayLabel.text = str;
    NSString *strWeek = [plmodel.planTime substringWithRange:NSMakeRange(0, 10)];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSDate *date = [dateformat dateFromString:strWeek];
    NSString *weekString=[self weekStringFromDate:date];
    cell.weekLabel.text = weekString;
}
- (void)addCellConstraint:(CZTimeNodeCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.isDefualt)
    {
        [cell.upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left).offset(62);
            make.width.mas_equalTo(3);
            make.bottom.equalTo(cell.selectedPoint.mas_top).offset(-4);
        }];
        [cell.point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.upLineView.mas_left).offset(-6);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
        
        [cell.selectedPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.point.mas_top).offset(-8);
            make.left.equalTo(cell.point.mas_left).offset(-8);
            make.size.mas_equalTo(cell.selectedPoint.image.size);
        }];
        [cell.downLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.selectedPoint.mas_bottom).offset(4);
            make.left.equalTo(cell.upLineView.mas_left);
            make.width.equalTo(cell.upLineView.mas_width);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        [cell.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.point.mas_top).offset(-6);
            make.right.equalTo(cell.point.mas_left).offset(-10);
            make.width.mas_equalTo(37);
            make.height.mas_equalTo(16);
        }];
        [cell.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.dayLabel.mas_bottom);
            make.centerX.equalTo(cell.dayLabel.mas_centerX);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(12);
        }];
        self.isDefualt = NO;
    }else
    {
        [cell.upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left).offset(62);
            make.width.mas_equalTo(3);
            make.bottom.equalTo(cell.point.mas_top);
        }];
        [cell.point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.upLineView.mas_left).offset(-6);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
        
        [cell.selectedPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.point.mas_top).offset(-8);
            make.left.equalTo(cell.point.mas_left).offset(-8);
            make.size.mas_equalTo(cell.selectedPoint.image.size);
        }];
        cell.selectedPoint.hidden = YES;
        [cell.downLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.point.mas_bottom);
            make.left.equalTo(cell.upLineView.mas_left);
            make.width.equalTo(cell.upLineView.mas_width);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        [cell.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.point.mas_top).offset(-6);
            make.right.equalTo(cell.point.mas_left).offset(-10);
            make.width.mas_equalTo(37);
            make.height.mas_equalTo(16);
        }];
        [cell.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.dayLabel.mas_bottom);
            make.centerX.equalTo(cell.dayLabel.mas_centerX);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(12);
        }];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        //刷新数据 to do here --------
        [self updateDataSoucre:self.array AtTableView:self.scTableView];
        //设置cell的选中状态
        [self setStateOfCurrentCell];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //刷新数据 to do here --------
    [self updateDataSoucre:self.array[0] AtTableView:self.scTableView];
    //设置cell的选中状态
    [self setStateOfCurrentCell];
}

- (void)updateDataSoucre:(NSArray *)array AtTableView:(UITableView *)tableView
{
    
    [tableView reloadData];
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

#pragma mark - 更新数据
- (void)updateUpDataSoucre:(NSMutableArray *)array AtTableView:(UITableView *)tableView
{
    
    [tableView reloadData];
}
- (void)setStateOfCurrentCell
{
    [self.timeNodeTableView reloadData];
    CZTimeNodeCell *cell = self.timeNodeTableView.visibleCells.firstObject;
    cell.selectedPoint.hidden = NO;
    
    [cell.upLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.point.mas_top).offset(-10);
    }];
    
    [cell.downLineView mas_updateConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell.point.mas_bottom).offset(10);
    }];

    [cell layoutIfNeeded];

}


- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

@end
