//
//  CZActivityCell.m
//  rc
//
//  Created by AlanZhang on 16/2/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivitycell.h"
#import "Masonry.h"
#import "Activity.h"

#define TITLE_FONTSIZE  14  //活动主题字体大小
#define TIME_FONTSIZE   10  //活动时间字体大小
#define PLACE_FONTSIZE  10  //活动地点字体大小
#define TAG_FONTSIZE    10  //活动标签字体大小
#define POSTERIMAGE_WIDTH      120 //Poster的宽度
#define POSTERIMAGE_HEIGHT     120 //poster的高度

@interface CZActivitycell()
@property (nonatomic, weak) UIImageView *ac_poster;
@property (nonatomic, assign) CGSize posterSize;  //存储活动海报的大小
@property (nonatomic, weak) UILabel *ac_title;
@property (nonatomic, weak) UILabel *ac_time;
@property (nonatomic, weak) UILabel *ac_place;
@property (nonatomic, weak) UIImageView *ac_imageTag;
@property (nonatomic, assign) CGSize tagSize;   //存储活动标签图片的大小
@property (nonatomic, weak) UILabel *ac_tags;

//目前不实现浏览量
//@property (nonatomic, weak) UIImageView *ac_viewImage_num;
//@property (nonatomic, weak) UILabel *ac_views_num;
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
        [self.contentView addSubview:self.ac_title];
        
        
        //3.创建ac_time(UILable)
        UILabel *timeLabel = [[UILabel alloc]init];
        self.ac_time = timeLabel;
        [self.contentView addSubview:self.ac_time];
        
        //4.创建ac_place(UILable)
        UILabel *placeLabel = [[UILabel alloc]init];
        
        self.ac_place = placeLabel;
        [self.contentView addSubview:self.ac_place];
        
        //5.创建ac_imageTag(UIImageView)
        UIImageView *tagImage = [[UIImageView alloc]init];
        self.ac_imageTag = tagImage;
        [self.contentView addSubview:self.ac_imageTag];
        
        //6.创建ac_tags(UILable)
        UILabel *tagsLabel = [[UILabel alloc]init];
        self.ac_tags = tagsLabel;
        [self.contentView addSubview:self.ac_tags];
    }
    return self;
}

#pragma mark - 模型

- (void)setActivity:(Activity *)activity
{
    _activity = activity;
    
    [self setSubViewsContent];
    [self setSubViewsConstraint];
}

//设置子控件的内容
- (void)setSubViewsContent
{
    //活动图片
    UIImage *posterImage = [UIImage imageNamed:self.activity.ac_poster];
    self.posterSize = CGSizeMake(POSTERIMAGE_WIDTH, POSTERIMAGE_HEIGHT);
    self.ac_poster.image = posterImage;
    
    //活动主题
    self.ac_title.text = self.activity.ac_title;
    self.ac_title.numberOfLines = 0;
    self.ac_title.font = [UIFont systemFontOfSize:TITLE_FONTSIZE];
    
    //活动时间
    self.ac_time.text = self.activity.ac_time;
    self.ac_time.numberOfLines = 0;
    self.ac_time.font = [UIFont systemFontOfSize:TIME_FONTSIZE];
    
    //活动地点
    self.ac_place.text = self.activity.ac_place;
    self.ac_place.numberOfLines = 0;
    self.ac_place.font = [UIFont systemFontOfSize:PLACE_FONTSIZE];
    //活动标签(图片)
    UIImage *tagImage = [UIImage imageNamed:@"tagImage"];
    self.ac_imageTag.image = tagImage;
    self.tagSize = tagImage.size;
    //活动类型(标签)
    self.ac_tags.text = self.activity.ac_tags;
    self.ac_tags.numberOfLines = 0;
    self.ac_tags.font = [UIFont systemFontOfSize:TAG_FONTSIZE];
    
    
}
//设置子控件的Constraint
- (void)setSubViewsConstraint
{
    //设置cell大小和行高
    [self.contentView setFrame: CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, self.posterSize.height + 20)];
    self.cellHeight = self.posterSize.height + 20;
    
    CGSize textSize;
    //活动主题标签的最大长度
    CGFloat width = [[UIScreen mainScreen]bounds].size.width * 0.48;
    
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    //add ac_poster constraints
    [self.ac_poster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.posterSize);
        make.left.and.top.equalTo(self).with.offset(10);
    }];
    
    //add ac_titile constraints
    
    //计算文本的大小
    textSize = [self sizeWithText:self.activity.ac_title maxSize:maxSize fontSize:TITLE_FONTSIZE];
    [self.ac_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(textSize.width, textSize.height));
        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
        make.top.equalTo(self.mas_top).with.offset(20.0f/2);
    }];
    
    //add ac_time constraints
    textSize = [self sizeWithText:self.activity.ac_time maxSize:maxSize fontSize:TIME_FONTSIZE];
    //    [self.ac_time setFrame:CGRectMake(0, 0, self.ac_poster.frame.size.width, textSize.height)];
    [self.ac_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
        make.top.equalTo(self.ac_title.mas_bottom).with.offset(30.0f/2);
        make.size.mas_equalTo(textSize);
    }];
    
    //add ac_place constraints
    textSize = [self sizeWithText:self.activity.ac_place maxSize:maxSize fontSize:PLACE_FONTSIZE];
    [self.ac_place mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(textSize.width, textSize.height));
        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
        make.top.equalTo(self.ac_time.mas_bottom).with.offset(10.0f/2);
    }];
    
    //add ac_imageTag constraints
    [self.ac_imageTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(self.tagSize.width, self.tagSize.height));
        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0f/2);
        make.top.equalTo(self.ac_place.mas_bottom).with.offset(30.0f/2);
    }];
    
    //add ac_tags constraints
    textSize = [self sizeWithText:self.activity.ac_tags maxSize:textSize fontSize:TAG_FONTSIZE];
    [self.ac_tags mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(textSize.width, textSize.height));
        make.left.equalTo(self.ac_imageTag.mas_right).with.offset(14.0f/2);
        make.top.equalTo(self.ac_place.mas_bottom).with.offset(35.0f/2);
    }];
    
    
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
