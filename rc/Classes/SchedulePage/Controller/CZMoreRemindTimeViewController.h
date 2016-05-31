//
//  CZMoreRemindTimeViewController.h
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSettingRemindTimeDelegate.h"
@class CZRemindView;
@class CZRemintTimeView;
@interface CZMoreRemindTimeViewController : UIViewController<RCSettingRemindTimeDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) CZRemindView *notRemind;
@property (strong, nonatomic) CZRemindView *beforeOneDay;
@property (strong, nonatomic) CZRemindView *beforeTwoDay;
@property (strong, nonatomic) CZRemindView *beforeThreeDay;
@property (strong, nonatomic) CZRemintTimeView *timeView;
@end
