//
//  PubInfoHeaderView.h
//  rc
//
//  Created by 余笃 on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublisherModel.h"

@interface PubInfoHeaderView : UIView

@property (nonatomic,strong) UIImageView *publisherPic;
@property (nonatomic,strong) UILabel *pubName;
@property (nonatomic,strong) UILabel *pubSign;
@property (nonatomic,strong) UIButton *follow;
@property (nonatomic,strong) UIButton *activityBy;
@property (nonatomic,strong) UIButton *activityTakeIn;
@property (nonatomic,strong) UIButton *followOf;
@property (nonatomic,strong) UIView *horizonView;
@property (nonatomic,strong) UIView *verticalViewLeft;
@property (nonatomic,strong) UIView *verticalViewRight;
@property (nonatomic,strong) UIView *horizonBottomView;

@property (nonatomic,strong) PublisherModel *pubModel;

- (void)setSubViewsValue;

@end
