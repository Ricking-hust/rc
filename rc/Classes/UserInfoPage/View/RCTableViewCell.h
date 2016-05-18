//
//  RCTableViewCell.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView  *icon_imageView;
@property (nonatomic, strong) UILabel  *text_label;
@property (nonatomic, strong) UIImageView  *other_imageView;
@property (nonatomic, strong) UIView  *segment_line_view;
- (void)setConstraints;
@end
