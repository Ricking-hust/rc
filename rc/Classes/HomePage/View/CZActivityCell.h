//
//  CZActivityCell.h
//  rc
//
//  Created by AlanZhang on 16/2/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class ActivityModel;

@interface CZActivitycell : UITableViewCell
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

@property (nonatomic, strong) Activity *activity;
@property (nonatomic,strong) ActivityModel *activitymodel;
@property (nonatomic, assign) CGFloat cellHeight;//cell的高度

/**
 *  类方法 创建可重用的自定义的cell对象
 *
 *  @param tableView cell的所属的tableView
 *
 *  @return 返回实例对象
 */
+ (instancetype)activitycellWithTableView:(UITableView*)tableView;


/**
 *  实例方法 重写构造方法，初始化（创建自定义cell内部的子控件）
 *
 *  @param style cell的类型
 *
 *  @param reuseIdentifier 可重用的标识
 *
 *  @return 返回实例对象本身
 */
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  对单元格内的控件进行布局
 */
- (void)setSubViewsConstraint;

@end
