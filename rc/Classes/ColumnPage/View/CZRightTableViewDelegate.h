//
//  CZRightTableViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CZRightTableViewDelegate : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIView *view;
@end

