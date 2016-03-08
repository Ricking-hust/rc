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

#define TITLE_FONTSIZE  15  //活动主题字体大小
#define TIME_FONTSIZE   12  //活动时间字体大小
#define PLACE_FONTSIZE  12  //活动地点字体大小
#define TAG_FONTSIZE    10  //活动标签字体大小
#define POSTERIMAGE_WIDTH      120 //Poster的宽度
#define POSTERIMAGE_HEIGHT     120 //poster的高度

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
        self.tagSize = Image.size;
        [self.contentView addSubview:self.ac_imageTag];
        
        //6.创建ac_tags(UILable)
        UILabel *tagsLabel = [[UILabel alloc]init];
        self.ac_tags = tagsLabel;
        self.ac_tags.numberOfLines = 0;
        self.ac_tags.font = [UIFont systemFontOfSize:TAG_FONTSIZE];
        [self.contentView addSubview:self.ac_tags];
        self.ac_tags.alpha = 0.8;
        
        self.posterSize = CGSizeMake(POSTERIMAGE_WIDTH, POSTERIMAGE_HEIGHT);
    }
    return self;
}

//设置子控件的Constraint
- (void)setSubViewsConstraint
{
    //最大宽度
    CGFloat maxfW = kScreenWidth - 120 - 60;
    //名字的上边距
    CGFloat tittleTopPadding = 12;
    //1.名字的高度
    CGSize nameSize = [self sizeWithText:self.ac_title.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:TITLE_FONTSIZE];
        //1.1时间与名字之间的间距
    CGFloat paddingToName = 20;
    //2.时间的高度
    CGSize timeSize = [self sizeWithText:self.ac_time.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:TIME_FONTSIZE];
    //3.地点的高度
    CGSize palceSize = [self sizeWithText:self.ac_place.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:PLACE_FONTSIZE];
        //3.1标签与地点之间的间距
    
    //4.标签的高度
    CGSize tagSize = [self sizeWithText:self.ac_tags.text maxSize:CGSizeMake(maxfW, MAXFLOAT) fontSize:TAG_FONTSIZE];
    //标签的下边距
    CGFloat tagBottomPadding = 12;
    //图片的高度
    
    //图片的上边距与下边距，左边距
    
    //cell高度
    self.height = tittleTopPadding + nameSize.height + timeSize.height + palceSize.height + tagSize.height + paddingToName+ 15;
    [self.ac_poster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
    }];
    
//    //设置cell大小和行高
//    [self.contentView setFrame: CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, self.posterSize.height + 20)];
//    self.cellHeight = self.posterSize.height + 20;
//    
//    CGSize textSize;
//    //活动主题标签的最大长度
//    CGFloat width = [[UIScreen mainScreen]bounds].size.width * 0.48;
//    
//    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
//    
//    //add ac_poster constraints
//    [self.ac_poster mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(self.posterSize);
//        make.left.and.top.equalTo(self).with.offset(10);
//    }];
//    
//    //add ac_titile constraints
//    
//    //计算文本的大小
//    textSize = [self sizeWithText:self.ac_title.text maxSize:maxSize fontSize:TITLE_FONTSIZE];
//    [self.ac_title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(textSize.width + 1, textSize.height+1));
//        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
//        make.top.equalTo(self.mas_top).with.offset(10);
//    }];
//    
//    //add ac_time constraints
//
//    textSize = [self sizeWithText:self.ac_title.text maxSize:maxSize fontSize:TIME_FONTSIZE];
//
//    [self.ac_time mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
//        make.top.equalTo(self.ac_title.mas_bottom).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(150,12));
//    }];
//    
//    //add ac_place constraints
//    textSize = [self sizeWithText:self.ac_place.text maxSize:maxSize fontSize:PLACE_FONTSIZE];
//    [self.ac_place mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(150, textSize.height+1));
//        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
//        make.top.equalTo(self.ac_time.mas_bottom).with.offset(5);
//    }];
//    
//    //add ac_imageTag constraints
//    [self.ac_imageTag mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(self.tagSize.width, self.tagSize.height));
//        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
//        make.top.equalTo(self.ac_place.mas_bottom).with.offset(14);
//    }];
//    
//    //add ac_tags constraints
//    textSize = [self sizeWithText:self.ac_tags.text maxSize:textSize fontSize:TAG_FONTSIZE];
//    [self.ac_tags mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(150, textSize.height+1));
//        make.left.equalTo(self.ac_imageTag.mas_right).with.offset(14.0f/2);
//        make.top.equalTo(self.ac_place.mas_bottom).with.offset(12);
//    }];
}

/**
 *  普通函数
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
