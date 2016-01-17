//
//  CZActivityInfoCell.m
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityInfoCell.h"
#import "ActivityIntroduction.h"
#import "Masonry.h"
#define LABEL_FONTSIZE 14

@implementation CZActivityInfoCell

+ (instancetype)activityCellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"activityInfoCell";
    CZActivityInfoCell * cell = (CZActivityInfoCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.rowHeight = 190.0/2;
    return cell;

}



- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件

        UILabel *placeLabel = [[UILabel alloc]init];
        self.ac_placeLabel = placeLabel;
        [self.contentView addSubview:self.ac_placeLabel];

        UILabel *sizeLabel = [[UILabel alloc]init];
        self.ac_sizeLabel = sizeLabel;
        [self.contentView addSubview:self.ac_sizeLabel];
        
        UILabel *payLabel = [[UILabel alloc]init];
        self.ac_payLabel = payLabel;
        [self.contentView addSubview:self.ac_payLabel];
    }
    return self;

}

- (void)setAcIntroduction:(ActivityIntroduction *)acIntroduction
{
    _acIntroduction = acIntroduction;
    [self setSubViewsContent];
    [self setSubViewsConstraint];
    
}
- (void)setSubViewsContent
{
    self.ac_placeLabel.text = self.acIntroduction.ac_place;
    self.ac_placeLabel.font = [UIFont systemFontOfSize:LABEL_FONTSIZE];
    
    self.ac_sizeLabel.text = self.acIntroduction.ac_size;
    self.ac_sizeLabel.font = [UIFont systemFontOfSize:LABEL_FONTSIZE];
    
    self.ac_payLabel.text = self.acIntroduction.ac_pay;
    self.ac_payLabel.font = [UIFont systemFontOfSize:LABEL_FONTSIZE];
}
- (void)setSubViewsConstraint
{
    //添加地点标签约束
    CGSize placeSize = [self sizeWithText:self.ac_placeLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:LABEL_FONTSIZE];
    [self.ac_placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(28.0/2);
        make.size.mas_equalTo(placeSize);
    }];
    //添加规模标签约束
    CGSize scaleSize = [self sizeWithText:self.ac_sizeLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:LABEL_FONTSIZE];
    [self.ac_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ac_placeLabel.mas_bottom).with.offset(22.0/2);
        make.left.equalTo(self.ac_placeLabel.mas_left);
        make.size.mas_equalTo(scaleSize);
    }];
    //添加费用标签约束
    CGSize paySize = [self sizeWithText:self.ac_payLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:LABEL_FONTSIZE];
    [self.ac_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ac_placeLabel.mas_left);
        make.top.equalTo(self.ac_sizeLabel.mas_bottom).with.offset(22.0/2);
        make.size.mas_equalTo(paySize);
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end