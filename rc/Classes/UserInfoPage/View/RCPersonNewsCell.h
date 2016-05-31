//
//  RCPersonNewsCell.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCNumWithLabel;
@interface RCPersonNewsCell : UITableViewCell
@property (nonatomic, strong) RCNumWithLabel  *fans;
@property (nonatomic, strong) RCNumWithLabel  *foucs;
@property (nonatomic, strong) RCNumWithLabel  *news;
- (void)setConstraint;
@end
