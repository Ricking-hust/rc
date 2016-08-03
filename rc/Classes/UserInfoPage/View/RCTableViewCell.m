//
//  RCTableViewCell.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCTableViewCell.h"
#import "Masonry.h"
@implementation RCTableViewCell
- (id)init
{
    if (self = [super init])
    {
        self.icon_imageView    = [[UIImageView alloc]init];
        self.text_label        = [[UILabel alloc]init];
        self.other_imageView   = [[UIImageView alloc]init];
        self.segment_line_view = [[UIView alloc]init];
        
        [self.contentView addSubview:self.icon_imageView];
        [self.contentView addSubview:self.text_label];
        [self.contentView addSubview:self.other_imageView];
        [self.contentView addSubview:self.segment_line_view];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)setConstraints
{
    self.text_label.font = [UIFont systemFontOfSize:14];
    [self.icon_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(self.icon_imageView.image.size);
    }];
    [self.text_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.icon_imageView.mas_right).offset(15);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(100);
    }];

    self.other_imageView.image = [UIImage imageNamed:@"nextIcon"];
    self.other_imageView.alpha = 0.7;
    [self.other_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.size.mas_equalTo(self.other_imageView.image.size);
    }];
    self.segment_line_view.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    [self.segment_line_view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(0.5);
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
