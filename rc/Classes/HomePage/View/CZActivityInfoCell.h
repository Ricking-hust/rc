//
//  CZActivityInfoCell.h
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityModel;
@interface CZActivityInfoCell : UITableViewCell
@property (nonatomic,strong)ActivityModel *model;
@property (nonatomic, strong)UILabel *placeLabel;
@property (nonatomic, strong)UILabel *ac_placeLabel;
@property (nonatomic, strong)UILabel *sizeLabel;
@property (nonatomic, strong)UILabel *ac_sizeLabel;
@property (nonatomic, strong)UILabel *payLabel;
@property (nonatomic, strong)UILabel *ac_payLabel;
@property (nonatomic,strong) UILabel *speakerLabel;
@property (nonatomic,strong) UILabel *ac_speakerLabel;

/**
 *  类方法 创建可重用的自定义的cell对象
 *
 *  @param tableView cell的所属的tableView
 *
 *  @return 返回实例对象
 */
+ (instancetype)activityCellWithTableView:(UITableView*)tableView;


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
 *  对cell的子控件进行布局
 *
 */
- (void)setSubViewsConstraint;
@end
