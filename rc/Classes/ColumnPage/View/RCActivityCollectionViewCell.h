//
//  activityCollectionViewCell.h
//  rc
//
//  Created by 余笃 on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZAcitivityModelOfColumn;

@interface RCActivityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CZAcitivityModelOfColumn *activity;

@property (nonatomic, strong) UIImageView *acImage;
@property (nonatomic, strong) UILabel *acName;
@property (nonatomic, strong) UILabel *acTime;
@property (nonatomic, strong) UILabel *acPlace;
@property (nonatomic, strong) UIImageView *acTagImage;
@property (nonatomic, strong) UILabel *acTag;

@end
