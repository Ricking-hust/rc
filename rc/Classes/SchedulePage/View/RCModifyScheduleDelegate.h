//
//  RCModifyScheduleDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCModifyScheduleDelegate <NSObject>
@optional
- (void)passSchedule:(id)schedule;
- (void)passNodeIndex:(id)nodeIndex;
- (void)passPlanListRanged:(NSMutableArray *)planListRanged;
- (void)passScIndex:(int)index;
- (void)passTimeNodeScrollView:(id)timeNodeSV;
@end
