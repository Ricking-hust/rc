//
//  CZRemintTimeView.m
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZRemintTimeView.h"

@implementation CZRemintTimeView

- (id)init
{
    if (self = [super init])
    {
        self.label = [[UILabel alloc]init];
        self.time = [[UILabel alloc]init];
        self.img = [[UIImageView alloc]init];
    }
    [self setSubView];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)setSubView
{
    self.label.text = @"提醒时间点";
    self.label.font = [UIFont systemFontOfSize:14];
    self.time.text = @"00:00";
    self.time.font = self.label.font;
    self.img.image = [UIImage imageNamed:@"moreTagbuttonIcon"];
    
    self.label.alpha = 0.3;
    self.time.alpha = 0.3;
    self.img.alpha = 0.3;
    
    [self addSubview:self.label];
    [self addSubview:self.time];
    [self addSubview:self.img];
}
@end
