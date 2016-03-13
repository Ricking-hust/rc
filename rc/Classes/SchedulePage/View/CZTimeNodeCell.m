

//
//  CZTimeNodeCell.m
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTimeNodeCell.h"

@implementation CZTimeNodeCell


- (id)init
{
    if (self = [super init])
    {
        self.upLineView = [[UIView alloc]init];
        self.downLineView = [[UIView alloc]init];
        self.point = [[UIView alloc]init];
        self.selectedPoint = [[UIImageView alloc]init];
        self.weekLabel = [[UILabel alloc]init];
        self.dayLabel = [[UILabel alloc]init];
        [self addsubViewToContentView];
        self.cellIndex = 0;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void)addsubViewToContentView
{
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];

    self.upLineView.backgroundColor = color;
    self.downLineView.backgroundColor = color;
    self.point.backgroundColor = color;
    self.weekLabel.textColor = color;
    self.dayLabel.textColor = color;
    self.weekLabel.font = [UIFont systemFontOfSize:10];
    self.dayLabel.font = [UIFont systemFontOfSize:13];
    self.point.layer.cornerRadius = 7;
    self.selectedPoint.image = [UIImage imageNamed:@"currentPoint"];
    [self.contentView addSubview:self.upLineView];
    [self.contentView addSubview:self.downLineView];
    [self.contentView addSubview:self.point];
    [self.contentView addSubview:self.selectedPoint];
    [self.contentView addSubview:self.weekLabel];
    [self.contentView addSubview:self.dayLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
