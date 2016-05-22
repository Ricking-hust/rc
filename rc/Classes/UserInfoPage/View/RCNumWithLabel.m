//
//  RCNumWithLabel.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCNumWithLabel.h"
#import "Masonry.h"
@implementation RCNumWithLabel

- (id)init
{
    if (self = [super init])
    {
        self.label = [[UILabel alloc]init];
        self.numbers = [[UILabel alloc]init];
        [self addSubview:self.label];
        [self addSubview:self.numbers];
    }
    return self;
}
- (void)setConstraints
{
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    self.numbers.textColor = color;
    self.label.font = [UIFont systemFontOfSize:12];
    self.numbers.font = [UIFont systemFontOfSize:20];
    
    CGSize number_size = [self sizeWithText:self.numbers.text maxSize:CGSizeMake(MAXFLOAT, 22) fontSize:20];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numbers.mas_bottom).offset(2);
        make.centerX.equalTo(self.numbers.mas_centerX);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(24);
    }];
    [self.numbers mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo((int)number_size.width + 1);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22 + 15+2);
        make.width.mas_equalTo((int)number_size.width + 3);
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
