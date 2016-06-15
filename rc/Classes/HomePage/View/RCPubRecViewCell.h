//
//  RCPubRecViewCell.h
//  rc
//
//  Created by 余笃 on 16/6/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#define kCellIdentifier_PubRecommendCell @"PubRecommendCell"

#import <UIKit/UIKit.h>
#import "PublisherModel.h"
#import "RcFollowedButon.h"

@interface RCPubRecViewCell : UITableViewCell

@property (nonatomic,strong) PublisherModel *pubModel;
@property (nonatomic,strong) UIButton *publisherBtn;
@property (nonatomic,strong) UILabel *pubNameLabel,*pubSignLabel;
@property (nonatomic,strong) RcFollowedButon *followBtn;

@end
