//
//  CZUpdateScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/2/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZUpView;
@class CZDownView;

@interface CZUpdateScheduleViewController : UIViewController
@property (strong, nonatomic) CZUpView *upView;     //上方View
@property (strong, nonatomic) CZDownView *downView; //下方View

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
