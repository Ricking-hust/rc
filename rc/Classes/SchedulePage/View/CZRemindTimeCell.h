//
//  CZRemindTimeCell.h
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZRemindTimeCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIButton *timeButton;
+ (instancetype)remindTimeCell;
@end
