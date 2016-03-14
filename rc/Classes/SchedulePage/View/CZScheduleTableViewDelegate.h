//
//  CZScheduleTableViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZScheduleTableViewDelegate : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, strong) NSArray *scArray;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *view;
@end
