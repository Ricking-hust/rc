//
//  CZScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZTimeTableViewDelegate;
@class CZScheduleTableViewDelegate;
@interface CZScheduleViewController : UIViewController
@property (nonatomic, assign) long int scIndex;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UITableView *timeNodeTableView;
@property (nonatomic, strong) UITableView *scTableView;
@property (nonatomic, strong) CZTimeTableViewDelegate *timeDelegate;
@property (nonatomic, strong) CZScheduleTableViewDelegate *scDelegate;
//@property (nonatomic, strong) NSArray *scArray;
@end
