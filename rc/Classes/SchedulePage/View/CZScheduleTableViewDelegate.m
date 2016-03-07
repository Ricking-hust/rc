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
#import "CZTestData.h"
#import "PlanModel.h"

@implementation CZScheduleTableViewDelegate

- (id)init
{
    if (self = [super init])
    {
        
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
    return self.array.count+1;
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
        [self setValueToCell:cell AtIndexPath:indexPath];
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
        CZScheduleInfoCell *cell = (CZScheduleInfoCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
}
- (void)setValueToCell:(CZScheduleInfoCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    planModel *plmodel = self.array[indexPath.row-1];
    cell.tagImageView.image = [UIImage imageNamed:@""];
    cell.tagLabel.text = plmodel.themeName;
    cell.timeLabel.text = plmodel.planTime;
    cell.contentLabel.text = plmodel.planContent;
    cell.placeLabel.text = plmodel.acPlace;
}
- (void)addCellConstraint:(CZScheduleInfoCell *)cell
{
    //75表示界面左侧的tableView的宽度, 60表示cell中的各项间距
    CGFloat maxW = kScreenWidth - 75 - 60 - cell.tagImageView.image.size.width;
    CGSize size = [self sizeWithText:cell.contentLabel.text maxSize:CGSizeMake(maxW, MAXFLOAT) fontSize:14];

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

    [cell.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.bgView.mas_top).offset(12);
        make.left.equalTo(cell.tagImageView.mas_right).offset(12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(17);
    }];
    CGSize  placeSize = [self sizeWithText:cell.placeLabel.text maxSize:CGSizeMake(maxW, MAXFLOAT) fontSize:14];
    [cell.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.timeLabel.mas_bottom);
        make.left.equalTo(cell.timeLabel.mas_left);
        make.width.mas_equalTo(placeSize.width + 1);
        make.height.mas_equalTo(placeSize.height + 1);
    }];
    [cell.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.placeLabel.mas_bottom);
        make.left.equalTo(cell.timeLabel.mas_left);
        make.width.mas_equalTo(size.width+1);
        make.height.mas_equalTo(size.height+1);
    }];
    [cell.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.mas_equalTo(17 + 12 + size.height + placeSize.height + 12);
    }];
    //17表示timeLabel的高度，12为timeLabel的上边距，size.height表示内容的高度,placeSize.height表示地点的高度,12表示内容的下边距,15表示bgView的上下边距
    cell.height = 17 + 12 + size.height + placeSize.height + 12 + 15+15;

}
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}
@end
