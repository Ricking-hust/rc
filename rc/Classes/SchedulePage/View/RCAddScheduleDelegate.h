//
//  RCAddScheduleDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/19.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCAddScheduleDelegate <NSObject>
@optional
- (void)passPlanListRanged:(NSMutableArray *)planListRanged;
- (void)passTimeNodeScrollView:(id)timeNodeSV;
- (void)passScheduleView:(id)sc;
@end
