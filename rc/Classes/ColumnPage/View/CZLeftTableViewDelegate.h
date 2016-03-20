//
//  CZLeftTableViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCLeftTableView;
@class RCRightTableView;
@interface CZLeftTableViewDelegate : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) RCLeftTableView *leftTableView;
@property (nonatomic, strong) RCRightTableView *rightTableView;
@property (nonatomic, assign) CGFloat subHeight;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIView *view;
@end
