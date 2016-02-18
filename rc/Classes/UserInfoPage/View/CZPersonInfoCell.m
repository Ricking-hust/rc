



//
//  CZPersonInfoCell.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZPersonInfoCell.h"

@implementation CZPersonInfoCell

+ (instancetype)personInfoCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CZMyInfoCell";
    CZPersonInfoCell *cell = (CZPersonInfoCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.tittle = [[UILabel alloc]init];
        self.tittle.font = [UIFont systemFontOfSize:14];
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.personIcon = [[UIImageView alloc]init];
        self.indecatorImageView = [[UIImageView alloc]init];
        
        [self.contentView addSubview:self.tittle];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.personIcon];
        [self.contentView addSubview:self.indecatorImageView];
        
    }
    return self;
}

@end
