//
//  CZTimeCourseCell.h
//  rc
//
//  Created by AlanZhang on 16/2/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZData;
@interface CZTimeCourseCell : UITableViewCell

@property (strong, nonatomic) CZData *data;

@property (strong, nonatomic) UILabel *timepUpLine;
@property (strong, nonatomic) UILabel *timepDownLine;

@property (strong, nonatomic) UILabel *timeLine;
@property (strong, nonatomic) UIView *pointView;
@property (strong, nonatomic) UIImageView *currentPoint;
@property (strong, nonatomic) UIImageView *tagImg;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *acTime;
@property (strong, nonatomic) UILabel *acContent;
@property (strong, nonatomic) UIView *bgImage;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *weekLabel;

@property (strong, nonatomic) UIButton *deleteButton;

@property (assign, nonatomic) CGSize cellSize;

@property (assign, nonatomic) BOOL isLastCell;

@property (assign, nonatomic) BOOL isShowDeleteButton;

/**
 *  类方法， 创建自定义的cell
 *
 *  @param tableView cell所在的tableView
 *
 *  @return 返回对象实例
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

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

@end
