//
//  CZActivityOfColumn.h
//  rc
//
//  Created by AlanZhang on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZAcitivityModelOfColumn;
@interface CZActivityOfColumn : UIView

@property (nonatomic, strong) CZAcitivityModelOfColumn *activity;

@property (nonatomic, strong) UIImageView *acImage;
@property (nonatomic, strong) UILabel *acName;
@property (nonatomic, strong) UILabel *acTime;
@property (nonatomic, strong) UILabel *acPlace;
@property (nonatomic, strong) UIImageView *acTagImage;
@property (nonatomic, strong) UILabel *acTag;

@property (nonatomic, assign) CGFloat heigth;
@property (nonatomic, assign) CGFloat width;

/**
 *  类方法，创建封装的activityView
 *
 *  @return 返回对象
 */
+ (instancetype)activityView;

@end
