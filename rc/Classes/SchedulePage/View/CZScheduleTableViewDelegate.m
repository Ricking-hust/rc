//
//  CZScheduleTableViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZScheduleTableViewDelegate.h"
#import "CZScheduleInfoCell.h"
#import "Masonry.h"

@implementation CZScheduleTableViewDelegate

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else
    {
        CZScheduleInfoCell *cell = [[CZScheduleInfoCell alloc]init];
        //对cell进行赋值
        [self setValueToCell:cell];
        //对cell进行布局
        [self addCellConstraint:cell];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 35;
    }else
    {
        if (self.device == IPhone5)
        {
            return 120;
        }else if (self.device == IPhone6)
        {
            return 120;
        }else
        {
            return 120;
        }   
    }
}
- (void)setValueToCell:(CZScheduleInfoCell *)cell
{
    cell.tagImageView.image = [UIImage imageNamed:@"businessSmallIcon"];
    cell.tagLabel.text = @"出差";
    cell.timeLabel.text = @"12:11";
    cell.contentLabel.text = @"今天天气这么好，我们要吃什么呢，要去去吃麻辣烫?";
}
- (void)addCellConstraint:(CZScheduleInfoCell *)cell
{
    UIImage *image = [UIImage imageNamed:@"bg_background1"];
    [cell.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.mas_equalTo(image.size.height);
    }];
    [cell.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.bgView.mas_left).offset(18);
        make.centerY.equalTo(cell.bgView.mas_centerY).offset(-10);
        make.size.mas_equalTo(cell.tagImageView.image.size);
    }];

    [cell.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.tagImageView.mas_bottom);
        make.centerX.equalTo(cell.tagImageView.mas_centerX);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(25);
    }];

    CGSize size = [self sizeWithText:cell.timeLabel.text maxSize:CGSizeMake(100, 100) fontSize:14];
    [cell.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.tagImageView.mas_top);
        make.left.equalTo(cell.tagImageView.mas_right).offset(12);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(17);
    }];
//    if (size.height > 17)
//    {
//        [cell.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(size.height+1 + );
//        }];
//    }
}
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}
@end
