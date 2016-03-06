//
//  CZScheduleTableViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZScheduleTableViewDelegate : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) CurrentDevice device;
@end
