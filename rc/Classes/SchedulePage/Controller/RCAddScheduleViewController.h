//
//  RCAddScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/3/19.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCUpdateScheduleViewController.h"
#import "RCAddScheduleDelegate.h"
#import "RCSettingRemindTimeDelegate.h"
@interface RCAddScheduleViewController : RCUpdateScheduleViewController<RCAddScheduleDelegate>
@property (nonatomic, strong) NSMutableArray *planListRangedAdd;
@property (nonatomic, weak) id<RCSettingRemindTimeDelegate> settingRemindDelegate;
@end
