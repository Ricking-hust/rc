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

@implementation CZTimeTableViewDelegate

- (id)init
{
    if (self = [super init])
    {
        self.height = 0;
        self.scrollH = 10000;
        self.isUp = NO;
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
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTimeNodeCell *cell = [[CZTimeNodeCell alloc]init];
    //对cell进行赋值
    [self setValueToCell:cell];
    //对cell进行布局
    [self addCellConstraint:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.height;
}
- (void)setValueToCell:(CZTimeNodeCell *)cell
{
    cell.dayLabel.text = @"12.14";
    cell.weekLabel.text = @"星期一";
}
- (void)addCellConstraint:(CZTimeNodeCell *)cell
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (int)scrollView.contentOffsetY / self.height;
    if (index > self.indexAtCell)
    {//上拉
        self.indexAtCell++;
        self.isUp = NO;
        //NSLog(@"上拉 %d",self.indexAtCell);
        //reflesh scTableView---------
        [self updateDataSoucre:self.array];
        [self.scTableView reloadData];
    }
    int flag = scrollView.contentOffsetY / self.height;
    if (flag < self.indexAtCell)
    {
        self.isUp = YES;
    }

    if ((int)scrollView.contentOffsetY % (int)self.height == 0 && self.isUp)
    {//下拉
        self.indexAtCell = (int)scrollView.contentOffsetY / (int)self.height;
        if (self.indexAtCell == 0)
        {
            self.isUp = NO;
        }
        //NSLog(@"下拉 %d",self.indexAtCell);
        //reflesh scTableView---------
        [self updateDataSoucre:self.array];
        [self.array removeObjectAtIndex:0];
        [self.scTableView reloadData];
    }
}
- (void)updateDataSoucre:(NSMutableArray *)array
{
    [self.array removeAllObjects];
    CZTestData *data1 = [[CZTestData alloc]init];
    data1.img  = @"businessSmallIcon";
    data1.time = @"20:29";
    data1.tag = @"鬼混";
    data1.content = @"@property (nonatomic, strong)";
    [self.array addObject:data1];
    
    CZTestData *data2 = [[CZTestData alloc]init];
    data2.img  = @"businessSmallIcon";
    data2.time = @"03：20";
    data2.tag = @"瞎搞";
    data2.content = @"sizeWithText:(NSString *)text";
    [self.array addObject:data2];
    
}
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

@end
