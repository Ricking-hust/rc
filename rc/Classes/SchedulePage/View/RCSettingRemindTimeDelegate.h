//
//  RCSettingRemindTimeDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCSettingRemindTimeDelegate <NSObject>
@optional
- (void)passModifySchedule:(id)schedule;
@end
