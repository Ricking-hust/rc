//
//  RCCollectionCell.h
//  rc
//
//  Created by AlanZhang on 16/3/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCollectionCell : UICollectionViewCell
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, strong) UIImageView *acImage;
@property (nonatomic, strong) UILabel *acName;
@property (nonatomic, strong) UILabel *acTime;
@property (nonatomic, strong) UILabel *acPlace;
@property (nonatomic, strong) UILabel *acRelease;
@property (nonatomic, strong) UIImageView *acTagImgeView;
@property (nonatomic, strong) UIView *bgView;
- (void)setSubviewConstraint;
@end
