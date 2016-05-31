//
//  RCScheduleInfoViewController.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDisplayScheduleDelegate.h"
#import "RCModifyScheduleDelegate.h"
@interface RCScheduleInfoViewController : UIViewController<RCDisplayScheduleDelegate>
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) BOOL isContentUpdate;
@property  (nonatomic, weak) id<RCModifyScheduleDelegate> modifyDelegate;
@end
