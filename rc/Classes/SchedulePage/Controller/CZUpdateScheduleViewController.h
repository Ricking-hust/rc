//
//  CZUpdateScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/2/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZUpdateScheduleViewController : UIViewController
@property (strong, nonatomic) UIView *themeView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIImageView *tagimageView;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UIButton *moreTagButton;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UILabel *limitedLabel;
@property (strong, nonatomic) UIView *segmentView;

@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *timeInfo;
@property (strong, nonatomic) UIButton *moreTimeButton;
@property (strong, nonatomic) UIView *segmentViewReletiveToRv;

@property (strong, nonatomic) UIView *remindView;
@property (strong, nonatomic) UILabel *remindLabel;
@property (strong, nonatomic) UILabel *remindInfo;
@property (strong, nonatomic) UIButton *moreRemindButton;

@property (strong, nonatomic) UIView *timeSelectView;
@property (strong, nonatomic) UIButton *deleteScheduleButton;


#pragma mark - 测试数据
@property (copy, nonatomic) NSString *strThemelabel;
@property (copy, nonatomic) NSString *strContent;
@property (copy, nonatomic) NSString *strTime;
@property (copy, nonatomic) NSString *strRemind;
@property (copy, nonatomic) NSString *strTagImg;

#pragma mark - 选择器数据
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *times;


@end
