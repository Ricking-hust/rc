//
//  CZLeftTableViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZTableView;
@interface CZLeftTableViewDelegate : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CZTableView *leftTableView;
@property (nonatomic, strong) CZTableView *rightTableView;
@property (nonatomic, assign) CGFloat subHeight;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UIView *view;
@end
