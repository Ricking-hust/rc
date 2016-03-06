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

@implementation CZTimeTableViewDelegate

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
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
    //对cell进行赋值
    [self setValueToCell:cell];
    //对cell进行布局
    [self addCellConstraint:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.device == IPhone5)
    {
        return 105;
    }else if (self.device == IPhone6)
    {
        return 105;
    }else
    {
        return 105;
    }
    
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
    
    CGSize dayLabelSize = [self sizeWithText:cell.dayLabel.text maxSize:CGSizeMake(60, 20) fontSize:13];
    CGSize weekLabelSize = [self sizeWithText:cell.weekLabel.text maxSize:CGSizeMake(60, 20) fontSize:10];

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
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}




@end
