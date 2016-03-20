//
//  RCColumnTableView.h
//  rc
//
//  Created by AlanZhang on 16/3/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCLeftTableView;
@class RCRightTableView;
@interface RCColumnTableView : UIView
@property(nonatomic, strong) RCLeftTableView *leftTableView;
@property(nonatomic, strong) RCRightTableView *rightTableView;
@property(nonatomic, strong) UIView *view;
@property(nonatomic, strong) NSMutableDictionary *tableViewSate;//存储tableView的加载是否完成
@end
