
//
//  CZScheduleInfoView.m
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//
#import "Masonry.h"
#import "CZScheduleInfoView.h"

@implementation CZScheduleInfoView

- (id)init
{
    if (self = [super init])
    {
        self.img = [[UIImageView alloc]init];
        self.tagLabel = [[UILabel alloc]init];
        self.timeLabel = [[UILabel alloc]init];
        self.contentLabel = [[UILabel alloc]init];
        [self addSubview:self.img];
        [self addSubview:self.tagLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.contentLabel];
    }
    return self;
}
- (void)setSubViewStyle
{
    self.tagLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
}
- (void)addSubViewConstraint
{
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(9);
        make.left.equalTo(self.mas_left).offset(9);
    }];
}
@end
