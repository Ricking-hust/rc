//
//  RCMyActivityCell.h
//  rc
//
//  Created by AlanZhang on 16/3/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMyActivityCell : UITableViewCell
@property (nonatomic, strong) UIImageView *acImageView;
@property (nonatomic, strong) UILabel *acName;
@property (nonatomic, strong) UILabel *acTime;
@property (nonatomic, strong) UILabel *acPlace;
@property (nonatomic, strong) UILabel *acTag;
@property (nonatomic, strong) UIImageView *acTagImageView;
@property (nonatomic, strong) UIButton  *addSchedule;
- (void)setSubViewConstraint;
@end
