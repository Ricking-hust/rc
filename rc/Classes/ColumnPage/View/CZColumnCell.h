//
//  CZColumnCell.h
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZColumnCell : UITableViewCell
@property (nonatomic, strong) UIImageView *acImageView;
@property (nonatomic, strong) UILabel *acNameLabel;
@property (nonatomic, strong) UILabel *acTimeLabel;
@property (nonatomic, strong) UILabel *acPlaceLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *acTagLabel;
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIView *bgView;

/**
 *  类方法 创建可重用的自定义的cell对象
 *
 *  @param tableView cell的所属的tableView
 *
 *  @return 返回实例对象
 */
+ (instancetype)cellWithTableView:(UITableView*)tableView;


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
- (void)setSubviewConstraint;

@end
