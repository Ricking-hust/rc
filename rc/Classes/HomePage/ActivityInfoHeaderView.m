//
//  ActivityInfoHeaderView.m
//  日常
//
//  Created by AlanZhang on 16/1/12.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "ActivityInfoHeaderView.h"
#import "Activity.h"
#import "Masonry.h"

#define TITLE_FONTSIZE  14  //活动主题字体大小
#define TIME_FONTSIZE   10  //活动时间字体大小
#define PLACE_FONTSIZE  10  //活动地点字体大小
#define TAG_FONTSIZE    10  //活动标签字体大小
#define POSTERIMAGE_WIDTH      120 //Poster的宽度
#define POSTERIMAGE_HEIGHT     120 //poster的高度

@implementation ActivityInfoHeaderView

+ (instancetype)headerView
{
    ActivityInfoHeaderView *headerView = [[ActivityInfoHeaderView alloc]init];
    
    //1.创建ac_poster(UIImageView)
    UIImageView *imageView = [[UIImageView alloc]init];
    headerView.ac_poster = imageView;
    [headerView addSubview:headerView.ac_poster];
    
    //2.创建ac_title(UILable)
    UILabel *nameLabel = [[UILabel alloc]init];
    headerView.ac_title = nameLabel;
    [headerView addSubview:headerView.ac_title];
    
    //3.创建ac_time(UILable)
    UILabel *timeLabel = [[UILabel alloc]init];
    headerView.ac_time = timeLabel;
    [headerView addSubview:headerView.ac_time];
    
    //4.创建ac_place(UILable)
    UILabel *placeLabel = [[UILabel alloc]init];
    headerView.ac_place = placeLabel;
    [headerView addSubview:headerView.ac_place];
    
    //5.创建ac_imageTag(UIImageView)
    UIImageView *tagImage = [[UIImageView alloc]init];
    headerView.ac_imageTag = tagImage;
    [headerView addSubview:headerView.ac_imageTag];
    
    //6.创建ac_tags(UILable)
    UILabel *tagsLabel = [[UILabel alloc]init];
    headerView.ac_tags = tagsLabel;
    [headerView addSubview:headerView.ac_tags];
    
    return headerView;
}

- (void) setView:(Activity*) activity
{
    //设置背景色透明
    self.backgroundColor = [UIColor clearColor];
    UIImage *image= [UIImage imageNamed:activity.ac_poster];
    self.ac_poster.image = image;
    //self.posterSize = image.size;
    self.ac_title.text = activity.ac_title;
    self.ac_title.numberOfLines = 0;
    
    self.ac_time.text = activity.ac_time;
    self.ac_time.numberOfLines = 0;
    
    self.ac_place.text = activity.ac_place;
    self.ac_place.numberOfLines = 0;
    
    self.ac_imageTag.image = [UIImage imageNamed:@"tagImage"];
    self.ac_tags.text = activity.ac_tags;
    self.ac_tags.numberOfLines = 0;
    
    [self setSubViewsConstraint];
}

//设置字控件的约束
- (void)setSubViewsConstraint
{
    CGSize textSize;
    
    //活动主题标签的最大长度
    CGFloat width = [[UIScreen mainScreen]bounds].size.width * 0.48;
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    //设置frame
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 20, 10);
    
    [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 120 + padding.top + padding.bottom)];
    [self.ac_poster setFrame:CGRectMake(0, 0, POSTERIMAGE_WIDTH, POSTERIMAGE_HEIGHT)];
    
    //add ac_poster constraints
    [self.ac_poster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding.left);
        make.top.equalTo(self).with.offset(padding.top);
        make.bottom.equalTo(self).with.offset(-padding.bottom);
    }];
    
    //add ac_title constraint
    NSLog(@"maxwidth is %f, maxheigth is %f", maxSize.width, maxSize.height);
    NSLog(@"screen width is %f", [[UIScreen mainScreen]bounds].size.width);
    NSLog(@"the rest of width is %f",[[UIScreen mainScreen]bounds].size.width - self.ac_poster.frame.size.width - 35);
    
    textSize = [self sizeWithText:self.ac_title.text maxSize:maxSize fontSize:TITLE_FONTSIZE];
    [self.ac_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ac_poster.mas_right).with.offset(10);
        make.top.equalTo(self).with.offset(46.0f/2);
        make.size.mas_equalTo(textSize);
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
    
    NSLog(@"width is %f, heigth is %f", nameSize.width, nameSize.height);
    return nameSize;
}





@end
