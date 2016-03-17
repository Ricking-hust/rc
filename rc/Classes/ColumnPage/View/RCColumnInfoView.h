//
//  RCColumnInfoView.h
//  rc
//
//  Created by AlanZhang on 16/3/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZTableView;
@class CZLeftTableViewDelegate;
@class CZRightTableViewDelegate;
@interface RCColumnInfoView : UIView
@property(nonatomic, strong) CZTableView *leftTableView;
@property(nonatomic, strong) CZTableView *rightTableView;
@property(nonatomic, strong) CZLeftTableViewDelegate *leftDelegate;
@property(nonatomic, strong) CZRightTableViewDelegate *rightDelegate;
@property(nonatomic, strong) UIView *view;
@end
