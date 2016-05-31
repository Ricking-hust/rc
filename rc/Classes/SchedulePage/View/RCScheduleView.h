//
//  RCScheduleView.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCScrollView;
@class RCTableView;
@interface RCScheduleView : UIView
@property (nonatomic, strong) UIImageView *moreTimeImageiew;
@property (nonatomic, strong) RCScrollView *timeNodeSV;
@property (nonatomic, strong) RCTableView *scheduleTV;
@property (nonatomic, strong) NSMutableArray *planListRanged;
@property (nonatomic, strong) UIImageView *currentPoint;
@end
