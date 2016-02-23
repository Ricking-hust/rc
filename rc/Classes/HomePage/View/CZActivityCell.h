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

@property (nonatomic, strong) Activity *activity;
@property (nonatomic,strong) ActivityModel *activitymodel;
@property (nonatomic, assign) CGFloat cellHeight;

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

///**
// *  实例方法 设置子控件显示的内容
// *
// */
//- (void)setSubViewsContent;

@end
