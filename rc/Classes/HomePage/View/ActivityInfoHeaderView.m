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
    
    self.ac_title.text = activity.ac_title;
    self.ac_title.font = [UIFont systemFontOfSize:TITLE_FONTSIZE];
    self.ac_title.numberOfLines = 0;
    
    self.ac_time.text = activity.ac_time;
    self.ac_time.numberOfLines = 0;
    self.ac_time.font = [UIFont systemFontOfSize:TIME_FONTSIZE];
    
    self.ac_place.text = activity.ac_place;
    self.ac_place.numberOfLines = 0;
    self.ac_place.font = [UIFont systemFontOfSize:PLACE_FONTSIZE];
    
    UIImage *tagImage = [UIImage imageNamed:@"tagImage"];
    self.ac_imageTag.image = tagImage;
    self.tagSize = tagImage.size;
    
    self.ac_tags.text = activity.ac_tags;
    self.ac_tags.numberOfLines = 0;
    self.ac_tags.font = [UIFont systemFontOfSize:TAG_FONTSIZE];
    
    [self setSubViewsConstraint];
}

//设置字控件的约束
- (void)setSubViewsConstraint
{
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
#pragma mark  - 测试数据
    NSLog(@"left %f, top %f, rigth %f, bottom %f", padding.left, padding.top, padding.right, padding.bottom);
    //1.设置view的尺寸
    self.backgroundColor = [UIColor clearColor];
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height * 0.25)];
#pragma mark  - 测试数据
    NSLog(@"view frame is %f,%f",self.frame.size.width, self.frame.size.height);
    //2.设置子控件的尺寸
    //添加图片约束
    [self.ac_poster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.left.equalTo(self.mas_left).with.offset(padding.left);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    //添加标题约束
    CGSize title = CGSizeMake(screenSize.width * 0.5, MAXFLOAT);
#pragma mark  - 测试数据
    NSLog(@"max size is %f,%f",title.width , title.height);
    CGSize titleSize = [self sizeWithText:self.ac_title.text maxSize:title fontSize:TITLE_FONTSIZE];
    [self.ac_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(46.0/2);
        make.left.equalTo(self.ac_poster.mas_right).with.offset(50.0/2);
        make.size.mas_equalTo(titleSize);
    }];
    //添加标签图片约束
    [self.ac_imageTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ac_title.mas_bottom).with.offset(94.0/2);
        make.left.equalTo(self.ac_title.mas_left);
        make.size.mas_equalTo(self.tagSize);
    }];
    //添加标签约束
    CGSize tagSize = [self sizeWithText:self.ac_title.text maxSize:title fontSize:TAG_FONTSIZE];
    [self.ac_tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ac_imageTag.mas_top).with.offset(0);
        make.left.equalTo(self.ac_imageTag.mas_right).with.offset(14.0/2);
        make.size.mas_equalTo(tagSize);
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
