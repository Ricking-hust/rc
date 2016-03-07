//
//  CZTimeTableViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZTimeTableViewDelegate : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *timeNodeTableView;
@property (nonatomic, strong) NSMutableArray *array;    //scTableView的数据源
@property (nonatomic, strong) UITableView *scTableView;
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, assign) int indexAtCell;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isUp;
@end
