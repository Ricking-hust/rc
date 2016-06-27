//
//  RCPersonNewsCell.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCPersonNewsCell.h"
#import "Masonry.h"
#include "RCNumWithLabel.h"
#import "RCNumWithLabel.h"
@implementation RCPersonNewsCell
- (id)init
{
    if (self = [super init])
    {
        self.fans  = [[RCNumWithLabel alloc]init];
        self.foucs = [[RCNumWithLabel alloc]init];
        self.news  = [[RCNumWithLabel alloc]init];
        
        [self.contentView addSubview:self.fans];
        [self.contentView addSubview:self.foucs];
        [self.contentView addSubview:self.news];

    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    return self;
}
- (void)setConstraint
{
    self.fans.label.text  = @"粉丝";
    self.fans.tag = 10;
    self.foucs.label.text = @"关注";
    self.foucs.tag = 11;
    self.news.label.text  = @"消息";
    self.news.tag = 12;
    [self.fans setConstraints];
    [self.fans mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth * 0.12);
    }];
    [self.foucs setConstraints];
    [self.foucs mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    [self.news setConstraints];
    [self.news mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth* 0.12);
    }];

}
/**
 *  计算字体的长和宽
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}
@end
