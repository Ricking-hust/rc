//
//  CZScheduleInfoCell.h
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZScheduleInfoCell : UITableViewCell
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGFloat height;
@end
