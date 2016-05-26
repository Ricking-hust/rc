//
//  RCMyActivityCell.h
//  rc
//
//  Created by AlanZhang on 16/3/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMyActivityCell : UITableViewCell
@property (nonatomic, strong) UIImageView *acImageView;
@property (nonatomic, strong) UILabel *acName;
@property (nonatomic, strong) UILabel *acTime;
@property (nonatomic, strong) UILabel *acPlace;
@property (nonatomic, strong) UILabel *acTag;
@property (nonatomic, strong) UIImageView *acTagImageView;
@property (nonatomic, strong) UIButton  *addSchedule;
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSubView;
- (void)setSubViewConstraint;
@end
