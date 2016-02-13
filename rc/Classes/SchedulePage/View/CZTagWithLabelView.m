//
//  CZTagWithLabelView.m
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTagWithLabelView.h"
#import "Masonry.h"

#define FONTSIZE    14
@implementation CZTagWithLabelView

+ (instancetype)tagWithLabel
{
    CZTagWithLabelView *tag = [[CZTagWithLabelView alloc]init];
    tag.tagButton = [[UIButton alloc]init];
    [tag addSubview:tag.tagButton];
    
    tag.label = [[UILabel alloc]init];
    [tag addSubview:tag.label];
    
    return tag;
}
- (id)initWithImage:(UIImage *)img andTittle:(NSString *)tittle
{
    if (self = [super init])
    {
        self.tagButton = [[UIButton alloc]init];
        self.label = [[UILabel alloc]init];
        [self addSubview:self.tagButton];
        [self addSubview:self.label];
        self.tagButton.tag = 9;
        self.label.tag = 10;
        self.label.text = tittle;
        [self.tagButton setImage:img forState:UIControlStateNormal];
        
        [self addsubviewConstraints:tittle];
    }
    return self;
}
- (void)addsubviewConstraints:(NSString *)tittle;
{
    CGSize labelSize = [self setLabelStyle:self.label WithContent:tittle];
    CGSize tagButtonSize = self.tagButton.imageView.image.size;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(tagButtonSize.width, tagButtonSize.height+labelSize.height+5));
    }];
    
    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self);
        make.size.mas_equalTo(self.tagButton.imageView.image.size);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tagButton.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(labelSize.width+1, labelSize.height+1));
    }];
}
//设置标签的样式
- (CGSize)setLabelStyle:(UILabel *)label WithContent:(NSString *)content
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    label.font = [UIFont systemFontOfSize:FONTSIZE];
    label.numberOfLines = 0;
    label.text = content;
    CGSize size = [self sizeWithText:content maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];
    
    return size;
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
