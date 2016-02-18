//
//  CZButtonView.m
//  rc
//
//  Created by AlanZhang on 16/2/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZButtonView.h"
#import "Masonry.h"
@implementation CZButtonView

+(instancetype) buttonView
{
    CZButtonView *buttonView = [[CZButtonView alloc]initWithFrame:CGRectMake(0, 0, 30, 35)];
    
    buttonView.tagButton = [[UIButton alloc]init];
    buttonView.tagButton.tag = 1;
    [buttonView addSubview:buttonView.tagButton];
    
    buttonView.line = [[UIView alloc]init];
    buttonView.line.tag = 2;
    [buttonView addSubview:buttonView.line];
    
    [buttonView addsubviewConstraints];
    return buttonView;
}
- (id)initWithTittle:(NSString *)tittle
{
    if (self = [super init])
    {
        UIColor *selectedColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0] ;
        UIColor *noSelectedColor = [UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.6] ;
        self.tagButton = [[UIButton alloc]init];
        self.tagButton.tag = 11;
        [self.tagButton setTitleColor:selectedColor forState:UIControlStateSelected];
        [self.tagButton setTitleColor:noSelectedColor forState:UIControlStateNormal];
        [self.tagButton setTitle:tittle forState:UIControlStateNormal];
        [self.tagButton setTitle:tittle forState:UIControlStateSelected];
        self.tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.tagButton];
        
        self.line = [[UIView alloc]init];
        self.line.tag = 12;
        self.line.backgroundColor = selectedColor;
        
        [self addSubview:self.line];
        
        [self addsubviewConstraints];
    }
    return self;
}

- (void)addsubviewConstraints
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
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