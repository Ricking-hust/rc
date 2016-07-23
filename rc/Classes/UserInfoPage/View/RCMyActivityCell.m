//
//  RCMyActivityCell.m
//  rc
//
//  Created by AlanZhang on 16/3/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyActivityCell.h"
#import "Masonry.h"
@implementation RCMyActivityCell
/**
 *  类方法 创建可重用的自定义的cell对象
 *
 *  @param tableView cell的所属的tableView
 *
 *  @return 返回实例对象
 */
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    
    static NSString *reuseId = @"myCollectionCell";
    RCMyActivityCell * cell = (RCMyActivityCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉Cell之间的分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //清除cell的点击状态
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.acImageView = [[UIImageView alloc]init];
        self.acName = [[UILabel alloc]init];
        self.acTime = [[UILabel alloc]init];
        self.acPlace = [[UILabel alloc]init];
        self.acTag = [[UILabel alloc]init];
        self.acTagImageView = [[UIImageView alloc]init];
        self.addSchedule = [[UIButton alloc]init];

    }
    [self setSubView];
    return self;

}
- (id)init
{
    if (self = [super init])
    {
        self.acImageView = [[UIImageView alloc]init];
        self.acName = [[UILabel alloc]init];
        self.acTime = [[UILabel alloc]init];
        self.acPlace = [[UILabel alloc]init];
        self.acTag = [[UILabel alloc]init];
        self.acTagImageView = [[UIImageView alloc]init];
        self.addSchedule = [[UIButton alloc]init];
    }
    [self setSubView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)setSubView
{
    self.acName.font = [UIFont systemFontOfSize:13];
    self.acTime.font = [UIFont systemFontOfSize:13];
    self.acPlace.font = [UIFont systemFontOfSize:13];
    self.acTag.font = [UIFont systemFontOfSize:11];
    self.acTime.alpha = 0.6;
    self.acPlace.alpha = 0.6;
    self.acTag.alpha = 0.6;
    self.acName.numberOfLines = 0;
    self.acTime.numberOfLines = 0;
    self.acPlace.numberOfLines = 0;
    self.acTag.numberOfLines = 0;
    self.acTagImageView.image = [UIImage imageNamed:@"tagImage"];
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    self.addSchedule.backgroundColor = color;
    self.addSchedule.layer.cornerRadius = 3.0f;
    [self.addSchedule setTintColor:[UIColor whiteColor]];
    self.addSchedule.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.acImageView];
    [self.contentView addSubview:self.acName];
    [self.contentView addSubview:self.acTime];
    [self.contentView addSubview:self.acPlace];
    [self.contentView addSubview:self.acTag];
    [self.contentView addSubview:self.acTagImageView];
    [self.contentView addSubview:self.addSchedule];
}
- (void)setSubViewConstraint
{
    //CGSize maxSize = CGSizeMake(kScreenWidth - 120, MAXFLOAT);
    CGFloat sizeW = kScreenWidth - 120 - 32;
    //CGSize acNameSize = [self sizeWithText:self.acName.text maxSize:maxSize fontSize:13];
    [self.acName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.width.mas_equalTo(sizeW);
        make.height.mas_equalTo(20);
    }];
    //CGSize acTimeSize = [self sizeWithText:self.acTime.text maxSize:maxSize fontSize:13];
    [self.acTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acName.mas_bottom).offset(10);
        make.left.equalTo(self.acName.mas_left);
        make.width.mas_equalTo(sizeW);
        make.height.mas_equalTo(20);
    }];
    //CGSize acPlaceSize = [self sizeWithText:self.acPlace.text maxSize:maxSize fontSize:13];
    [self.acPlace mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acName.mas_left);
        make.top.equalTo(self.acTime.mas_bottom);
        make.width.mas_equalTo(sizeW);
        make.height.mas_equalTo(20);
    }];
    [self.acTagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acName.mas_left);
        make.top.equalTo(self.acPlace.mas_bottom).offset(15);
        make.size.mas_equalTo(self.acTagImageView.image.size);
    }];
    //CGSize acTagSize = [self sizeWithText:self.acTag.text maxSize:maxSize fontSize:11];
    [self.acTag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acTagImageView.mas_right).offset(7);
        make.top.equalTo(self.acTagImageView.mas_top).offset(-5);
//        make.width.mas_equalTo(sizeW-40);
        make.right.equalTo(self.contentView.mas_right).offset(-85);
        make.height.mas_equalTo(20);
    }];

    [self.acImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(110);
    }];
    [self.addSchedule mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(63);
        make.height.mas_equalTo(21);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.acTag.mas_bottom);
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
