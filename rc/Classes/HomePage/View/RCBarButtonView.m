//
//  RCBarButtonView.m
//  rc
//
//  Created by AlanZhang on 16/3/28.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCBarButtonView.h"
#import "RCBarButton.h"
#import "Masonry.h"
@implementation RCBarButtonView

- (id) init
{
    if (self = [super init])
    {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.button = [[RCBarButton alloc]init];
        self.label = [[UILabel alloc]init];
        [self addSubview:self.button];
        [self addSubview:self.label];
    }
    return self;
}
- (void)setSubView
{
    UIImage *image = [UIImage imageNamed:@"backIcon_white"];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.text = @"活动介绍";
    self.label.textColor = [UIColor whiteColor];
    
    [self.button setImage:image forState:UIControlStateNormal];
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
    }];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(self.mas_height);
    }];
    
}
@end
