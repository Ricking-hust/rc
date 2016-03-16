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
@class CZTagWithLabelView;
@interface CZUpdateScheduleViewController : UIViewController
@property (strong, nonatomic) CZUpView *upView;     //上方View
@property (strong, nonatomic) CZDownView *downView; //下方View

@property (nonatomic, strong) CZTagWithLabelView *meetingTag;
@property (nonatomic, strong) CZTagWithLabelView *appointmentTag;
@property (nonatomic, strong) CZTagWithLabelView *businessTag;
@property (nonatomic, strong) CZTagWithLabelView *sportTag;
@property (nonatomic, strong) CZTagWithLabelView *shoppingTag;
@property (nonatomic, strong) CZTagWithLabelView *entertainmentTag;
@property (nonatomic, strong) CZTagWithLabelView *partTag;
@property (nonatomic, strong) CZTagWithLabelView *otherTag;

#pragma mark - 选择器数据
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *times;


@end
