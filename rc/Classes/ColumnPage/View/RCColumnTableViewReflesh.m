//
//  RCColumnTableViewReflesh.m
//  rc
//
//  Created by AlanZhang on 16/3/29.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCColumnTableViewReflesh.h"
#import "Masonry.h"
@implementation RCColumnTableViewReflesh

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX).offset(kScreenWidth/4);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    [self.loading mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.mas_left).offset(-5);
        make.centerY.equalTo(self.label.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UIImage *img = [UIImage imageNamed:@"50%loading.gif"];
    [self.logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.mas_left).offset(15);
        make.centerY.equalTo(self.label.mas_centerY);
        make.width.mas_equalTo(img.size.width);
        make.height.mas_equalTo(img.size.height);
    }];
}

@end
