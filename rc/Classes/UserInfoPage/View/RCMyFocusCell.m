//
//  RCMyFocusCell.m
//  rc
//
//  Created by LittleMian on 16/6/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyFocusCell.h"
#import "RCMyFocusModel.h"
#import "Masonry.h"
@implementation RCMyFocusCell
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"fansCell";
    RCMyFocusCell * cell = (RCMyFocusCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //清除cell的点击状态
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userImageView = [[UIImageView alloc]init];
        self.userNameLabel = [[UILabel alloc]init];
        self.segmentView = [[UIView alloc]init];
        self.isLastCell = NO;
        [self.contentView addSubview:self.userImageView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.segmentView];
        
    }
    return self;
}
- (void)setModel:(RCMyFocusModel *)model
{
    _model = model;
    if (_model != nil)
    {
        self.userImageView.layer.cornerRadius = 35.0/2.0f;
        self.userImageView.layer.masksToBounds = YES;
        NSURL *urlImg = [NSURL URLWithString:_model.usr_pic];
        [self.userImageView sd_setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"logo"]];
        [self.userImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(35);
        }];
        self.userNameLabel.text = _model.usr_name;
        self.userNameLabel.font = [UIFont systemFontOfSize:14];
        CGSize nameLabelSize = [self sizeWithText:self.userNameLabel.text maxSize:CGSizeMake(200, 30) fontSize:14];
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.userImageView.mas_right).offset(16);
            make.height.mas_equalTo((int)nameLabelSize.height + 1);
            make.width.mas_equalTo((int)nameLabelSize.width + 1);
        }];
        self.segmentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        if (self.isLastCell == NO)
        {
            [self.segmentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userImageView.mas_left);
                make.right.equalTo(self.contentView.mas_right);
                make.height.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
            }];
        }else
        {
            ;
        }
    }
}

/**
 *  计算文本的大小
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
