//
//  CZTimeCourseCell.m
//  rc
//
//  Created by AlanZhang on 16/2/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTimeCourseCell.h"
#import "CZData.h"
#import "Masonry.h"

@implementation CZTimeCourseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"TimeCourseCell";
    CZTimeCourseCell * cell = (CZTimeCourseCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉分割线
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件
    return cell;

}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        self.timeLine = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLine];
        
        self.currentPoint = [[UIImageView alloc]init];
        [self.contentView addSubview:self.currentPoint];
        
        self.tagImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.tagImg];
        
        self.tagLabel = [[UILabel alloc]init];
        self.tagLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.tagLabel];
        
        self.acTime = [[UILabel alloc]init];
        self.acTime.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.acTime];
        
        self.acContent = [[UILabel alloc]init];
        self.acContent.numberOfLines = 0;
        self.acContent.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.acContent];
        
        self.bgImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.bgImage];

    }
    return self;
}

- (void) setData:(CZData *)data
{
    _data = data;
    [self setSubViewsContent];
    [self setSubViewsConstaint];
}
- (void)setSubViewsContent
{
#pragma mark - test
    self.timeLine.backgroundColor = [UIColor redColor];
    
    self.currentPoint.image = [UIImage imageNamed:self.data.imgStr];
    self.tagImg.image = [UIImage imageNamed:self.data.tagStr];
    self.tagLabel.text = @"运动";
    self.acTime.text = @"12:23";
    self.acContent.text = self.data.contentStr;
    self.bgImage.image = [UIImage imageNamed:self.data.bgimgStr];
}
- (void)setSubViewsConstaint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat leftPadding = rect.size.width * 0.17;
    CGSize acTimeSize = [self sizeWithText:self.acTime.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    CGSize tagLabelSize = [self sizeWithText:self.tagLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    CGSize acContentSize = [self sizeWithText:self.acContent.text maxSize:CGSizeMake(rect.size.width * 0.68, MAXFLOAT) fontSize:14];
    CGFloat width = rect.size.width;
    CGFloat height = acTimeSize.height + acContentSize.height;
    self.cellSize = CGSizeMake(width, height);
    
    [self.timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(leftPadding-2);
        make.top.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(4, self.cellSize.height));
    }];
#pragma mark - 测试语句
    [self.acContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLine.mas_top).with.offset(10);
        make.left.equalTo(self.timeLine.mas_right).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(acContentSize.width+1, acContentSize.height+1));
    }];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLine.mas_right).with.offset(20);
        make.top.equalTo(self.timeLine.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
