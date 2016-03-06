//
//  CZScheduleInfoView.h
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZScheduleInfoView : UIView
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIView *tagWithImgView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *scNameLabel;
@property (nonatomic, assign) CGFloat scNameH;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *strScName;
- (void)addSubViewConstraint;
@end
