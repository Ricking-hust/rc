//
//  CZTimeTableViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZScheduleTableViewDelegate;
@interface CZTimeTableViewDelegate : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *timeNodeTableView;
@property (nonatomic, strong) CZScheduleTableViewDelegate *scDelegate;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSArray *scArray;  //scTableView的数据源
@property (nonatomic, strong) UITableView *scTableView;
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isDefualt;
@end
