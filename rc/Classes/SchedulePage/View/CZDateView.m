//
//  CZDateView.m
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZDateView.h"
#import "Masonry.h"

@implementation CZDateView

- (id)init
{
    if (self = [super init])
    {
        self.month = [[UILabel alloc]init];
        self.week = [[UILabel alloc]init];

        [self addSubview:self.month];
        [self addSubview:self.week];
    }
    return self;
}
- (void)addSubViewConstraint
{
    self.month.font = [UIFont systemFontOfSize:18];
    self.month.textColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    self.week.font = [UIFont systemFontOfSize:10];
    self.week.textColor = self.month.textColor;
    NSLog(@"%@",self.month.text);
    CGSize monthSize = [self sizeWithText:self.month.text maxSize:CGSizeMake(60, 20) fontSize:18];
    CGSize weekSize = [self sizeWithText:self.week.text maxSize:CGSizeMake(60, 20) fontSize:10];
    NSLog(@"month w %f,h %f",monthSize.width , monthSize.height);
    NSLog(@"week w %f,h %f",weekSize.width , weekSize.height);

    [self.month mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(21);
    }];
    [self.week mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.month.mas_centerX);
        make.top.equalTo(self.month.mas_bottom);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];}
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
