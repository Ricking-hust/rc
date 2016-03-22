//
//  CZActivityInfoCell.m
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityInfoCell.h"
#import "Masonry.h"
#import "ActivityModel.h"

#define FONTSIZE 14
#define PADDING  10
@implementation CZActivityInfoCell

+ (instancetype)activityCellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"activityInfoCell";
    CZActivityInfoCell * cell = (CZActivityInfoCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件
    
    return cell;
    
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        UILabel *placeLabel = [[UILabel alloc]init];
        self.ac_placeLabel = placeLabel;
        self.ac_placeLabel.numberOfLines = 0;
        self.ac_placeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.ac_placeLabel];
        
        UILabel *sizeLabel = [[UILabel alloc]init];
        self.ac_sizeLabel = sizeLabel;
        self.ac_sizeLabel.numberOfLines = 0;
        self.ac_sizeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.ac_sizeLabel];
        
        UILabel *payLabel = [[UILabel alloc]init];
        self.ac_payLabel = payLabel;
        self.ac_payLabel.numberOfLines = 0;
        self.ac_payLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.ac_payLabel];

    }
    return self;
    
}

- (void)setSubViewsConstraint
{
    if (self.model)
    {
        //添加地点标签约束
        CGSize maxSize = CGSizeMake(kScreenWidth - 30, MAXFLOAT);
        CGSize placeSize = [self sizeWithText:self.ac_placeLabel.text maxSize:maxSize fontSize:FONTSIZE];
        [self.ac_placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).with.offset(PADDING);
            make.width.mas_equalTo(placeSize.width+1);
            make.height.mas_equalTo(placeSize.height+1);
        }];
        //添加规模标签约束
        CGSize scaleSize = [self sizeWithText:self.ac_sizeLabel.text maxSize:maxSize fontSize:FONTSIZE];
        [self.ac_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ac_placeLabel.mas_bottom).with.offset(PADDING);
            make.left.equalTo(self.ac_placeLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(scaleSize.width+1, scaleSize.height+1));
        }];
        //添加费用标签约束
        CGSize paySize = [self sizeWithText:self.ac_payLabel.text maxSize:maxSize fontSize:FONTSIZE];
        [self.ac_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ac_placeLabel.mas_left);
            make.top.equalTo(self.ac_sizeLabel.mas_bottom).with.offset(PADDING);
            make.size.mas_equalTo(CGSizeMake(paySize.width+1, paySize.height+1));
        }];

    }
}

- (void) setModel:(ActivityModel *)model
{
    _model = model;
    self.ac_placeLabel.text = model.acPlace;
    self.ac_sizeLabel.text  = model.acSize;
    self.ac_payLabel.text   = model.acPay;

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
