//
//  CZScheduleInfoViewController.h
//  rc
//
//  Created by AlanZhang on 16/2/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZScheduleInfoViewController : UIViewController
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSArray *scArray;
@property (nonatomic, assign) int scIndex;
@property (nonatomic,strong) NSMutableArray *planListRanged;
@property (nonatomic, assign) long int timeNodeIndex;
@property (nonatomic, strong) UITableView *timeNodeTableView;
@property (nonatomic, assign) BOOL isContentUpdate;
@end
