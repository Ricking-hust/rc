//
//  ActivityInfoHeaderView.h
//  日常
//
//  Created by AlanZhang on 16/1/12.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Activity;

@interface ActivityInfoHeaderView : UIView

@property (nonatomic, weak) UIImageView *ac_poster;
@property (nonatomic, assign) CGSize posterSize;  //存储活动海报的大小
@property (nonatomic, weak) UILabel *ac_title;
@property (nonatomic, weak) UILabel *ac_time;
@property (nonatomic, weak) UILabel *ac_place;
@property (nonatomic, weak) UIImageView *ac_imageTag;
@property (nonatomic, assign) CGSize tagSize;   //存储活动标签图片的大小
@property (nonatomic, weak) UILabel *ac_tags;

@property(nonatomic, weak)UIView *segmentation;

//目前不实现浏览量
//@property (nonatomic, weak) UIImageView *ac_viewImage_num;
//@property (nonatomic, weak) UILabel *ac_views_num;


/**
 *	类方法
 *
 *	@return	返回实例对象
 */
+ (instancetype) headerView;

//设置字控件的值
- (void) setView:(Activity*) activity;
@end
