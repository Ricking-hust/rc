//
//  RCPersonCell.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCPersonCell : UITableViewCell
@property (nonatomic, strong) UIImageView  *person_icon_imageView;
@property (nonatomic, strong) UILabel  *person_ID_lable;
@property (nonatomic, strong) UILabel  *person_signature_lable;
- (void)setConstraint;
@end
