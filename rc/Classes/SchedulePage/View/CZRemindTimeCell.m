//
//  CZRemindTimeCell.m
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZRemindTimeCell.h"

@implementation CZRemindTimeCell

+ (instancetype)remindTimeCell
{
    CZRemindTimeCell *cell = [[CZRemindTimeCell alloc]init];
    
    cell.label = [[UILabel alloc]init];
    cell.label.text = @"提醒时间点";
    cell.label.alpha = 0.3;
    [cell.contentView addSubview:cell.label];
    
    cell.time = [[UILabel alloc]init];
    cell.time.text = @"19点";
    cell.time.alpha = 0.3;
    [cell.contentView addSubview:cell.time];
    
    cell.timeButton = [[UIButton alloc]init];
    [cell.timeButton setImage:[UIImage imageNamed:@"nextIcon"] forState:UIControlStateNormal];
    cell.timeButton.enabled = NO;
    
    [cell.contentView addSubview:cell.timeButton];
    cell.selectionStyle =UITableViewCellSelectionStyleNone ;
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
