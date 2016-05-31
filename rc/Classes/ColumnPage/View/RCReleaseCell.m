//
//  RCReleaseCell.m
//  rc
//
//  Created by AlanZhang on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCReleaseCell.h"
#import "Masonry.h"
#define FONTSIZE 14
@implementation RCReleaseCell

- (id)init
{
    if (self = [super init])
    {
        
        //创建子控件
        self.imgIcon = [[UIImageView alloc]init];
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.imgIcon];
        [self.contentView addSubview:self.label];
        self.imgIcon.layer.cornerRadius = 25;
        self.imgIcon.layer.masksToBounds = YES;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setSubViewsConstraint
{
    
    [self.imgIcon  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    self.label.font = [UIFont systemFontOfSize:FONTSIZE];
    CGSize maxSize = CGSizeMake(kScreenWidth - 55, 20);
    CGSize releaserLable = [self sizeWithText:self.label.text maxSize:maxSize fontSize:FONTSIZE];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgIcon.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((int)releaserLable.width+1, (int)releaserLable.height+1));
    }];
    
}
/**
 *  计算字符串的长度
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end