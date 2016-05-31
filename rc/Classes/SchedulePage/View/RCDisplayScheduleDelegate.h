//
//  RCDisplayScheduleDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCDisplayScheduleDelegate <NSObject>
@optional
- (void)show:(PlanModel *)data;
- (void)passScArray:(NSMutableArray *)scArray;
- (void)passScIndex:(int)index;
- (void)passTableView:(id)tableView;
- (void)passTimeNodeScrollView:(id)timeNodeSV;
- (void)passNodeIndex:(id)nodeIndex;
- (void)passPlanListRanged:(NSMutableArray *)planListRanged;
@end
