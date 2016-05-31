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
        make.width.mas_equalTo(tagButtonSize.width);
        //make.height.mas_equalTo(tagButtonSize.height + 22);
        make.height.mas_equalTo(0);
    }];
    
    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self);
        make.width.mas_equalTo(self.tagButton.imageView.image.size.width);
        //make.height.mas_equalTo(self.tagButton.imageView.image.size.height);
        make.height.mas_equalTo(0);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tagButton.mas_bottom).with.offset(5);
        make.width.mas_equalTo(labelSize.width+1);
        //make.height.mas_equalTo(17);
        make.height.mas_equalTo(0);
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
