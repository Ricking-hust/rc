//
//  CZActivityCell.m
//  rc
//
//  Created by AlanZhang on 16/2/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivitycell.h"
#import "Masonry.h"
#import "ActivityModel.h"

#define TITLE_FONTSIZE  13  //活动主题字体大小
#define TIME_FONTSIZE   12  //活动时间字体大小
#define PLACE_FONTSIZE  12  //活动地点字体大小
#define TAG_FONTSIZE    11  //活动标签字体大小

@interface CZActivitycell()

@end

@implementation CZActivitycell


+ (instancetype)activitycellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"activityCell";
    CZActivitycell * cell = (CZActivitycell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉Cell之间的分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //清除cell的点击状态
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //1.创建ac_poster(UIImageView)
        UIImageView *imageView = [[UIImageView alloc]init];
        self.ac_poster = imageView;
        [self.contentView addSubview:self.ac_poster ];
        
        //2.创建ac_title(UILable)
        UILabel *nameLabel = [[UILabel alloc]init];
        self.ac_title = nameLabel;
        self.ac_title.numberOfLines = 0;
        self.ac_title.font = [UIFont systemFontOfSize:TITLE_FONTSIZE];
        [self.contentView addSubview:self.ac_title];
        
        
        //3.创建ac_time(UILable)
        UILabel *timeLabel = [[UILabel alloc]init];
        self.ac_time = timeLabel;
        self.ac_time.numberOfLines = 0;
        self.ac_time.font = [UIFont systemFontOfSize:TIME_FONTSIZE];
        [self.contentView addSubview:self.ac_time];
        self.ac_time.alpha = 0.8;
        
        //4.创建ac_place(UILable)
        UILabel *placeLabel = [[UILabel alloc]init];
        self.ac_place = placeLabel;
        self.ac_place.numberOfLines = 0;
        self.ac_place.font = [UIFont systemFontOfSize:PLACE_FONTSIZE];
        [self.contentView addSubview:self.ac_place];
        self.ac_place.alpha = 0.8;
        
        //5.创建ac_imageTag(UIImageView)
        UIImageView *tagImage = [[UIImageView alloc]init];
        self.ac_imageTag = tagImage;
        UIImage *Image = [UIImage imageNamed:@"tagImage"];
        self.ac_imageTag.image = Image;
        [self.contentView addSubview:self.ac_imageTag];
        
        //6.创建ac_tags(UILable)
        UILabel *tagsLabel = [[UILabel alloc]init];
        self.ac_tags = tagsLabel;
        self.ac_tags.numberOfLines = 0;
        self.ac_tags.font = [UIFont systemFontOfSize:TAG_FONTSIZE];
        [self.contentView addSubview:self.ac_tags];
        self.ac_tags.alpha = 0.8;
    }
    return self;
}

//设置子控件的Constraint
- (void)setSubViewsConstraint
{
    //最大宽度
    CGFloat maxfW = kScreenWidth - 120 - 35;
    //名字的上边距
    CGFloat tittleTopPadding = 12;
    //1.名字的高度
    CGSize nameSize = [self sizeWithText:self.ac_title.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:TITLE_FONTSIZE];
        //1.1时间与名字之间的间距
    CGFloat timePaddingToName = 10;
    //2.时间的高度
    CGSize timeSize = [self sizeWithText:self.ac_time.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:TIME_FONTSIZE];
    //3.地点的高度
    CGSize placeSize = [self sizeWithText:self.ac_place.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:PLACE_FONTSIZE];
        //3.1标签与地点之间的间距
    CGFloat tagPaddingToPlace = 10;
    //4.标签的高度
    CGSize tagSize = [self sizeWithText:self.ac_tags.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:TAG_FONTSIZE];
    //标签的下边距
    CGFloat tagBottomPadding = 12;
    
    //cell高度
    self.cellHeight = tittleTopPadding + nameSize.height + timeSize.height + placeSize.height + tagSize.height + timePaddingToName + tagPaddingToPlace + 15;
    [self.ac_poster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(120);
    }];
    [self.ac_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.left.equalTo(self.ac_poster.mas_right).offset(15);
        make.width.mas_equalTo(maxfW);
        make.height.mas_equalTo(20);
    }];
    [self.ac_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ac_title.mas_bottom).offset(20);
        make.left.equalTo(self.ac_title.mas_left);
        make.width.mas_equalTo(maxfW);
        make.height.mas_equalTo(17);
    }];
    [self.ac_place mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ac_time.mas_bottom);
        make.left.equalTo(self.ac_time.mas_left);
        make.width.mas_equalTo(maxfW);
        make.height.mas_equalTo(17);
    }];
    [self.ac_imageTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ac_place.mas_bottom).offset(20);
        make.left.equalTo(self.ac_time.mas_left);
        make.size.mas_equalTo(self.ac_imageTag.image.size);
    }];
    [self.ac_tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ac_imageTag.mas_top).offset(-3);
        make.left.equalTo(self.ac_imageTag.mas_right).offset(7);
        make.width.mas_equalTo(maxfW);
        make.height.mas_equalTo(15);
    }];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
