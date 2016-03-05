
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
        self.scNameLabel = [[UILabel alloc]init];
        self.tagWithImgView = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:@"bg_background1"];
        self.scNameH = image.size.height;
        self.height = self.scNameH;
        self.scNameLabel.numberOfLines = 0;
        
        [self addSubview:self.tagWithImgView];
        [self.tagWithImgView addSubview:self.img];
        [self.tagWithImgView addSubview:self.tagLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.scNameLabel];
        [self setSubViewStyle];
    }
    return self;
}
- (void)setSubViewStyle
{
    self.tagLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.scNameLabel.font = [UIFont systemFontOfSize:14];
}
- (void)setScNameLabel:(UILabel *)scNameLabel
{
    _scNameLabel = scNameLabel;
}
- (void)addSubViewConstraint
{
    [self.tagWithImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(18);
        make.width.mas_equalTo(self.img.image.size.width);
        make.height.mas_equalTo(self.img.image.size.height + 25);
    }];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagWithImgView.mas_top);
        make.left.equalTo(self.tagWithImgView.mas_left);
        make.width.mas_equalTo(self.img.image.size.width);
        make.height.mas_equalTo(self.img.image.size.height);
    }];

    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.img.mas_centerX);
        make.top.equalTo(self.img.mas_bottom);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(25);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.img.mas_right).offset(12);
        make.top.equalTo(self.mas_top).offset(12);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(17);
    }];
    
    CGFloat scNameW = kScreenWidth - 30 - 75 - self.img.image.size.width - 18 - 30;
    CGFloat scNameH = [self sizeWithText:self.scNameLabel.text maxSize:CGSizeMake(scNameW, MAXFLOAT) fontSize:14].height;
    [self.scNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.width.mas_equalTo(scNameW);
        make.height.mas_equalTo(scNameH+1);
    }];
    self.height = scNameH + 17 +12 + 12;
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
@end
