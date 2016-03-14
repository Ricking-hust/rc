//
//  RCColumnInfoView.h
//  rc
//
//  Created by AlanZhang on 16/3/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZTableView;
@interface RCColumnInfoView : UIView
@property(nonatomic, strong) CZTableView *leftTableView;
@property(nonatomic, strong) CZTableView *rightTableView;
@end
