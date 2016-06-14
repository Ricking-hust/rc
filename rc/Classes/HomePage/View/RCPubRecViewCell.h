//
//  RCPubRecViewCell.h
//  rc
//
//  Created by 余笃 on 16/6/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#define kCellIdentifier_PubRecommendCell @"PubRecommendCell"

#import <UIKit/UIKit.h>

@class PublisherModel;
@interface RCPubRecViewCell : UITableViewCell

@property (nonatomic,strong) PublisherModel *pubModel;
@property (nonatomic,strong) UIImageView *publisherPic;
@property (nonatomic,strong) UILabel *pubNameLabel,*pubSignLabel;
@property (nonatomic,strong) UIButton *followBtn;

@end
