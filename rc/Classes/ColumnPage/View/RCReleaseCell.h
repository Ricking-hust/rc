//
//  RCReleaseCell.h
//  rc
//
//  Created by AlanZhang on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCReleaseCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *label;
- (void)setSubViewsConstraint;
@end