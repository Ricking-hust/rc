//
//  CZActivityInfoViewController.h
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class ActivityModel;

@interface CZActivityInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityModel *activityModelPre;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end
