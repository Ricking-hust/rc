//
//  CZTimeNodeCell.h
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZTimeNodeCell : UITableViewCell
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *downLineView;
@property (nonatomic, strong) UIView *point;
@property (nonatomic, strong) UIImageView *selectedPoint;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@end
