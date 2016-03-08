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
        //self.height = 117.6;
        self.height = 105;

    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTimeNodeCell *cell = [[CZTimeNodeCell alloc]init];
    NSArray *tempArray = self.array[indexPath.row];
    PlanModel *plmodel = tempArray[0];
    
    //对cell进行赋值
    NSString *str = [NSString stringWithFormat:@"%@.%@",[plmodel.planTime substringWithRange:NSMakeRange(5, 2)],[plmodel.planTime substringWithRange:NSMakeRange(8, 2)]];
    cell.dayLabel.text = str;
    cell.weekLabel.text = @"星期一";
    
    //对cell进行布局
    [self addCellConstraint:cell AtIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.height;
}

- (void)addCellConstraint:(CZTimeNodeCell *)cell
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
            make.width.mas_equalTo(35);
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
            make.width.mas_equalTo(35);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (int)scrollView.contentOffsetY / self.height;
    if (index > self.indexAtCell)
    {//上拉显示下一个时间点
        self.indexAtCell++;
        self.isUp = NO;
        //NSLog(@"上拉 %d",self.indexAtCell);
        //reflesh scTableView---------
        [self updateDataSoucre:self.array AtTableView:self.scTableView];
        //设置cell的选中状态
        [self setNextStateOfCell];
    }
    int flag = scrollView.contentOffsetY / self.height;
    if (flag < self.indexAtCell)
    {
        self.isUp = YES;
    }

    if ((int)scrollView.contentOffsetY % (int)self.height == 0 && self.isUp)
    {//下拉显示上一个时间点
        self.indexAtCell = (int)scrollView.contentOffsetY / (int)self.height;
        if (self.indexAtCell == 0)
        {
            self.isUp = NO;
        }
        //NSLog(@"下拉 %d",self.indexAtCell);
        //reflesh scTableView---------
        [self updateDataSoucre:self.array AtTableView:self.scTableView];
        //设置cell的选中状态
        [self setForwardStateOfCell];
    }
}
- (void)updateDataSoucre:(NSArray *)array AtTableView:(UITableView *)tableView
{
    //[self adjustScTableViewHeight];
    [tableView reloadData];
    
}
- (void)setNextStateOfCell
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
- (void)setForwardStateOfCell
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
/**
 *  调整scTableView的宽度
 *  iphone4/4s5/5s 一屏显示4个行程信息，超过4个开始timeScrollView的宽度恢复75，不足4个宽度满屏
 *
 *iphone6 一屏显示5个行程信息，超过5个开始timeScrollView的宽度恢复75，不足5个宽度满屏
 *
 *iphone6plus 一屏显示5个行程信息，超过5个开始timeScrollView的宽度恢复75，不足5个宽度满屏
 *
 */
- (void)adjustScTableViewHeight
{
    if (self.device == IPhone5)
    {
        if (self.array.count > 4)
        {
            [self.timeNodeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kScreenWidth);
            }];
            //self.scTableView.scrollEnabled = NO;
        }else
        {
            [self.timeNodeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(75);
            }];
            //self.scTableView.scrollEnabled = YES;
        }
    }else
    {
        if (self.array.count > 5)
        {
            [self.timeNodeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kScreenWidth);
            }];
        }else
        {
            [self.timeNodeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(75);
            }];
        }
    }

}
- (void)updateUpDataSoucre:(NSMutableArray *)array AtTableView:(UITableView *)tableView
{
//    [self.array removeAllObjects];
//    CZTestData *data1 = [[CZTestData alloc]init];
//    data1.img  = @"businessSmallIcon";
//    data1.time = @"20:29";
//    data1.tag = @"IT";
//    data1.content = @"今天天气不错，晚上吃什么好呢。";
//    [self.array addObject:data1];
//    
//    CZTestData *data2 = [[CZTestData alloc]init];
//    data2.img  = @"businessSmallIcon";
//    data2.time = @"20:29";
//    data2.tag = @"开房";
//    data2.content = @"中午谁有时间  一起去集贸看看？";
//    [self.array addObject:data2];
    [tableView reloadData];
}
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

@end
