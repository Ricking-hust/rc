//
//  CZActivityInfoViewController.h
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface CZActivityInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ActivityModel *activityModelPre;
@end
