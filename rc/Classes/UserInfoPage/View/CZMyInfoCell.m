//
//  CZMyInfoCell.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyInfoCell.h"
@implementation CZMyInfoCell

+ (instancetype) myInfoCellWithTableView :(UITableView *)tableView
{
    static NSString *reuseId = @"CZMyInfoCell";
    CZMyInfoCell *cell = (CZMyInfoCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
   
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //创建子控件
        self.imgIcon = [[UIImageView alloc]init];
        self.contentLable = [[UILabel alloc]init];
        self.contentLable.font = [UIFont systemFontOfSize:14];
        self.contentLable.alpha = 0.8;
        self.indicatorImageView = [[UIImageView alloc]init];
        
        [self.contentView addSubview:self.imgIcon];
        [self.contentView addSubview:self.contentLable];
        [self.contentView addSubview:self.indicatorImageView];
        
    }
    return self;
}

@end
