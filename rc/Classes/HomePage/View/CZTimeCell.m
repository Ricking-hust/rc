//
//  CZTimeCell.m
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTimeCell.h"
#import "Masonry.h"
#define TIME_FONTSIZE   14  //活动时间字体大小
#define BTN_FONTSIZE    12  //按钮字体大小

@implementation CZTimeCell

+ (instancetype)timeCellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"activiyInstructionCell";
    CZTimeCell * cell = (CZTimeCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件
    cell.rowHeight = 94.0/2;
    
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        UILabel *label = [[UILabel alloc]init];
        self.timeLabel = label;
        self.timeLabel.font = [UIFont systemFontOfSize:TIME_FONTSIZE];
        [self.contentView addSubview:self.timeLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.remindMeBtn = btn;
        self.remindMeBtn.layer.cornerRadius = 3.0f;
        [self.remindMeBtn setTitle:@"提醒我" forState:UIControlStateNormal];
        self.remindMeBtn.titleLabel.font = [UIFont systemFontOfSize:BTN_FONTSIZE];
        [self.remindMeBtn setTintColor:[UIColor whiteColor]];
        [self.remindMeBtn setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:130.0/255.0  blue:4.0/255.0  alpha:1.0]];
        [self.contentView addSubview:self.remindMeBtn];
        
    }
    return self;

}

//设置子控件的约束
- (void)setSubViewsConstraint
{
    //添加时间标签约束
    CGSize timeSize = [self sizeWithText:self.timeLabel.text maxSize:CGSizeMake(200, MAXFLOAT) fontSize:TIME_FONTSIZE];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        
    }];
    //添加按钮约束
    [self.remindMeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(17.0/2);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
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
