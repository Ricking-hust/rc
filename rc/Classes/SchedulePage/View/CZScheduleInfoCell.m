

//
//  CZScheduleInfoCell.m
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZScheduleInfoCell.h"

@implementation CZScheduleInfoCell

- (id)init
{
    if (self = [super init])
    {
        self.tagImageView = [[UIImageView alloc]init];
        self.tagLabel = [[UILabel alloc]init];
        self.placeLabel = [[UILabel alloc]init];
        self.timeLabel = [[UILabel alloc]init];
        self.contentLabel = [[UILabel alloc]init];
        self.bgView = [[UIView alloc]init];
        [self addsubViewToContentView];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void)addsubViewToContentView
{
    self.tagLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.placeLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
    [self.bgView addSubview:self.tagImageView];
    [self.bgView addSubview:self.tagLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.placeLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.contentView addSubview:self.bgView];
    UIImage *image = [UIImage imageNamed:@"bg_background1"];
    self.bgView.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
    self.bgView.layer.backgroundColor = [UIColor clearColor].CGColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
