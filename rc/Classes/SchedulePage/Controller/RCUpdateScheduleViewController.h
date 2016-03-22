//
//  RCUpdateScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCModifyScheduleDelegate.h"
#import "RCSettingRemindTimeDelegate.h"
@class CZUpView;
@class CZDownView;
@class CZTagWithLabelView;
@class RCScrollView;
@interface RCUpdateScheduleViewController : UIViewController<RCModifyScheduleDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, weak) id<RCSettingRemindTimeDelegate> settingRemindDelegate;
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


@property (strong, nonatomic) NSArray *updatescArray;
@property (nonatomic,strong) NSMutableArray *planListRangedUpdate;
@property (nonatomic, strong) NSNumber *updateNodeIndex;
@property (nonatomic, assign) int scIndexUpdate;
//@property (nonatomic, strong) RCScrollView *timeNodeSVUpdate;
@end
