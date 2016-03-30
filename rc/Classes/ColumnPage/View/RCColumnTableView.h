//
//  RCColumnTableView.h
//  rc
//
//  Created by AlanZhang on 16/3/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RCColumnTableView : UIView
@property(nonatomic, strong) UITableView *leftTableView;
@property(nonatomic, strong) UITableView *rightTableView;
@property(nonatomic, strong) UIView *view;
@property(nonatomic, strong) NSString *a;
@end
