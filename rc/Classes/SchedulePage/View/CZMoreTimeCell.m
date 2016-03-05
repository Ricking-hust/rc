//
//  CZMoreTimeCell.m
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMoreTimeCell.h"

@implementation CZMoreTimeCell


+(instancetype)moreTimeCell
{
    CZMoreTimeCell *cell = [[CZMoreTimeCell alloc]init];
    cell.timeLable = [[UILabel alloc]init];
    [cell.contentView addSubview:cell.timeLable];
    
    cell.imgView = [[UIImageView alloc]init];
    cell.imgView.image = [UIImage imageNamed:@"selectedIcon"];
    [cell.contentView addSubview:cell.imgView];
    
    cell.imgView.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
