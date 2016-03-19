//
//  CZColumnViewController.h
//  日常
//
//  Created by AlanZhang on 15/12/17.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CZColumnViewController : UIViewController
@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, assign) int tvNumber;
@end