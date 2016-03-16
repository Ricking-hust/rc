//
//  CZAddScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/2/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZUpdateScheduleViewController.h"

@interface CZAddScheduleViewController : CZUpdateScheduleViewController
@property (nonatomic, strong) NSArray *scArray;
@property (nonatomic,strong) NSMutableArray *planListRanged;
@property (nonatomic, assign) long int timeNodeIndex;
@end
