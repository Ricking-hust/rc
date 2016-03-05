//
//  CZMoreRemindTimeViewController.h
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZRemindView;
@class CZRemintTimeView;
@interface CZMoreRemindTimeViewController : UIViewController
@property (strong, nonatomic) CZRemindView *notRemind;
@property (strong, nonatomic) CZRemindView *beforeOneDay;
@property (strong, nonatomic) CZRemindView *beforeThreeDay;
@property (strong, nonatomic) CZRemindView *beforeFiveDay;
@property (strong, nonatomic) CZRemintTimeView *timeView;
@end
