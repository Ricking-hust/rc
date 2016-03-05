//
//  CZRemindView.m
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZRemindView.h"

@implementation CZRemindView

- (id)init
{
    if (self = [super init])
    {
        self.label = [[UILabel alloc]init];
        self.label.font = [UIFont systemFontOfSize:14];
        self.img = [[UIImageView alloc]init];
        self.segline = [[UIView alloc]init];
        self.segline.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
        self.img.image = [UIImage imageNamed:@"selectedIcon"];
        self.img.hidden = YES;
        self.isSelected = NO;
        
        [self addSubview:self.label];
        [self addSubview:self.img];
        [self addSubview:self.segline];
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (id)initWithTittle:(NSString *)tittle
{
    if (self = [super init])
    {
        self.label = [[UILabel alloc]init];
        self.img = [[UIImageView alloc]init];
        self.isSelected = NO;
    }
    self.label.text = tittle;
    return self;
}

@end
