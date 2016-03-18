//
//  RCScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAddScheduleDelegate.h"
@interface RCScheduleViewController : UIViewController
@property (nonatomic, assign) BOOL isAddsc;
@property (nonatomic, weak) id<RCAddScheduleDelegate> addscDelegate;
@end
