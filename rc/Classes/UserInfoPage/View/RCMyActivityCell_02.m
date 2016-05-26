//
//  RCMyActivityCell_02.m
//  rc
//
//  Created by AlanZhang on 16/5/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyActivityCell_02.h"
#import "Masonry.h"
@implementation RCMyActivityCell_02
- (id)init
{
    if (self = [super init])
    {
        self.addToSchedule = [[UIButton alloc]init];
    }
    return self;
}
- (void)setSubView
{
    [super setSubView];
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    self.addToSchedule.backgroundColor = color;
    self.addToSchedule.layer.cornerRadius = 3.0f;
    [self.addToSchedule setTintColor:[UIColor whiteColor]];
    self.addToSchedule.titleLabel.font = [UIFont systemFontOfSize:14];
    
}
- (void)setSubViewConstraint
{
    [super setSubViewConstraint];
    [self.addToSchedule mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
    
}
@end
