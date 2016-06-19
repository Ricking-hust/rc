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
        UILabel *place = [[UILabel alloc]init];
        self.placeLabel = place;
        self.placeLabel.numberOfLines = 0;
        self.placeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.placeLabel];
        
        UILabel *size = [[UILabel alloc]init];
        self.sizeLabel = size;
        self.sizeLabel.numberOfLines = 0;
        self.sizeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.sizeLabel];
        
        UILabel *pay = [[UILabel alloc]init];
        self.payLabel = pay;
        self.payLabel.numberOfLines = 0;
        self.payLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.payLabel];
        
        UILabel *speaker = [[UILabel alloc]init];
        self.speakerLabel = speaker;
        self.speakerLabel.numberOfLines = 0;
        self.speakerLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.speakerLabel];
        
        UILabel *placeLabel = [[UILabel alloc]init];
        self.ac_placeLabel = placeLabel;
        self.ac_placeLabel.numberOfLines = 0;
        self.ac_placeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.ac_placeLabel];
        
        UILabel *sizeLabel = [[UILabel alloc]init];
        self.ac_sizeLabel = sizeLabel;
        self.ac_sizeLabel.numberOfLines = 0;
        self.ac_sizeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.ac_sizeLabel];
        
        UILabel *payLabel = [[UILabel alloc]init];
        self.ac_payLabel = payLabel;
        self.ac_payLabel.numberOfLines = 0;
        self.ac_payLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.ac_payLabel];
        
        UILabel *speakerLabel = [[UILabel alloc]init];
        self.ac_speakerLabel = speakerLabel;
        self.ac_speakerLabel.numberOfLines = 0;
        self.ac_speakerLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        [self.contentView addSubview:self.ac_speakerLabel];
    }
    return self;
    
}

- (void)setSubViewsConstraint
{
    if (self.model)
    {
        CGSize maxSize = CGSizeMake(kScreenWidth - 55, MAXFLOAT);

        CGSize labelSize = [self sizeWithText:self.placeLabel.text maxSize:maxSize fontSize:FONTSIZE];
        CGSize speakerlabelSize = [self sizeWithText:self.speakerLabel.text maxSize:maxSize fontSize:FONTSIZE];
        [self.placeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).with.offset(PADDING);
            make.width.mas_equalTo((int)labelSize.width+1);
            make.height.mas_equalTo((int)labelSize.height+1);
        }];
        [self.sizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ac_placeLabel.mas_bottom).with.offset(PADDING);
            make.left.equalTo(self.placeLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake((int)labelSize.width+1, (int)labelSize.height+1));
        }];
        [self.speakerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ac_sizeLabel.mas_bottom).with.offset(PADDING);
            make.left.equalTo(self.placeLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake((int)speakerlabelSize.width+1, (int)labelSize.height+1));
        }];
        [self.payLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ac_speakerLabel.mas_bottom).with.offset(PADDING);
            make.left.equalTo(self.placeLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake((int)labelSize.width+1, (int)labelSize.height+1));
        }];
        
        //添加地点标签约束
        
        CGSize placeSize = [self sizeWithText:self.ac_placeLabel.text maxSize:maxSize fontSize:FONTSIZE];
        [self.ac_placeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.placeLabel.mas_right);
            make.top.equalTo(self.placeLabel.mas_top);
            make.width.mas_equalTo((int)placeSize.width+1);
            make.height.mas_equalTo((int)placeSize.height+1);
        }];
        
        //添加规模标签约束
        CGSize scaleSize = [self sizeWithText:self.ac_sizeLabel.text maxSize:maxSize fontSize:FONTSIZE];
        [self.ac_sizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sizeLabel.mas_top);
            make.left.equalTo(self.sizeLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake((int)scaleSize.width+1, (int)scaleSize.height+1));
        }];
        //添加主讲人标签约束
        CGSize speakerMaxSize = CGSizeMake(kScreenWidth - 75, MAXFLOAT);
        CGSize realSize = [self sizeWithText:self.ac_speakerLabel.text maxSize:speakerMaxSize fontSize:FONTSIZE];
        CGSize speakerSize = [self sizeWithText:self.ac_speakerLabel.text maxSize:speakerMaxSize fontSize:FONTSIZE];
        if (realSize.width > kScreenWidth) {
            //标签行数大于1
            NSString *poetryString = self.ac_speakerLabel.text;
            NSMutableAttributedString *muAttrString  = [[NSMutableAttributedString alloc] initWithString:poetryString];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment =NSTextAlignmentJustified;//两端对齐
            NSDictionary *dic = @{
                                  NSForegroundColorAttributeName:[UIColor blackColor],
                                  NSFontAttributeName:[UIFont systemFontOfSize:FONTSIZE],
                                  NSParagraphStyleAttributeName:paragraphStyle,
                                  NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]
                                  };
            [muAttrString setAttributes:dic range:NSMakeRange(0, muAttrString.length)];
            NSAttributedString *attrString = [muAttrString copy];
            self.ac_speakerLabel.attributedText = attrString;
        }
        [self.ac_speakerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.speakerLabel.mas_right);
            make.top.equalTo(self.ac_sizeLabel.mas_bottom).with.offset(PADDING);
            make.size.mas_equalTo(CGSizeMake((int)speakerSize.width+1, (int)speakerSize.height+1));
        }];
        //添加费用标签约束
        CGSize paySize = [self sizeWithText:self.ac_payLabel.text maxSize:maxSize fontSize:FONTSIZE];
        [self.ac_payLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.payLabel.mas_right);
            make.top.equalTo(self.ac_speakerLabel.mas_bottom).with.offset(PADDING);
            make.size.mas_equalTo(CGSizeMake((int)paySize.width+1, (int)paySize.height+1));
        }];

    }
}

- (void) setModel:(ActivityModel *)model
{
    _model = model;
    if (_model)
    {
        self.ac_placeLabel.text = model.acPlace;
        self.ac_sizeLabel.text  = model.acSize;
        self.ac_speakerLabel.text = model.acDesc;
        self.ac_payLabel.text = model.acPay;
        self.placeLabel.text = @"地点: ";
        self.sizeLabel.text = @"规模: ";
        self.speakerLabel.text = @"主讲人: ";
        self.payLabel.text = @"费用: ";
    }

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
