//
//  RCNumWithLabel.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCNumWithLabel : UIView
@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UILabel  *numbers;
- (void)setConstraints;
@end
