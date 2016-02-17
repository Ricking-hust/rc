//
//  CZAddScheduleDelegate.h
//  rc
//
//  Created by AlanZhang on 16/2/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CZAddScheduleDelegate <NSObject>

@optional
- (void)addSchedule:(NSString *)str;

@end
