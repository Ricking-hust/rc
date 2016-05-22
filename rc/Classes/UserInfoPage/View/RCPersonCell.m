//
//  RCPersonCell.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCPersonCell.h"
#import "Masonry.h"
@implementation RCPersonCell

-(id)init
{
    if (self = [super init])
    {
        self.person_icon_imageView = [[UIImageView alloc]init];
        self.person_signature_lable = [[UILabel alloc]init];
        self.person_ID_lable = [[UILabel alloc]init];
        
        [self.contentView addSubview:self.person_icon_imageView];
        [self.contentView addSubview:self.person_ID_lable];
        [self.contentView addSubview:self.person_signature_lable];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)setConstraint
{
    self.person_icon_imageView.layer.cornerRadius = 42;
    self.person_icon_imageView.layer.masksToBounds = YES;
    [self.person_icon_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
      
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(84, 84));
    }];
    self.person_ID_lable.font = [UIFont systemFontOfSize:12];
    CGSize ID_size = [self sizeWithText:self.person_ID_lable.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:12];
    
    [self.person_ID_lable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.person_icon_imageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.person_icon_imageView.mas_centerX);
        make.height.mas_equalTo((int)ID_size.height + 1);
        make.width.mas_equalTo((int)ID_size.width+1);
    }];
    
    self.person_signature_lable.font = [UIFont systemFontOfSize:12];
    CGSize signature_size = [self sizeWithText:self.person_signature_lable.text maxSize:CGSizeMake(kScreenWidth - 40, 15) fontSize:12];
    [self.person_signature_lable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.person_ID_lable.mas_bottom).offset(8);
        make.centerX.equalTo(self.person_icon_imageView.mas_centerX);
        make.height.mas_equalTo((int)signature_size.height + 1);
        make.width.mas_equalTo((int)signature_size.width + 1);
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
